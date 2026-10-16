import SwiftUI

/// Layout pembaca buku khusus untuk Mac (macOS / Mac Catalyst).
/// Mendukung pengalaman desktop dengan navigasi keyboard, gesture trackpad,
/// dan tampilan buku curl dua halaman yang responsif terhadap ukuran window.
struct BookReaderMacLayoutView: View, ReaderLayoutContextProviding {
  var context: StoryReaderLayoutContext
  var actions: StoryReaderLayoutActions

  var body: some View {
    MacBookCurlReaderView(
      isWide: isWide,
      isShowingCover: isShowingCover,
      coverInfo: coverInfo,
      currentChapter: currentChapter,
      nextChapter: nextChapter,
      prevChapter: prevChapter,
      isShowingLoadingPage: isShowingLoadingPage,
      isGenerating: isGenerating,
      generationErrorMessage: generationErrorMessage,
      nickname: nickname,
      textScale: textScale,
      spineIntensity: spineIntensity,
      onRetryGeneration: onRetryGeneration,
      onTurnToChapter: onTurnToChapter,
      onTurnToPrevChapter: onTurnToPrevChapter,
      onTurnToCover: { onChapterChanged(0) },
      onTurnToLoading: onTurnToLoading,
      onTurnBackFromLoading: onTurnBackFromLoading,
      programmaticAction: actions.programmaticAction
    )
  }
}
