import SwiftUI

#if os(iOS)

/// Layout pembaca buku khusus untuk iPad.
/// Mengadaptasi tampilan berdasarkan orientasi perangkat:
/// - Landscape: Format buku terbuka 2 halaman (50/50) dengan bayangan lipatan buku (spine shadow) dan page curl dua sisi.
/// - Portrait: Format 1/3 gambar ilustrasi (kiri) & 2/3 teks cerita (kanan) tanpa bayangan lipatan buku (clean single page).
struct BookReaderPadLayoutView: View, ReaderLayoutContextProviding {
  var context: StoryReaderLayoutContext
  var actions: StoryReaderLayoutActions

  private var isLandscape: Bool {
    geometry.size.width > geometry.size.height
  }

  var body: some View {
    #if os(iOS)
    Group {
      if isLandscape {
        landscapeReader
      } else {
        portraitReader
      }
    }
    .id(isLandscape)
    #else
    EmptyView()
    #endif
  }

  // MARK: - Landscape Mode (50/50 Two-Page Spread with Center Spine Shadow)
  @ViewBuilder
  private var landscapeReader: some View {
    if reduceMotion {
      ReaderReducedMotionView(
        context: context,
        actions: actions,
        isWide: true,
        onSwipe: { delta in
          onChapterChanged(chapterIndex + delta)
        }
      )
    } else {
      PageCurlReaderView(
        isFullscreen: isFullscreen,
        usesTwoPanes: true,
        pages: twoPanePages,
        chapterIndex: chapterIndex,
        onChapterChanged: onChapterChanged,
        contentIdentity: contentIdentity
      )
      .ignoresSafeArea(.all, edges: isFullscreen ? .all : [])
      .background(ReaderBackgroundView())
      .accessibilityHint(String(localized: "Turn the two-page spread to open the previous or next story", comment: "Localized app copy."))
    }
  }

  // MARK: - Portrait Mode (1/3 Image, 2/3 Text, No Spine Shadow)
  @ViewBuilder
  private var portraitReader: some View {
    if reduceMotion {
      reducedMotionPadPortraitReader
    } else {
      PageCurlReaderView(
        isFullscreen: isFullscreen,
        usesTwoPanes: false,
        pages: sideBySidePages,
        chapterIndex: chapterIndex,
        onChapterChanged: onChapterChanged,
        contentIdentity: contentIdentity
      )
      .ignoresSafeArea(.all, edges: isFullscreen ? .all : [])
      .background(ReaderBackgroundView())
      .accessibilityHint(String(localized: "Turn the page to open the previous or next story", comment: "Localized app copy."))
    }
  }

  @ViewBuilder
  private var reducedMotionPadPortraitReader: some View {
    Group {
      if isShowingCover, let coverInfo {
        StoryReaderCoverPage(
          seriesBadge: coverInfo.seriesBadge,
          collectionTitle: coverInfo.collectionTitle,
          chapter: coverInfo.chapter,
          coverImageURL: coverInfo.coverImageURL,
          spineIntensity: 0,
          showsSpineShadow: false
        )
      } else if isShowingLoadingPage {
        StoryPadLoadingPageView(
          isGenerating: isGenerating,
          errorMessage: generationErrorMessage,
          onRetry: onRetryGeneration
        )
      } else if let chapter = currentChapter {
        StoryPadSinglePageView(
          chapter: chapter,
          nickname: nickname,
          textScale: textScale
        )
      } else {
        ReaderEmptyStateView()
      }
    }
    .simultaneousGesture(
      DragGesture(minimumDistance: 48, coordinateSpace: .local)
        .onEnded { value in
          let horizontal = value.translation.width
          guard abs(horizontal) > 76, abs(horizontal) > abs(value.translation.height) * 1.25 else { return }
          onChapterChanged(chapterIndex + (horizontal < 0 ? 1 : -1))
        }
    )
  }
}
#endif
