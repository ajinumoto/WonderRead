import Foundation

struct StoryShelfContentActions {
  var onContinueReading: () -> Void
  var onOpenCollection: (StoryCollection) -> Void
  var onOpenCuratedChapter: (StoryCollection, UUID) -> Void
  var onCreateStory: () -> Void
  var onRefresh: () async -> Void
}
