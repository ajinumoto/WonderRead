import Foundation
import SwiftData
import Testing
@testable import WonderRead

@MainActor
struct StoryArchiveTests {
  @Test func savesAndLoadsChaptersSortedByNumber() throws {
    let root = temporaryDirectory()
    defer { try? FileManager.default.removeItem(at: root) }
    let archive = try makeArchive(root: root)
    try archive.save(StoryFixtures.chapter(number: 3), illustrationData: nil)
    try archive.save(StoryFixtures.chapter(number: 1), illustrationData: nil)
    #expect(archive.load().map(\.number) == [1, 3])
  }

  @Test func loadsChaptersAsynchronouslyOffMainThread() async throws {
    let root = temporaryDirectory()
    defer { try? FileManager.default.removeItem(at: root) }
    let archive = try makeArchive(root: root)
    try archive.save(StoryFixtures.chapter(number: 2), illustrationData: nil)
    try archive.save(StoryFixtures.chapter(number: 1), illustrationData: nil)
    let loaded = await archive.loadAsync()
    #expect(loaded.map(\.number) == [1, 2])
  }

  @Test func savesResolvesAndLoadsIllustrationData() async throws {
    let root = temporaryDirectory()
    defer { try? FileManager.default.removeItem(at: root) }
    let archive = try makeArchive(root: root)
    let bytes = Data([1, 2, 3, 4])
    try archive.saveIllustration(bytes, filename: "art.png")
    let url = try #require(StoryArchive.illustrationURL(for: "art.png", storiesDirectory: root))
    let resolved = StoryImageLoader.resolveURL(for: " art.png ", storiesDirectory: root)
    let loaded = await StoryImageLoader.loadImageData(for: "art.png", storiesDirectory: root)
    #expect(resolved == url)
    #expect(loaded == bytes)
  }

  @Test func rejectsPathTraversalFilenamesInIllustrationURL() throws {
    let root = temporaryDirectory()
    defer { try? FileManager.default.removeItem(at: root) }
    #expect(StoryArchive.illustrationURL(for: "../secret.plist", storiesDirectory: root) == nil)
    #expect(StoryArchive.illustrationURL(for: "../../etc/passwd", storiesDirectory: root) == nil)
    #expect(StoryArchive.illustrationURL(for: "..", storiesDirectory: root) == nil)
    #expect(StoryArchive.illustrationURL(for: ".", storiesDirectory: root) == nil)
  }

  @Test func deletesOneChapterAndItsIllustration() throws {
    let root = temporaryDirectory()
    defer { try? FileManager.default.removeItem(at: root) }
    let archive = try makeArchive(root: root)
    let chapter = StoryFixtures.chapter(illustrationFilename: "art.png")
    try archive.save(chapter, illustrationData: Data([9]))
    archive.delete(chapter)
    #expect(archive.load().isEmpty)
    #expect(StoryArchive.illustrationURL(for: "art.png", storiesDirectory: root) == nil)
  }

  @Test func deleteAllClearsStoriesAndRecreatesIllustrationDirectory() throws {
    let root = temporaryDirectory()
    defer { try? FileManager.default.removeItem(at: root) }
    let archive = try makeArchive(root: root)
    try archive.save(StoryFixtures.chapter(), illustrationData: nil)
    archive.deleteAll()
    #expect(archive.load().isEmpty)
    #expect(FileManager.default.fileExists(atPath: root.appendingPathComponent("Illustrations").path))
  }

  @Test func reportsArchiveErrorsWhenStorageRootIsAFile() throws {
    let root = temporaryDirectory()
    try Data([0]).write(to: root)
    defer { try? FileManager.default.removeItem(at: root) }
    let archive = try makeArchive(root: root)
    expectArchiveFailure { try archive.save(StoryFixtures.chapter(), illustrationData: nil) }
  }

  @Test func updatesExistingChapterAndIgnoresCuratedChapters() throws {
    let root = temporaryDirectory()
    defer { try? FileManager.default.removeItem(at: root) }
    let container = try StoryDatabaseContainer.makeInMemory()
    let archive = StoryArchive(modelContainer: container, storiesDirectory: root)
    let chapterID = UUID()
    try archive.save(StoryFixtures.chapter(id: chapterID, number: 1, title: "Initial"), illustrationData: nil)
    try archive.save(StoryFixtures.chapter(id: chapterID, number: 1, title: "Updated"), illustrationData: nil)
    container.mainContext.insert(
      StoryDatabaseDataMapper.toEntity(chapter: StoryFixtures.chapter(number: 2, source: .curated))
    )
    try container.mainContext.save()
    let loaded = archive.load()
    #expect(loaded.count == 1)
    #expect(loaded.first?.title == "Updated")
  }
}

