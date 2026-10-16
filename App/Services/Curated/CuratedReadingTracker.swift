import Foundation
import Observation
import SwiftData

@MainActor
@Observable
final class CuratedReadingTracker {
  private let modelContainer: ModelContainer
  private(set) var lastRead: LastReadCuratedRecord?

  init(modelContainer: ModelContainer = StoryDatabaseContainer.shared) {
    self.modelContainer = modelContainer
    load()
  }

  func load() {
    let descriptor = StoryDatabaseQueryMapper.progressDescriptor()
    guard let entity = try? modelContainer.mainContext.fetch(descriptor).first else {
      self.lastRead = nil
      return
    }
    self.lastRead = StoryDatabaseDataMapper.toDomain(entity: entity)
  }

  func recordReading(collection: StoryCollection, chapter: StoryChapter) {
    let record = makeRecord(collection: collection, chapter: chapter)
    self.lastRead = record
    persistRecord(record)
  }

  private func makeRecord(collection: StoryCollection, chapter: StoryChapter) -> LastReadCuratedRecord {
    LastReadCuratedRecord(
      collectionID: collection.id,
      collectionSlug: collection.slug,
      collectionTitle: collection.title,
      collectionCoverImageURL: collection.coverImageURL,
      collectionBadge: collection.badge,
      chapterID: chapter.id,
      chapterNumber: chapter.number,
      chapterTitle: chapter.title,
      chapterSummary: chapter.summary,
      lastReadAt: .now
    )
  }

  private func persistRecord(_ record: LastReadCuratedRecord) {
    let descriptor = StoryDatabaseQueryMapper.progressDescriptor()
    if let existing = try? modelContainer.mainContext.fetch(descriptor).first {
      updateExistingProgress(existing, from: record)
    } else {
      let entity = StoryDatabaseDataMapper.toEntity(record: record)
      modelContainer.mainContext.insert(entity)
    }
    try? modelContainer.mainContext.save()
  }

  private func updateExistingProgress(_ existing: ReadingProgressEntity, from record: LastReadCuratedRecord) {
    existing.collectionID = record.collectionID
    existing.collectionSlug = record.collectionSlug
    existing.collectionTitle = record.collectionTitle
    existing.collectionCoverImageURL = record.collectionCoverImageURL
    existing.collectionBadge = record.collectionBadge
    existing.chapterID = record.chapterID
    existing.chapterNumber = record.chapterNumber
    existing.chapterTitle = record.chapterTitle
    existing.chapterSummary = record.chapterSummary
    existing.lastReadAt = record.lastReadAt
  }

  func clear() {
    self.lastRead = nil
    let descriptor = StoryDatabaseQueryMapper.progressDescriptor()
    guard let entity = try? modelContainer.mainContext.fetch(descriptor).first else { return }
    modelContainer.mainContext.delete(entity)
    try? modelContainer.mainContext.save()
  }
}
