import Foundation

actor SupabaseStoryCache {
  static let shared = SupabaseStoryCache()

  private let databaseActor: StoryDatabaseActor

  init(databaseActor: StoryDatabaseActor = .shared) {
    self.databaseActor = databaseActor
  }

  func load(language: String) async -> [StoryCollection]? {
    let collections = try? await databaseActor.loadCollections(language: language)
    guard let collections, !collections.isEmpty else { return nil }
    return SupabaseStoryDataMapper.markFinalChapters(in: collections)
  }

  func save(_ collections: [StoryCollection], language: String) async {
    let normalized = SupabaseStoryDataMapper.markFinalChapters(in: collections)
    try? await databaseActor.saveCollections(normalized, language: language, replaceExisting: true)
  }

  @discardableResult
  func merge(_ newCollections: [StoryCollection], language: String) async -> [StoryCollection] {
    let normalized = SupabaseStoryDataMapper.markFinalChapters(in: newCollections)
    let merged = try? await databaseActor.mergeCollections(normalized, language: language)
    return (merged.flatMap { SupabaseStoryDataMapper.markFinalChapters(in: $0) }) ?? normalized
  }

  func updateChapters(_ chapters: [StoryChapter], for collectionID: UUID, language: String? = nil) async {
    let marked = SupabaseStoryDataMapper.markFinalChapters(in: chapters)
    try? await databaseActor.updateChapters(marked, for: collectionID)
  }

  func isCacheMatchingServer(
    cached: [StoryCollection],
    serverVersions: [CollectionVersionDTO],
    filterLanguage: String?
  ) async -> Bool {
    await databaseActor.isCacheMatchingServer(
      cached: cached,
      serverVersions: serverVersions,
      filterLanguage: filterLanguage
    )
  }

  func clear() async {
    try? await databaseActor.clearCuratedCache()
  }
}
