import Foundation
import SwiftData

@Model
final class ReadingProgressEntity {
  @Attribute(.unique) var id: String
  var collectionID: UUID
  var collectionSlug: String
  var collectionTitle: String
  var collectionCoverImageURL: String
  var collectionBadge: String?
  var chapterID: UUID
  var chapterNumber: Int
  var chapterTitle: String
  var chapterSummary: String
  var lastReadAt: Date

  init(
    id: String = "curated_last_read",
    collectionID: UUID,
    collectionSlug: String,
    collectionTitle: String,
    collectionCoverImageURL: String,
    collectionBadge: String? = nil,
    chapterID: UUID,
    chapterNumber: Int,
    chapterTitle: String,
    chapterSummary: String,
    lastReadAt: Date = .now
  ) {
    self.id = id
    self.collectionID = collectionID
    self.collectionSlug = collectionSlug
    self.collectionTitle = collectionTitle
    self.collectionCoverImageURL = collectionCoverImageURL
    self.collectionBadge = collectionBadge
    self.chapterID = chapterID
    self.chapterNumber = chapterNumber
    self.chapterTitle = chapterTitle
    self.chapterSummary = chapterSummary
    self.lastReadAt = lastReadAt
  }
}
