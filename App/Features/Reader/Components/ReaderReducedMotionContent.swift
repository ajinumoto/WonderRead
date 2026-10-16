import SwiftUI

struct ReaderReducedMotionContent: View {
  var context: StoryReaderLayoutContext
  var actions: StoryReaderLayoutActions
  var isWide: Bool
  var isSideBySide: Bool = false

  private var spineIntensity: Double { actions.spineIntensity.wrappedValue }

  @ViewBuilder
  var body: some View {
    if context.isShowingCover, let coverInfo = context.coverInfo {
      cover(coverInfo)
    } else if context.isShowingLoadingPage {
      loadingPage
    } else if let chapter = context.currentChapter {
      storyPage(chapter)
    } else {
      emptyState
    }
  }

  private func cover(_ info: ReaderCoverInfo) -> some View {
    ReaderReducedMotionCoverPage(info: info, isWide: isWide, spineIntensity: spineIntensity)
  }

  @ViewBuilder
  private var loadingPage: some View {
    if isWide {
      StoryLoadingSpread(
        isGenerating: context.isGenerating,
        errorMessage: context.generationErrorMessage,
        onRetry: actions.onRetryGeneration
      )
    } else {
      StoryLoadingPage(errorMessage: context.generationErrorMessage, onRetry: actions.onRetryGeneration)
    }
  }

  @ViewBuilder
  private func storyPage(_ chapter: StoryChapter) -> some View {
    if isWide {
      StorySpreadPage(
        illustrationPage: StoryIllustrationPage(chapter: chapter),
        storyPage: StoryTextPage(chapter: chapter, nickname: context.nickname, textScale: context.textScale),
        spineIntensity: spineIntensity
      )
      .id(chapter.id)
    } else if isSideBySide {
      StoryPadSinglePageView(chapter: chapter, nickname: context.nickname, textScale: context.textScale)
        .id(chapter.id)
    } else {
      StoryCompactPage(chapter: chapter, nickname: context.nickname, textScale: context.textScale)
        .id(chapter.id)
    }
  }

  private var emptyState: some View {
    ContentUnavailableView(String(localized: "Story not found", comment: "Localized app copy."), systemImage: "book.closed")
  }
}
