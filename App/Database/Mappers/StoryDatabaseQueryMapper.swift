import Foundation
import SwiftData

enum StoryDatabaseQueryMapper {
  static func collectionsDescriptor(
    language: String?,
    limit: Int = 0,
    offset: Int = 0
  ) -> FetchDescriptor<StoryCollectionEntity> {
    var descriptor = makeCollectionsDescriptor(language: language)
    if limit > 0 { descriptor.fetchLimit = limit }
    if offset > 0 { descriptor.fetchOffset = offset }
    return descriptor
  }

  private static func makeCollectionsDescriptor(
    language: String?
  ) -> FetchDescriptor<StoryCollectionEntity> {
    let sortDescriptors = [
      SortDescriptor(\StoryCollectionEntity.orderIndex, order: .forward),
      SortDescriptor(\StoryCollectionEntity.title, order: .forward)
    ]
    let sanitized = language?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    guard let key = sanitized, !key.isEmpty, key != "all" else {
      return FetchDescriptor<StoryCollectionEntity>(
        sortBy: sortDescriptors
      )
    }
    let predicate = #Predicate<StoryCollectionEntity> { $0.language == key }
    return FetchDescriptor<StoryCollectionEntity>(
      predicate: predicate,
      sortBy: sortDescriptors
    )
  }

  static func generatedChaptersDescriptor() -> FetchDescriptor<StoryChapterEntity> {
    let sourceKey = StoryChapterSource.generated.rawValue
    let predicate = #Predicate<StoryChapterEntity> { $0.sourceRawValue == sourceKey }
    return FetchDescriptor<StoryChapterEntity>(
      predicate: predicate,
      sortBy: [SortDescriptor(\StoryChapterEntity.number, order: .forward)]
    )
  }

  static func collectionChaptersDescriptor(collectionID: UUID) -> FetchDescriptor<StoryChapterEntity> {
    let predicate = #Predicate<StoryChapterEntity> { $0.collection?.id == collectionID }
    return FetchDescriptor<StoryChapterEntity>(
      predicate: predicate,
      sortBy: [SortDescriptor(\StoryChapterEntity.number, order: .forward)]
    )
  }

  static func progressDescriptor(id: String = "curated_last_read") -> FetchDescriptor<ReadingProgressEntity> {
    let predicate = #Predicate<ReadingProgressEntity> { $0.id == id }
    var descriptor = FetchDescriptor<ReadingProgressEntity>(predicate: predicate)
    descriptor.fetchLimit = 1
    return descriptor
  }
}
