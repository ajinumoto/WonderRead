import Foundation
import SwiftData

struct StoryArchive {
  private let fileManager: FileManager
  private let storiesDirectory: URL
  private let modelContainer: ModelContainer
  private let databaseActor: StoryDatabaseActor

  init(
    modelContainer: ModelContainer = StoryDatabaseContainer.shared,
    databaseActor: StoryDatabaseActor? = nil,
    storiesDirectory: URL? = nil,
    fileManager: FileManager = .default
  ) {
    self.modelContainer = modelContainer
    self.databaseActor = databaseActor ?? StoryDatabaseActor(modelContainer: modelContainer)
    self.fileManager = fileManager
    self.storiesDirectory = storiesDirectory ?? Self.defaultStoriesDirectory(using: fileManager)
  }

  private var illustrationsDirectory: URL {
    storiesDirectory.appendingPathComponent("Illustrations", isDirectory: true)
  }

  @MainActor
  func load() -> [StoryChapter] {
    let descriptor = StoryDatabaseQueryMapper.generatedChaptersDescriptor()
    guard let entities = try? modelContainer.mainContext.fetch(descriptor) else { return [] }
    return entities.map(StoryDatabaseDataMapper.toDomain)
  }

  func loadAsync() async -> [StoryChapter] {
    (try? await databaseActor.loadGeneratedChapters()) ?? []
  }

  @MainActor
  func save(_ chapter: StoryChapter, illustrationData: Data?) throws {
    try ensureDirectoriesExist()
    try saveIllustrationFileIfNeeded(illustrationData, filename: chapter.illustrationFilename)
    try saveChapterToDatabase(chapter)
  }

  func saveIllustration(_ data: Data, filename: String) throws {
    try ensureDirectoriesExist()
    try saveIllustrationFileIfNeeded(data, filename: filename)
  }

  private func ensureDirectoriesExist() throws {
    do {
      try fileManager.createDirectory(at: illustrationsDirectory, withIntermediateDirectories: true)
    } catch {
      throw StoryGenerationError.archiveFailed
    }
  }

  private func saveIllustrationFileIfNeeded(_ data: Data?, filename: String) throws {
    guard let data, let safeName = Self.sanitizedFilename(filename) else { return }
    do {
      let imageURL = illustrationsDirectory.appendingPathComponent(safeName)
      try data.write(to: imageURL, options: .atomic)
    } catch {
      throw StoryGenerationError.archiveFailed
    }
  }

  @MainActor
  private func saveChapterToDatabase(_ chapter: StoryChapter) throws {
    let context = modelContainer.mainContext
    let targetID = chapter.id
    let predicate = #Predicate<StoryChapterEntity> { $0.id == targetID }
    var descriptor = FetchDescriptor<StoryChapterEntity>(predicate: predicate)
    descriptor.fetchLimit = 1
    if let existing = try? context.fetch(descriptor).first {
      updateExistingChapter(existing, from: chapter)
    } else {
      context.insert(StoryDatabaseDataMapper.toEntity(chapter: chapter))
    }
    try persistContext(context)
  }

  private func updateExistingChapter(_ existing: StoryChapterEntity, from chapter: StoryChapter) {
    existing.number = chapter.number
    existing.seriesTitle = chapter.seriesTitle
    existing.title = chapter.title
    existing.summary = chapter.summary
    existing.paragraphs = chapter.paragraphs
    existing.illustrationPrompt = chapter.illustrationPrompt
    existing.illustrationFilename = chapter.illustrationFilename
    existing.generatedAt = chapter.generatedAt
    existing.sourceRawValue = chapter.source?.rawValue ?? StoryChapterSource.generated.rawValue
    existing.isFinalInCollection = chapter.isFinalInCollection
  }

  private func persistContext(_ context: ModelContext) throws {
    do {
      try context.save()
    } catch {
      throw StoryGenerationError.archiveFailed
    }
  }

  @MainActor
  func delete(_ chapter: StoryChapter) {
    deleteIllustrationFile(named: chapter.illustrationFilename)
    let context = modelContainer.mainContext
    let targetID = chapter.id
    let predicate = #Predicate<StoryChapterEntity> { $0.id == targetID }
    var descriptor = FetchDescriptor<StoryChapterEntity>(predicate: predicate)
    descriptor.fetchLimit = 1
    guard let entity = try? context.fetch(descriptor).first else { return }
    context.delete(entity)
    try? context.save()
  }

  private func deleteIllustrationFile(named filename: String) {
    guard let safeName = Self.sanitizedFilename(filename) else { return }
    let imageURL = illustrationsDirectory.appendingPathComponent(safeName)
    try? fileManager.removeItem(at: imageURL)
  }

  @MainActor
  func deleteAll() {
    deleteIllustrationsDirectory()
    let context = modelContainer.mainContext
    let descriptor = StoryDatabaseQueryMapper.generatedChaptersDescriptor()
    guard let chapters = try? context.fetch(descriptor) else { return }
    for chapter in chapters {
      context.delete(chapter)
    }
    try? context.save()
  }

  private func deleteIllustrationsDirectory() {
    guard fileManager.fileExists(atPath: storiesDirectory.path) else { return }
    try? fileManager.removeItem(at: storiesDirectory)
    try? fileManager.createDirectory(at: illustrationsDirectory, withIntermediateDirectories: true)
  }

  static func sanitizedFilename(_ filename: String) -> String? {
    let base = (filename as NSString).lastPathComponent.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !base.isEmpty, base != ".", base != ".." else { return nil }
    return base
  }

  static func illustrationURL(
    for filename: String,
    storiesDirectory: URL? = nil,
    fileManager: FileManager = .default
  ) -> URL? {
    guard let safeName = sanitizedFilename(filename) else { return nil }
    let directory = (storiesDirectory ?? defaultStoriesDirectory(using: fileManager))
      .appendingPathComponent("Illustrations", isDirectory: true)
    let url = directory.appendingPathComponent(safeName)
    guard url.standardizedFileURL.path.hasPrefix(directory.standardizedFileURL.path) else { return nil }
    return fileManager.fileExists(atPath: url.path) ? url : nil
  }

  private static func defaultStoriesDirectory(using fileManager: FileManager) -> URL {
    let supportDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
    return supportDirectory.appendingPathComponent("WonderRead/Stories", isDirectory: true)
  }
}
