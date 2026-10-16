import SwiftUI

struct MacBookCompactLayoutView: View {
  var size: CGSize
  var turnDirection: MacPageTurnAction?
  var dragProgress: CGFloat
  var isShowingCover: Bool
  var coverInfo: ReaderCoverInfo?
  var currentChapter: StoryChapter?
  var nextChapter: StoryChapter?
  var previousChapter: StoryChapter?
  var isShowingLoadingPage: Bool
  var generationErrorMessage: String?
  var nickname: String
  var textScale: CGFloat
  var reduceMotion: Bool
  var onRetryGeneration: () -> Void

  var body: some View {
    Group {
      if turnDirection == .forward {
        ZStack {
          nextPage
            .frame(width: size.width, height: size.height)

          currentPage
            .frame(width: size.width, height: size.height)
            .rotation3DEffect(
              .degrees(reduceMotion ? 0 : -80 * dragProgress),
              axis: (x: 0, y: 1, z: 0),
              anchor: .leading,
              perspective: 0.6
            )
            .offset(x: reduceMotion ? 0 : -dragProgress * size.width * 0.25)
            .opacity(1 - Double(dragProgress) * 0.4)
            .shadow(
              color: StoryPalette.deepForest.opacity(0.22 * sinProgress(dragProgress)),
              radius: 12 * sinProgress(dragProgress),
              x: -8,
              y: 3
            )
        }
      } else if turnDirection == .backward {
        ZStack {
          currentPage
            .frame(width: size.width, height: size.height)

          previousPage
            .frame(width: size.width, height: size.height)
            .rotation3DEffect(
              .degrees(reduceMotion ? 0 : 80 * (1 - dragProgress)),
              axis: (x: 0, y: 1, z: 0),
              anchor: .trailing,
              perspective: 0.6
            )
            .offset(x: reduceMotion ? 0 : (1 - dragProgress) * size.width * 0.25)
            .opacity(Double(dragProgress) * 0.6 + 0.4)
            .shadow(
              color: StoryPalette.deepForest.opacity(0.22 * sinProgress(dragProgress)),
              radius: 12 * sinProgress(dragProgress),
              x: 8,
              y: 3
            )
        }
      } else {
        currentPage
          .frame(width: size.width, height: size.height)
      }
    }
  }

  private var currentPage: MacReaderPageContent {
    MacReaderPageContent(
      content: currentContent,
      pageStyle: .compact,
      loadingStyle: .page,
      nickname: nickname,
      textScale: textScale,
      onRetry: onRetryGeneration
    )
  }

  private var nextPage: MacReaderPageContent {
    MacReaderPageContent(
      content: nextContent,
      pageStyle: .compact,
      loadingStyle: .page,
      nickname: nickname,
      textScale: textScale,
      onRetry: onRetryGeneration
    )
  }

  private var previousPage: MacReaderPageContent {
    MacReaderPageContent(
      content: previousContent,
      pageStyle: .compact,
      loadingStyle: .page,
      nickname: nickname,
      textScale: textScale,
      onRetry: onRetryGeneration
    )
  }

  private var currentContent: MacReaderPageContent.ContentState {
    if isShowingCover, let coverInfo { return .cover(coverInfo) }
    if isShowingLoadingPage {
      return .loading(isGenerating: false, errorMessage: generationErrorMessage)
    } else if let currentChapter {
      return .chapter(currentChapter)
    } else {
      return .empty
    }
  }

  private var nextContent: MacReaderPageContent.ContentState {
    nextChapter.map(MacReaderPageContent.ContentState.chapter)
      ?? .loading(isGenerating: false, errorMessage: generationErrorMessage)
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

  private func sinProgress(_ progress: CGFloat) -> Double {
    sin(Double.pi * Double(progress))
  }
}
