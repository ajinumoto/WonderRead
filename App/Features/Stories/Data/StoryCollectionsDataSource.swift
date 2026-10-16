import Foundation
import Observation

@MainActor
@Observable
final class StoryCollectionsDataSource {
  private(set) var collections: [StoryCollection] = []
  private(set) var isLoading = false
  private(set) var isLoadingMore = false
  private(set) var hasMore = true
  private(set) var currentOffset = 0
  let pageSize: Int

  init(pageSize: Int = 10) {
    self.pageSize = max(1, pageSize)
  }

  func loadInitial(language: String, forceRefresh: Bool = false) async {
    guard !isLoading else { return }
    isLoading = collections.isEmpty || forceRefresh
    let fetched = await SupabaseStoryService.fetchCollections(
      language: language,
      limit: pageSize,
      offset: 0,
      forceRefresh: forceRefresh
    )
    applyInitialResults(fetched)
    isLoading = false
  }

  func loadMore(language: String) async {
    guard canLoadMore else { return }
    isLoadingMore = true
    let fetched = await SupabaseStoryService.fetchCollections(
      language: language,
      limit: pageSize,
      offset: currentOffset,
      forceRefresh: false
    )
    applyMoreResults(fetched)
    isLoadingMore = false
  }

  func refresh(language: String) async {
    await loadInitial(language: language, forceRefresh: true)
  }

  private var canLoadMore: Bool {
    !isLoading && !isLoadingMore && hasMore && !collections.isEmpty
  }

  private func applyInitialResults(_ fetched: [StoryCollection]) {
    collections = fetched
    currentOffset = fetched.count
    hasMore = SupabaseCollectionPaginationMapper.hasMore(fetchedCount: fetched.count, limit: pageSize)
  }

  private func applyMoreResults(_ fetched: [StoryCollection]) {
    collections = CollectionDeduplicationMapper.merge(existing: collections, new: fetched)
    currentOffset = SupabaseCollectionPaginationMapper.nextOffset(currentOffset: currentOffset, newCount: fetched.count)
    hasMore = SupabaseCollectionPaginationMapper.hasMore(fetchedCount: fetched.count, limit: pageSize)
  }
}
