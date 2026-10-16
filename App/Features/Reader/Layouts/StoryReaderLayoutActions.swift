import SwiftUI

struct StoryReaderLayoutActions {
  var spineIntensity: Binding<Double>
  var programmaticAction: Binding<MacPageTurnAction?>
  var onChapterChanged: (Int) -> Void
  var onRetryGeneration: () -> Void
  var onTurnToChapter: (StoryChapter) -> Void
  var onTurnToPreviousChapter: (StoryChapter) -> Void
  var onTurnToLoading: () -> Void
  var onTurnBackFromLoading: (StoryChapter) -> Void
}
