import SwiftUI

struct StoryReaderLayoutContextFactory {
  var pages: ReaderLayoutPageSources
  var chapterIndex: Int
  var reduceMotion: Bool
  var contentIdentity: [AnyHashable]
  var isShowingCover: Bool
  var coverInfo: ReaderCoverInfo?
  var isShowingLoadingPage: Bool
  var isGenerating: Bool
  var generationErrorMessage: String?
  var currentChapter: StoryChapter?
  var nextChapter: StoryChapter?
  var previousChapter: StoryChapter?
  var nickname: String
  var textScale: CGFloat
  var isFullscreen: Bool = false

  func make(geometry: GeometryProxy, category: ReaderDeviceCategory, isWide: Bool) -> StoryReaderLayoutContext {
    StoryReaderLayoutContext(
      category: category, geometry: geometry, isWide: isWide, pages: pages,
      chapterIndex: chapterIndex, reduceMotion: reduceMotion, contentIdentity: contentIdentity,
      isShowingCover: isShowingCover, coverInfo: coverInfo, isShowingLoadingPage: isShowingLoadingPage,
      isGenerating: isGenerating, generationErrorMessage: generationErrorMessage,
      currentChapter: currentChapter, nextChapter: nextChapter, previousChapter: previousChapter,
      nickname: nickname, textScale: textScale, isFullscreen: isFullscreen
    )
  }
}
