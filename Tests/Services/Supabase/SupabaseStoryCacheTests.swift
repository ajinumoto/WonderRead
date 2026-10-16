import Foundation
import SwiftData
import Testing
@testable import WonderRead

struct SupabaseStoryCacheTests {
  @Test func savesLoadsNormalizesFinalChapterAndClears() async throws {
    let cache = try makeTestCache()
    let chapters = [StoryFixtures.chapter(number: 1, source: .curated), StoryFixtures.chapter(number: 2, source: .curated)]
    let collection = StoryFixtures.collection(chapters: chapters)
    await cache.save([collection], language: "EN")
    let loaded = try #require(await cache.load(language: "en"))
    #expect(loaded[0].chapters[1].isFinalCuratedChapter)
    await cache.clear()
    #expect(await cache.load(language: "en") == nil)
  }

  @Test func mergesPaginatedCollectionsAndUpdatesHydratedChapters() async throws {
    let cache = try makeTestCache()
    let firstID = UUID()
    let secondID = UUID()
    let first = StoryFixtures.collection(id: firstID, slug: "first", title: "Zebra Tales", chapters: [])
    let second = StoryFixtures.collection(id: secondID, slug: "second", title: "Apple Orchard", chapters: [])

    await cache.save([first], language: "en")
    let merged = await cache.merge([first, second], language: "en")
    #expect(merged.map(\.id) == [firstID, secondID])

    let hydratedChapters = [
      StoryFixtures.chapter(number: 1, source: .curated),
      StoryFixtures.chapter(number: 2, source: .curated)
    ]
    await cache.updateChapters(hydratedChapters, for: secondID, language: "en")
    let reloaded = try #require(await cache.load(language: "en"))
    #expect(reloaded[1].chapters.count == 2)
    #expect(reloaded[1].chapters[1].isFinalCuratedChapter)

    await cache.save([second], language: "en")
    let replaced = try #require(await cache.load(language: "en"))
    #expect(replaced.map(\.id) == [secondID])
  }

  @Test func missingCacheReturnsNil() async throws {
    let cache = try makeTestCache()
    #expect(await cache.load(language: "en") == nil)
  }

  @Test func matchesServerVersionsAcrossOptionalLanguageFilter() async throws {
    let id = UUID()
    let cached = [StoryFixtures.collection(id: id, language: "en", version: 4)]
    let versions = [CollectionVersionDTO(id: id, version: 4, language: "en")]
    let cache = try makeTestCache()
    #expect(await cache.isCacheMatchingServer(cached: cached, serverVersions: versions, filterLanguage: nil))
    #expect(await cache.isCacheMatchingServer(cached: cached, serverVersions: versions, filterLanguage: "en"))
    #expect(await cache.isCacheMatchingServer(cached: cached, serverVersions: versions, filterLanguage: "id") == false)
  }

  @Test func rejectsEmptyAndVersionOrCountMismatch() async throws {
    let id = UUID()
    let cached = [StoryFixtures.collection(id: id, version: 2)]
    let cache = try makeTestCache()
    let changed = [CollectionVersionDTO(id: id, version: 3, language: "en")]
    let extra = changed + [CollectionVersionDTO(id: UUID(), version: 2, language: "en")]
    #expect(await cache.isCacheMatchingServer(cached: [], serverVersions: changed, filterLanguage: nil) == false)
    #expect(await cache.isCacheMatchingServer(cached: cached, serverVersions: changed, filterLanguage: nil) == false)
    #expect(await cache.isCacheMatchingServer(cached: cached, serverVersions: extra, filterLanguage: nil) == false)
  }

  @Test func handlesLargeVolumeCollectionsAndChapters() async throws {
    let container = try StoryDatabaseContainer.makeInMemory()
    let actor = StoryDatabaseActor(modelContainer: container)
    let collections = (1...50).map { index in
      StoryFixtures.collection(id: UUID(), slug: "story-\(index)", title: "Story \(index)", language: "en")
    }
    try await actor.saveCollections(collections)
    let paged = try await actor.loadCollections(language: "en", limit: 10, offset: 20)
    #expect(paged.count == 10)
  }
}

private func makeTestCache() throws -> SupabaseStoryCache {
  let container = try StoryDatabaseContainer.makeInMemory()
  let actor = StoryDatabaseActor(modelContainer: container)
  return SupabaseStoryCache(databaseActor: actor)
}
