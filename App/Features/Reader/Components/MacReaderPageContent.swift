import SwiftUI

struct MacReaderPageContent: View {
  enum PageStyle {
    case illustration
    case text
    case compact
  }

  enum LoadingStyle {
    case spread
    case page
  }

  enum ContentState {
    case chapter(StoryChapter)
    case cover(ReaderCoverInfo)
    case loading(isGenerating: Bool, errorMessage: String?)
    case empty
  }

  var content: ContentState
  var pageStyle: PageStyle
  var loadingStyle: LoadingStyle
  var nickname: String
  var textScale: CGFloat
  var onRetry: () -> Void

  @ViewBuilder
  var body: some View {
    switch content {
    case .chapter(let chapter):
      switch pageStyle {
      case .illustration:
        StoryIllustrationPage(chapter: chapter)
      case .text:
        StoryTextPage(chapter: chapter, nickname: nickname, textScale: textScale)
      case .compact:
        StoryCompactPage(chapter: chapter, nickname: nickname, textScale: textScale)
      }
    case .cover(let info):
      coverPage(info)
    case .loading(let isGenerating, let errorMessage):
      switch loadingStyle {
      case .spread:
        StoryLoadingSpread(isGenerating: isGenerating, errorMessage: errorMessage, onRetry: onRetry)
      case .page:
        StoryLoadingPage(errorMessage: errorMessage, onRetry: onRetry)
      }
    case .empty:
      EmptyView()
    }
  }

  @ViewBuilder
  private func coverPage(_ info: ReaderCoverInfo) -> some View {
    switch pageStyle {
    case .illustration:
      StoryBlankEndpaperPage()
    case .text:
      StoryReaderCoverPage(
        seriesBadge: info.seriesBadge,
        collectionTitle: info.collectionTitle,
        chapter: info.chapter,
        coverImageURL: info.coverImageURL
      )
    case .compact:
      StoryReaderCoverPage(
        seriesBadge: info.seriesBadge,
        collectionTitle: info.collectionTitle,
        chapter: info.chapter,
        coverImageURL: info.coverImageURL,
        spineIntensity: 0,
        showsSpineShadow: false
      )
    }
  }
}
