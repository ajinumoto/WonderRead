import Foundation

enum CollectionDeduplicationMapper {
  static func merge(existing: [StoryCollection], new: [StoryCollection]) -> [StoryCollection] {
    var seenIDs = Set(existing.map(\.id))
    var merged = existing
    for item in new where !seenIDs.contains(item.id) {
      seenIDs.insert(item.id)
      merged.append(item)
    }
    return merged
  }
}
