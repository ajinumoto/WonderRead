import SwiftUI

#if os(iOS)
struct DuoInnerTableReaderView: View, ReaderLayoutContextProviding {
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
      pages: duoSpreadPages,
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
      if isShowingCover, let coverInfo { singleCoverPage(coverInfo) }
      else { DuoReducedMotionStoryPages(context: context, actions: actions) }
    }
    .background(ReaderBackgroundView())
    .modifier(DuoReaderSwipeModifier(
      chapterIndex: chapterIndex,
      minimumDistance: 32,
      completionDistance: 44,
      verticalDominance: 1.15,
      onChapterChanged: onChapterChanged
    ))
    .accessibilityHint(String(localized: "Swipe screen to turn story page", comment: "Localized app copy."))
  }

  private func singleCoverPage(_ info: ReaderCoverInfo) -> some View {
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
#endif
