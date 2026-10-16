import Foundation
import Observation

@MainActor
@Observable
final class StoryLibrary {
  private(set) var chapters: [StoryChapter]
  private(set) var isGenerating = false
  private(set) var generatingIllustrationIDs: Set<UUID> = []
  private(set) var illustrationRevision = 0

  private let archive: StoryArchive
  private let dependencies: StoryLibraryDependencies
  @ObservationIgnored private var illustrationTasks: [UUID: Task<Void, Never>] = [:]

  var latestChapter: StoryChapter? {
    chapters.last
  }

  init(
    archive: StoryArchive = StoryArchive(),
    dependencies: StoryLibraryDependencies = .live,
    preloadSynchronously: Bool = true
  ) {
    self.archive = archive
    self.dependencies = dependencies
    chapters = preloadSynchronously ? archive.load() : []
  }

  func reloadFromArchive() async {
    let loaded = await archive.loadAsync()
    chapters = loaded
  }

  @discardableResult
  func generateNextChapter(
    preferences: StoryPreferences,
    options: StoryGenerationOptions,
    customIdea: String? = nil
  ) async throws -> StoryChapter {
    try beginGeneration()
    defer { isGenerating = false }
    let request = makeRequest(preferences: preferences, customIdea: customIdea)
    let draft = try await dependencies.generateStory(request, options)
    try Task.checkCancellation()
    return try save(draft, options: options)
  }

  private func beginGeneration() throws {
    guard !isGenerating else { throw StoryGenerationError.alreadyGenerating }
    isGenerating = true
  }

  private func makeRequest(preferences: StoryPreferences, customIdea: String?) -> StoryGenerationRequest {
    StoryGenerationRequest(preferences: preferences, customIdea: customIdea, selectedFactors: StoryCombinators.randomRoll())
  }

  private func save(_ draft: StoryDraft, options: StoryGenerationOptions) throws -> StoryChapter {
    let chapter = makeChapter(from: draft)
    try archive.save(chapter, illustrationData: nil)
    chapters.append(chapter)
    if options.provider == .gemini {
      generateIllustration(for: chapter, draft: draft, apiKey: options.geminiAPIKey ?? "")
    }
    return chapter
  }

  private func makeChapter(from draft: StoryDraft) -> StoryChapter {
    let nextNumber = (chapters.map(\.number).max() ?? 0) + 1
    return StoryChapter(
      id: UUID(),
      number: nextNumber,
      seriesTitle: draft.seriesTitle,
      title: draft.chapterTitle,
      summary: draft.summary,
      paragraphs: draft.paragraphs,
      illustrationPrompt: draft.illustrationPrompt,
      illustrationFilename: "\(UUID().uuidString).image",
      generatedAt: .now,
      source: .generated
    )
  }

  private func generateIllustration(for chapter: StoryChapter, draft: StoryDraft, apiKey: String) {
    generatingIllustrationIDs.insert(chapter.id)
    illustrationTasks[chapter.id] = Task { @MainActor [weak self] in
      await self?.createIllustration(for: chapter, draft: draft, apiKey: apiKey)
    }
  }

  private func createIllustration(for chapter: StoryChapter, draft: StoryDraft, apiKey: String) async {
    defer { finishIllustration(for: chapter.id) }
    do {
      let data = try await dependencies.generateIllustration(draft, apiKey)
      guard !Task.isCancelled else { return }
      try archive.saveIllustration(data, filename: chapter.illustrationFilename)
      illustrationRevision += 1
    } catch is CancellationError {
      return
    } catch {
      logIllustrationFailure(error)
    }
  }

  private func finishIllustration(for chapterID: UUID) {
    generatingIllustrationIDs.remove(chapterID)
    illustrationTasks[chapterID] = nil
  }

  private func logIllustrationFailure(_ error: any Error) {
    #if DEBUG
    print("Illustration generation failed: \(error.localizedDescription)")
    #endif
  }

  func deleteChapter(id: UUID) {
    illustrationTasks[id]?.cancel()
    illustrationTasks[id] = nil
    generatingIllustrationIDs.remove(id)

    guard let chapter = chapters.first(where: { $0.id == id }) else { return }
    archive.delete(chapter)
    chapters.removeAll(where: { $0.id == id })
    illustrationRevision += 1
  }

  func resetAllChapters() {
    for task in illustrationTasks.values {
      task.cancel()
    }
    illustrationTasks.removeAll()
    generatingIllustrationIDs.removeAll()

    archive.deleteAll()
    chapters.removeAll()
    illustrationRevision += 1
  }
}

struct StoryLibraryDependencies {
  var generateStory: @MainActor (StoryGenerationRequest, StoryGenerationOptions) async throws -> StoryDraft
  var generateIllustration: @MainActor (StoryDraft, String) async throws -> Data

  static var live: StoryLibraryDependencies {
    StoryLibraryDependencies(
      generateStory: { try await StoryGenerator.generate(request: $0, options: $1) },
      generateIllustration: { try await StoryGenerator.generateGeminiIllustration(for: $0, apiKey: $1) }
    )
  }
}