private func makeArchive(root: URL) throws -> StoryArchive {
  let container = try StoryDatabaseContainer.makeInMemory()
  return StoryArchive(modelContainer: container, storiesDirectory: root)
}

private func expectArchiveFailure(_ action: () throws -> Void) {
  do {
    try action()
    Issue.record("Expected an inaccessible archive location to fail.")
  } catch StoryGenerationError.archiveFailed {
  } catch {
    Issue.record("Unexpected error: \(error)")
  }
}

private func temporaryDirectory() -> URL {
  FileManager.default.temporaryDirectory.appendingPathComponent("WonderReadArchive-\(UUID().uuidString)", isDirectory: true)
}

@MainActor
struct StoryLibraryTests {
  @Test func generatesAndPersistsTheNextStory() async throws {
    let (root, library) = try makeLibrary(generate: { _, _ in storyDraft() })
    defer { try? FileManager.default.removeItem(at: root) }
    let chapter = try await library.generateNextChapter(preferences: StoryFixtures.preferences(), options: localOptions())
    #expect(chapter.number == 1)
    #expect(chapter.title == "A New Star")
    #expect(library.chapters == [chapter])
    #expect(library.isGenerating == false)
  }

  @Test func assignsMonotonicChapterNumberAfterDeletingMiddleChapter() async throws {
    let (root, library) = try makeLibrary(generate: { _, _ in storyDraft() })
    defer { try? FileManager.default.removeItem(at: root) }
    let first = try await library.generateNextChapter(preferences: StoryFixtures.preferences(), options: localOptions())
    let second = try await library.generateNextChapter(preferences: StoryFixtures.preferences(), options: localOptions())
    let third = try await library.generateNextChapter(preferences: StoryFixtures.preferences(), options: localOptions())
    let initialNumbers: [Int] = [first.number, second.number, third.number]
    #expect(initialNumbers == [1, 2, 3])

    library.deleteChapter(id: second.id)
    let fourth = try await library.generateNextChapter(preferences: StoryFixtures.preferences(), options: localOptions())
    #expect(fourth.number == 4)
    let remainingNumbers: [Int] = library.chapters.map(\.number)
    #expect(remainingNumbers == [1, 3, 4])
  }

  @Test func clearsGenerationStateAfterProviderFailure() async throws {
    let (root, library) = try makeLibrary(generate: { _, _ in throw StoryGenerationError.invalidResponse })
    defer { try? FileManager.default.removeItem(at: root) }
    await expectGenerationFailure(library, options: localOptions())
    #expect(library.isGenerating == false)
    #expect(library.chapters.isEmpty)
  }

  @Test func rejectsConcurrentGenerationRequests() async throws {
    let (root, library) = try makeLibrary(generate: { _, _ in
      try await Task.sleep(for: .milliseconds(100))
      return storyDraft()
    })
    defer { try? FileManager.default.removeItem(at: root) }
    let first = Task { try await library.generateNextChapter(preferences: StoryFixtures.preferences(), options: localOptions()) }
    try await Task.sleep(for: .milliseconds(10))
    await expectAlreadyGenerating(library, options: localOptions())
    _ = try await first.value
  }

  @Test func savesGeneratedIllustrationAndUpdatesRevision() async throws {
    let image = try #require(Data(base64Encoded: "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAADUlEQVR4nGP4z8AAAAMBAQDJ/pLvAAAAAElFTkSuQmCC"))
    let (root, library) = try makeLibrary(generate: { _, _ in storyDraft() }, illustrate: { _, _ in image })
    defer { try? FileManager.default.removeItem(at: root) }
    let chapter = try await library.generateNextChapter(preferences: StoryFixtures.preferences(), options: geminiOptions())
    await waitForIllustrationCompletion(chapter.id, in: library)
    #expect(library.illustrationRevision == 1)
    #expect(StoryArchive.illustrationURL(for: chapter.illustrationFilename, storiesDirectory: root) != nil)
  }

