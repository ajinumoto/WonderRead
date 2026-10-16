import Foundation

// MARK: - Collection Deduplication Extension

extension Array where Element == StoryCollection {
  func deduplicatedMerging(with new: [StoryCollection]) -> [StoryCollection] {
    var seenIDs = Set(self.map(\.id))
    var merged = self
    for item in new where !seenIDs.contains(item.id) {
      seenIDs.insert(item.id)
      merged.append(item)
    }
    return merged
  }
}

// MARK: - Deduplication Adapter

enum CollectionDeduplicationMapper {
  static func merge(existing: [StoryCollection], new: [StoryCollection]) -> [StoryCollection] {
    existing.deduplicatedMerging(with: new)
  }
}
