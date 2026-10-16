import Foundation

enum StoryAppRoute: Hashable {
  case history
  case reader(UUID)
  case collectionReader(StoryCollection, initialChapterID: UUID?)
}
