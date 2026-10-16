import Foundation

enum StoryTextContentMapper {
  static func chapterHeader(for chapter: StoryChapter) -> String {
    guard chapter.isCurated else {
      return String(localized: "Children's Story  ·  Chapter \(chapter.number)", comment: "Localized app copy.")
    }
    let collectionTitle = chapter.seriesTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !collectionTitle.isEmpty else {
      return String(localized: "Chapter \(chapter.number)", comment: "Localized app copy.")
    }
    return String(localized: "\(collectionTitle)  ·  Chapter \(chapter.number)", comment: "Localized app copy.")
  }
}
