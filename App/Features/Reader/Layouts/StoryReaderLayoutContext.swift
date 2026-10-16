import SwiftUI

struct StoryReaderLayoutContext {
  var category: ReaderDeviceCategory
  var geometry: GeometryProxy
  var isWide: Bool
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
}