  @Test func clearsIllustrationProgressAfterProviderFailure() async throws {
    let (root, library) = try makeLibrary(generate: { _, _ in storyDraft() }, illustrate: { _, _ in throw TestIllustrationError.failed })
    defer { try? FileManager.default.removeItem(at: root) }
    let chapter = try await library.generateNextChapter(preferences: StoryFixtures.preferences(), options: geminiOptions())
    await waitForIllustrationCompletion(chapter.id, in: library)
    #expect(library.generatingIllustrationIDs.isEmpty)
    #expect(library.illustrationRevision == 0)
    #expect(library.chapters == [chapter])
  }

  @Test func loadsLatestChapterAndDeletesSelectedChapter() throws {
    let root = temporaryDirectory()
    defer { try? FileManager.default.removeItem(at: root) }
    let archive = try makeArchive(root: root)
    let chapter = StoryFixtures.chapter(number: 2)
    try archive.save(chapter, illustrationData: nil)
    let library = StoryLibrary(archive: archive)
    #expect(library.latestChapter?.id == chapter.id)
    library.deleteChapter(id: chapter.id)
    #expect(library.chapters.isEmpty)
  }

  @Test func resettingLibraryClearsAllPersistedChapters() throws {
    let root = temporaryDirectory()
    defer { try? FileManager.default.removeItem(at: root) }
    let archive = try makeArchive(root: root)
    try archive.save(StoryFixtures.chapter(), illustrationData: nil)
    let library = StoryLibrary(archive: archive)
    library.resetAllChapters()
    #expect(library.chapters.isEmpty)
    #expect(archive.load().isEmpty)
  }

  private func makeLibrary(
    generate: @escaping @MainActor (StoryGenerationRequest, StoryGenerationOptions) async throws -> StoryDraft,
    illustrate: @escaping @MainActor (StoryDraft, String) async throws -> Data = { _, _ in Data() }
  ) throws -> (URL, StoryLibrary) {
    let root = temporaryDirectory()
    let dependencies = StoryLibraryDependencies(generateStory: generate, generateIllustration: illustrate)
    let container = try StoryDatabaseContainer.makeInMemory()
    let archive = StoryArchive(modelContainer: container, storiesDirectory: root)
    return (root, StoryLibrary(archive: archive, dependencies: dependencies))
  }

  private func storyDraft() -> StoryDraft {
    StoryDraft(seriesTitle: "Moon Garden", chapterTitle: "A New Star", paragraphs: ["One.", "Two.", "The end!"])
  }

  private func localOptions() -> StoryGenerationOptions {
    StoryGenerationOptions(provider: .local, geminiAPIKey: nil, geminiModel: "unused", outputTokenLimit: 800, language: "English")
  }

  private func geminiOptions() -> StoryGenerationOptions {
    StoryGenerationOptions(provider: .gemini, geminiAPIKey: "test-key", geminiModel: "unused", outputTokenLimit: 800, language: "English")
  }

  private func waitForIllustrationCompletion(_ id: UUID, in library: StoryLibrary) async {
    for _ in 0..<200 where library.generatingIllustrationIDs.contains(id) {
      try? await Task.sleep(for: .milliseconds(5))
    }
    #expect(library.generatingIllustrationIDs.contains(id) == false)
  }
}

@MainActor
private func expectGenerationFailure(_ library: StoryLibrary, options: StoryGenerationOptions) async {
  do {
    _ = try await library.generateNextChapter(preferences: StoryFixtures.preferences(), options: options)
    Issue.record("Expected story generation to fail.")
  } catch StoryGenerationError.invalidResponse {
  } catch {
    Issue.record("Unexpected error: \(error)")
  }
}

@MainActor
private func expectAlreadyGenerating(_ library: StoryLibrary, options: StoryGenerationOptions) async {
  do {
    _ = try await library.generateNextChapter(preferences: StoryFixtures.preferences(), options: options)
    Issue.record("Expected a second generation request to be rejected.")
  } catch StoryGenerationError.alreadyGenerating {
  } catch {
    Issue.record("Unexpected error: \(error)")
  }
}

private enum TestIllustrationError: Error {
  case failed
}
