import SwiftUI

struct MacBookWideLayoutView: View {
  var geometry: GeometryProxy
  var turnDirection: MacPageTurnAction?
  var dragProgress: CGFloat
  var isShowingCover: Bool
  var coverInfo: ReaderCoverInfo?
  var currentChapter: StoryChapter?
  var nextChapter: StoryChapter?
  var previousChapter: StoryChapter?
  var isShowingLoadingPage: Bool
  var isGenerating: Bool
  var generationErrorMessage: String?
  var nickname: String
  var textScale: CGFloat
  var spineIntensity: Double
  var reduceMotion: Bool
  var onRetryGeneration: () -> Void

  var body: some View {
    turnContent(in: geometry)
  }

  @ViewBuilder
  private func turnContent(in geometry: GeometryProxy) -> some View {
    if turnDirection == .forward {
      MacBookWideForwardTurnView(size: geometry.size, illustration: currentIllustrationPage, text: nextTextPage, leafFront: currentTextPage, leafBack: nextIllustrationPage, progress: dragProgress, spineIntensity: spineIntensity, reduceMotion: reduceMotion)
    } else if turnDirection == .backward {
      MacBookWideBackwardTurnView(size: geometry.size, illustration: previousIllustrationPage, text: currentTextPage, leafFront: currentIllustrationPage, leafBack: previousTextPage, progress: dragProgress, spineIntensity: spineIntensity, reduceMotion: reduceMotion)
    } else {
      idleSpread.frame(width: geometry.size.width, height: geometry.size.height)
    }
  }

  @ViewBuilder
  private var idleSpread: some View {
    if isShowingCover, let coverInfo {
      ReaderReducedMotionCoverPage(info: coverInfo, isWide: true, spineIntensity: spineIntensity)
    } else if isShowingLoadingPage {
      StoryLoadingSpread(
        isGenerating: isGenerating,
        errorMessage: generationErrorMessage,
        onRetry: onRetryGeneration
      )
    } else if let currentChapter {
      MacBookWideStaticSpread(chapter: currentChapter, nickname: nickname, textScale: textScale, spineIntensity: spineIntensity)
    } else {
      ContentUnavailableView(String(localized: "Story not found", comment: "Localized app copy."), systemImage: "book.closed")
    }
  }

  private var currentContent: MacReaderPageContent.ContentState {
    if isShowingCover, let coverInfo { return .cover(coverInfo) }
    if isShowingLoadingPage {
      return .loading(isGenerating: isGenerating, errorMessage: generationErrorMessage)
    } else if let currentChapter {
      return .chapter(currentChapter)
    } else {
      return .empty
    }
  }

  private var nextContent: MacReaderPageContent.ContentState {
    nextChapter.map(MacReaderPageContent.ContentState.chapter)
      ?? .loading(isGenerating: isGenerating, errorMessage: generationErrorMessage)
  }

  private var previousContent: MacReaderPageContent.ContentState {
    if let previousChapter {
      return .chapter(previousChapter)
    }
    if let coverInfo, !isShowingCover {
      return .cover(coverInfo)
    }
    if isShowingLoadingPage, let currentChapter {
      return .chapter(currentChapter)
    }
    return .empty
  }

  private var currentIllustrationPage: MacReaderPageContent {
    MacReaderPageContent(
      content: currentContent,
      pageStyle: .illustration,
      loadingStyle: .spread,
      nickname: nickname,
      textScale: textScale,
      onRetry: onRetryGeneration
    )
  }

  private var currentTextPage: MacReaderPageContent {
    MacReaderPageContent(
      content: currentContent,
      pageStyle: .text,
      loadingStyle: .spread,
      nickname: nickname,
      textScale: textScale,
      onRetry: onRetryGeneration
    )
  }

  private var nextIllustrationPage: MacReaderPageContent {
    MacReaderPageContent(
      content: nextContent,
      pageStyle: .illustration,
      loadingStyle: .spread,
      nickname: nickname,
      textScale: textScale,
      onRetry: onRetryGeneration
    )
  }

  private var nextTextPage: MacReaderPageContent {
    MacReaderPageContent(
      content: nextContent,
      pageStyle: .text,
      loadingStyle: .spread,
      nickname: nickname,
      textScale: textScale,
      onRetry: onRetryGeneration
    )
  }

  private var previousIllustrationPage: MacReaderPageContent {
    MacReaderPageContent(
      content: previousContent,
      pageStyle: .illustration,
      loadingStyle: .spread,
      nickname: nickname,
      textScale: textScale,
      onRetry: onRetryGeneration
    )
  }

  private var previousTextPage: MacReaderPageContent {
    MacReaderPageContent(
      content: previousContent,
      pageStyle: .text,
      loadingStyle: .spread,
      nickname: nickname,
      textScale: textScale,
      onRetry: onRetryGeneration
    )
  }

}
