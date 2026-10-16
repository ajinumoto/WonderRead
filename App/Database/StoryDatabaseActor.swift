import Foundation
import SwiftData

@ModelActor
actor StoryDatabaseActor {
  static let shared = StoryDatabaseActor(modelContainer: StoryDatabaseContainer.shared)

  func saveCollections(
    _ collections: [StoryCollection],
    language: String? = nil,
    replaceExisting: Bool = false
  ) throws {
    if replaceExisting {
      try removeStaleCollections(keeping: Set(collections.map(\.id)), language: language)
    }
    for (index, collection) in collections.enumerated() {
      upsertCollection(collection, orderIndex: index)
    }
    try modelContext.save()
  }

  @discardableResult
  func mergeCollections(_ newCollections: [StoryCollection], language: String? = nil) throws -> [StoryCollection] {
    let existing = try modelContext.fetch(StoryDatabaseQueryMapper.collectionsDescriptor(language: language))
    var nextOrderIndex = (existing.map(\.orderIndex).max() ?? -1) + 1
    for collection in newCollections {
      if let matched = existing.first(where: { $0.id == collection.id }) {
        updateExistingCollection(matched, from: collection, orderIndex: matched.orderIndex)
      } else {
        let entity = StoryDatabaseDataMapper.toEntity(collection: collection, orderIndex: nextOrderIndex)
        modelContext.insert(entity)
        nextOrderIndex += 1
      }
    }
    try modelContext.save()
    return try loadCollections(language: language)
  }

  private func removeStaleCollections(keeping validIDs: Set<UUID>, language: String?) throws {
    let descriptor = StoryDatabaseQueryMapper.collectionsDescriptor(language: language)
    let existing = try modelContext.fetch(descriptor)
    for entity in existing where !validIDs.contains(entity.id) {
      modelContext.delete(entity)
    }
  }

  func loadCollections(language: String? = nil, limit: Int = 0, offset: Int = 0) throws -> [StoryCollection] {
    let descriptor = StoryDatabaseQueryMapper.collectionsDescriptor(
      language: language,
      limit: limit,
      offset: offset
    )
    let entities = try modelContext.fetch(descriptor)
    return entities.map(StoryDatabaseDataMapper.toDomain)
  }

  func updateChapters(_ chapters: [StoryChapter], for collectionID: UUID) throws {
    let predicate = #Predicate<StoryCollectionEntity> { $0.id == collectionID }
    var descriptor = FetchDescriptor<StoryCollectionEntity>(predicate: predicate)
    descriptor.fetchLimit = 1
    guard let collection = try modelContext.fetch(descriptor).first else { return }
    applyUpdatedChapters(chapters, to: collection)
    try modelContext.save()
  }

  private func applyUpdatedChapters(_ chapters: [StoryChapter], to collection: StoryCollectionEntity) {
    for oldChapter in collection.chapters {
      modelContext.delete(oldChapter)
    }
    collection.chapters = chapters.map {
      StoryDatabaseDataMapper.toEntity(chapter: $0, collection: collection)
    }
  }

  private func upsertCollection(_ collection: StoryCollection, orderIndex: Int) {
    let targetID = collection.id
    let predicate = #Predicate<StoryCollectionEntity> { $0.id == targetID }
    var descriptor = FetchDescriptor<StoryCollectionEntity>(predicate: predicate)
    descriptor.fetchLimit = 1
    if let existing = try? modelContext.fetch(descriptor).first {
      updateExistingCollection(existing, from: collection, orderIndex: orderIndex)
    } else {
      let entity = StoryDatabaseDataMapper.toEntity(collection: collection, orderIndex: orderIndex)
      modelContext.insert(entity)
    }
  }

  private func updateExistingCollection(
    _ existing: StoryCollectionEntity,
    from collection: StoryCollection,
    orderIndex: Int
  ) {
    existing.slug = collection.slug
    existing.title = collection.title
    existing.subtitle = collection.subtitle
    existing.summaryText = collection.description
    existing.coverImageURL = collection.coverImageURL
    existing.badge = collection.badge
    existing.language = collection.language
    existing.version = collection.version
    existing.orderIndex = orderIndex
    if !collection.chapters.isEmpty {
      applyUpdatedChapters(collection.chapters, to: existing)
    }
  }

  func isCacheMatchingServer(cached: [StoryCollection], serverVersions: [CollectionVersionDTO], filterLanguage: String?) -> Bool {
    guard !cached.isEmpty else { return false }
    let relevantServer = matchingLanguage(serverVersions, filterLanguage: filterLanguage)
    guard cached.count == relevantServer.count else { return false }
    let cachedMap = Dictionary(uniqueKeysWithValues: cached.map { ($0.id, $0.version) })
    return relevantServer.allSatisfy { cachedMap[$0.id] == $0.effectiveVersion }
  }

  private func matchingLanguage(_ versions: [CollectionVersionDTO], filterLanguage: String?) -> [CollectionVersionDTO] {
    guard let filterLanguage, filterLanguage != "all" else { return versions }
    return versions.filter { ($0.language ?? "en") == filterLanguage }
  }

  func loadGeneratedChapters() throws -> [StoryChapter] {
    let descriptor = StoryDatabaseQueryMapper.generatedChaptersDescriptor()
    let entities = try modelContext.fetch(descriptor)
    return entities.map(StoryDatabaseDataMapper.toDomain)
  }

  func clearCuratedCache() throws {
    let descriptor = FetchDescriptor<StoryCollectionEntity>()
    let collections = try modelContext.fetch(descriptor)
    for collection in collections {
      modelContext.delete(collection)
    }
    try modelContext.save()
  }
}
