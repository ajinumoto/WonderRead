import SwiftUI

#if os(iOS)
struct DuoOuterPortraitReaderView: View, ReaderLayoutContextProviding {
  var context: StoryReaderLayoutContext
  var actions: StoryReaderLayoutActions

  var body: some View {
    Group {
      if reduceMotion { reducedMotionReader }
      else { pageCurlReader }
    }
  }

  private var reducedMotionReader: some View {
    ReaderReducedMotionView(
      context: context,
      actions: actions,
      isWide: false,
      onSwipe: { delta in onChapterChanged(chapterIndex + delta) }
    )
  }

  private var pageCurlReader: some View {
    PageCurlReaderView(
      isFullscreen: isFullscreen,
      usesTwoPanes: false,
      pages: compactPages,
      chapterIndex: chapterIndex,
      onChapterChanged: onChapterChanged,
      contentIdentity: contentIdentity
    )
    .ignoresSafeArea(.all, edges: isFullscreen ? .all : [])
    .background(ReaderBackgroundView())
    .accessibilityHint(String(localized: "Turn the page to open the previous or next story", comment: "Localized app copy."))
  }
}
#endif
