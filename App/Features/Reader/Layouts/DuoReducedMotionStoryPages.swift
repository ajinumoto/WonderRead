import SwiftUI

#if os(iOS)
struct DuoReducedMotionStoryPages: View, ReaderLayoutContextProviding {
  var context: StoryReaderLayoutContext
  var actions: StoryReaderLayoutActions

  var body: some View {
    Group {
      if isShowingLoadingPage {
        StoryLoadingSpread(isGenerating: isGenerating, errorMessage: generationErrorMessage, spineIntensity: spineIntensity, onRetry: onRetryGeneration)
      } else if let currentChapter {
        storySpread(for: currentChapter)
      } else {
        ReaderEmptyStateView()
      }
    }
  }

  private func storySpread(for chapter: StoryChapter) -> some View {
    StorySpreadPage(
      illustrationPage: StoryIllustrationPage(chapter: chapter),
      storyPage: StoryTextPage(chapter: chapter, nickname: nickname, textScale: textScale),
      spineIntensity: spineIntensity
    )
  }
}
#endif
