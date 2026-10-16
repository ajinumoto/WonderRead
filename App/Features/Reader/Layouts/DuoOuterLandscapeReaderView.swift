import SwiftUI

#if os(iOS)
struct DuoOuterLandscapeReaderView: View, ReaderLayoutContextProviding {
  var context: StoryReaderLayoutContext
  var actions: StoryReaderLayoutActions

  var body: some View {
    Group {
      if reduceMotion { reducedMotionReader }
      else { pageCurlReader }
    }
  }

  private var pageCurlReader: some View {
    PageCurlReaderView(
      isFullscreen: isFullscreen,
      usesTwoPanes: false,
      pages: sideBySidePages,
      chapterIndex: chapterIndex,
      onChapterChanged: onChapterChanged,
      contentIdentity: contentIdentity
    )
    .ignoresSafeArea(.all, edges: isFullscreen ? .all : [])
    .background(ReaderBackgroundView())
    .accessibilityHint(String(localized: "Turn the page to open the previous or next story", comment: "Localized app copy."))
  }

  private var reducedMotionReader: some View {
    Group {
      if isShowingLoadingPage {
        StoryPadLoadingPageView(isGenerating: isGenerating, errorMessage: generationErrorMessage, onRetry: onRetryGeneration)
      } else if let currentChapter {
        StoryPadSinglePageView(chapter: currentChapter, nickname: nickname, textScale: textScale)
      } else {
        ReaderEmptyStateView()
      }
    }
    .modifier(DuoReaderSwipeModifier(
      chapterIndex: chapterIndex,
      minimumDistance: 48,
      completionDistance: 76,
      verticalDominance: 1.25,
      onChapterChanged: onChapterChanged
    ))
  }
}
#endif
