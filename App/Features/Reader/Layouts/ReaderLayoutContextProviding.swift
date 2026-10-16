import SwiftUI

protocol ReaderLayoutContextProviding {
  var context: StoryReaderLayoutContext { get }
  var actions: StoryReaderLayoutActions { get }
}

extension ReaderLayoutContextProviding {
  var category: ReaderDeviceCategory { context.category }
  var geometry: GeometryProxy { context.geometry }
  var isWide: Bool { context.isWide }
  var isFullscreen: Bool { context.isFullscreen }
  var compactPages: [ReaderPageView] { context.pages.compact() }
  var pages: [ReaderPageView] { compactPages }
  var duoBookPages: [ReaderPageView] { context.pages.duoBook() }
  var duoSpreadPages: [ReaderPageView] { context.pages.duoSpread() }
  var twoPanePages: [ReaderPageView] { context.pages.twoPane() }
  var sideBySidePages: [ReaderPageView] { context.pages.padSpread() }
  var chapterIndex: Int { context.chapterIndex }
  var reduceMotion: Bool { context.reduceMotion }
  var contentIdentity: [AnyHashable] { context.contentIdentity }
  var isShowingCover: Bool { context.isShowingCover }
  var coverInfo: ReaderCoverInfo? { context.coverInfo }
  var isShowingLoadingPage: Bool { context.isShowingLoadingPage }
  var isGenerating: Bool { context.isGenerating }
  var generationErrorMessage: String? { context.generationErrorMessage }
  var currentChapter: StoryChapter? { context.currentChapter }
  var nextChapter: StoryChapter? { context.nextChapter }
  var previousChapter: StoryChapter? { context.previousChapter }
  var prevChapter: StoryChapter? { context.previousChapter }
  var nickname: String { context.nickname }
  var textScale: CGFloat { context.textScale }
  var spineIntensity: Double { actions.spineIntensity.wrappedValue }
  var programmaticAction: Binding<MacPageTurnAction?> { actions.programmaticAction }
  var onChapterChanged: (Int) -> Void { actions.onChapterChanged }
  var onRetryGeneration: () -> Void { actions.onRetryGeneration }
  var onTurnToChapter: (StoryChapter) -> Void { actions.onTurnToChapter }
  var onTurnToPrevChapter: (StoryChapter) -> Void { actions.onTurnToPreviousChapter }
  var onTurnToLoading: () -> Void { actions.onTurnToLoading }
  var onTurnBackFromLoading: (StoryChapter) -> Void { actions.onTurnBackFromLoading }
}
