import Foundation

struct LastReadCuratedRecord: Codable, Sendable, Equatable, Identifiable {
  var id: UUID { chapterID }
  var collectionID: UUID
  var collectionSlug: String
  var collectionTitle: String
  var collectionCoverImageURL: String
  var collectionBadge: String? = nil
  var chapterID: UUID
  var chapterNumber: Int
  var chapterTitle: String
  var chapterSummary: String
  var lastReadAt: Date
}
