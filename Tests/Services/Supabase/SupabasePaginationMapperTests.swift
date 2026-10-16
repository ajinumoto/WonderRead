import Foundation
import Testing
@testable import WonderRead

struct SupabaseCollectionPaginationMapperTests {
  @Test func evaluatesHasMoreBasedOnThreshold() {
    #expect(SupabaseCollectionPaginationMapper.hasMore(fetchedCount: 10, limit: 10) == true)
    #expect(SupabaseCollectionPaginationMapper.hasMore(fetchedCount: 12, limit: 10) == true)
    #expect(SupabaseCollectionPaginationMapper.hasMore(fetchedCount: 9, limit: 10) == false)
    #expect(SupabaseCollectionPaginationMapper.hasMore(fetchedCount: 0, limit: 10) == false)
    #expect(SupabaseCollectionPaginationMapper.hasMore(fetchedCount: 5, limit: 0) == false)
  }

  @Test func calculatesNextOffset() {
    #expect(SupabaseCollectionPaginationMapper.nextOffset(currentOffset: 0, newCount: 10) == 10)
    #expect(SupabaseCollectionPaginationMapper.nextOffset(currentOffset: 10, newCount: 10) == 20)
    #expect(SupabaseCollectionPaginationMapper.nextOffset(currentOffset: -5, newCount: 5) == 5)
  }

  @Test func triggersLoadMoreWhenNearThreshold() {
    let items = [
      StoryFixtures.collection(),
      StoryFixtures.collection(),
      StoryFixtures.collection()
    ]
    #expect(SupabaseCollectionPaginationMapper.shouldTriggerLoadMore(item: items[2], in: items, threshold: 2) == true)
    #expect(SupabaseCollectionPaginationMapper.shouldTriggerLoadMore(item: items[1], in: items, threshold: 2) == true)
    #expect(SupabaseCollectionPaginationMapper.shouldTriggerLoadMore(item: items[0], in: items, threshold: 2) == false)
  }
}

struct SupabaseCollectionURLMapperTests {
  @Test func buildsURLWithLanguageAndPagination() {
    let query = SupabaseCollectionQuery(language: "id", limit: 15, offset: 30)
    let url = SupabaseCollectionURLMapper.collectionsURL(baseURL: "https://example.supabase.co", query: query)
    let urlString = url?.absoluteString ?? ""
    #expect(urlString.contains("language=eq.id"))
    #expect(urlString.contains("limit=15"))
    #expect(urlString.contains("offset=30"))
  }

  @Test func buildsURLWithoutLanguageFilterWhenNil() {
    let query = SupabaseCollectionQuery(language: nil, limit: 10, offset: 0)
    let url = SupabaseCollectionURLMapper.collectionsURL(baseURL: "https://example.supabase.co", query: query)
    let urlString = url?.absoluteString ?? ""
    #expect(!urlString.contains("language=eq."))
    #expect(urlString.contains("limit=10"))
    #expect(urlString.contains("offset=0"))
  }
}

struct CollectionDeduplicationMapperTests {
  @Test func mergesWithoutDuplicates() {
    let item1 = StoryFixtures.collection()
    let item2 = StoryFixtures.collection()
    let item3 = StoryFixtures.collection()

    let merged = CollectionDeduplicationMapper.merge(existing: [item1, item2], new: [item2, item3])
    #expect(merged.count == 3)
    #expect(merged.map(\.id) == [item1.id, item2.id, item3.id])
  }
}
