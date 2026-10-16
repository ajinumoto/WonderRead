import SwiftUI

// MARK: - Reusable Reader Background

struct ReaderCoverInfo: Equatable, Sendable {
  var seriesBadge: String?
  var collectionTitle: String
  var chapterTitle: String
  var chapterSummary: String
  var chapterNumber: Int?
  var chapter: StoryChapter?
  var coverImageURL: String?
}
