import Foundation

enum SupabaseCollectionPaginationMapper {
  static func hasMore(fetchedCount: Int, limit: Int) -> Bool {
    guard limit > 0 else { return false }
    return fetchedCount >= limit
  }

  static func nextOffset(currentOffset: Int, newCount: Int) -> Int {
    max(0, currentOffset) + max(0, newCount)
  }

  static func shouldTriggerLoadMore(
    item: StoryCollection,
    in items: [StoryCollection],
    threshold: Int = 2
  ) -> Bool {
    guard !items.isEmpty else { return false }
    let safeThreshold = max(1, threshold)
    let targetIndex = max(0, items.count - safeThreshold)
    guard let itemIndex = items.firstIndex(where: { $0.id == item.id }) else { return false }
    return itemIndex >= targetIndex
  }
}
