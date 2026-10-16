import Foundation

struct StoryChapter: Identifiable, Codable, Sendable, Hashable {
  var id: UUID
  var number: Int
  var seriesTitle: String
  var title: String
  var summary: String
  var paragraphs: [String]
  var illustrationPrompt: String
  var illustrationFilename: String
  var generatedAt: Date
  var source: StoryChapterSource? = nil
  var isFinalInCollection: Bool? = nil

  var isCurated: Bool { source == .curated || (source == nil && isRemoteIllustration) }
  var isFinalCuratedChapter: Bool { isCurated && isFinalInCollection == true }

  var isRemoteIllustration: Bool {
    illustrationFilename.hasPrefix("http://") || illustrationFilename.hasPrefix("https://")
  }
}
