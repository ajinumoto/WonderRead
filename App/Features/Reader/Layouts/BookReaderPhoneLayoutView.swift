import SwiftUI

/// Layout pembaca buku khusus untuk iPhone Standar.
/// Mengutamakan tampilan satu halaman (single-page compact) yang ergonomis untuk perangkat genggam.
struct BookReaderPhoneLayoutView: View, ReaderLayoutContextProviding {
  @Environment(\.verticalSizeClass) private var verticalSizeClass
  var context: StoryReaderLayoutContext
  var actions: StoryReaderLayoutActions

  private var isCompactHeight: Bool { verticalSizeClass == .compact }
  private var readerPages: [ReaderPageView] { isCompactHeight ? sideBySidePages : pages }

  var body: some View {
    #if os(iOS)
    if reduceMotion {
      ReaderReducedMotionView(
        context: context,
        actions: actions,
        isWide: false,
        isSideBySide: isCompactHeight,
        onSwipe: { delta in
          onChapterChanged(chapterIndex + delta)
        }
      )
    } else {
      PageCurlReaderView(
        isFullscreen: isFullscreen,
        usesTwoPanes: false,
        pages: readerPages,
        chapterIndex: chapterIndex,
        onChapterChanged: onChapterChanged,
        contentIdentity: contentIdentity
      )
      .ignoresSafeArea(.all, edges: isFullscreen ? .all : [])
      .background(ReaderBackgroundView())
      .accessibilityHint(String(localized: "Turn the page to open the next or previous story", comment: "Localized app copy."))
    }
    #else
    EmptyView()
    #endif
  }
}
