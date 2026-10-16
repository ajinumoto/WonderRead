import SwiftUI

enum PadReaderPageFactory {
  static func make(_ context: ReaderPageBuildContext) -> [ReaderPageView] {
    coverPages(context) + chapterPages(context) + loadingPages(context)
  }

  private static func coverPages(_ context: ReaderPageBuildContext) -> [ReaderPageView] {
    ReaderCoverPageFactory.single(context: context, id: "pad-portrait-cover")
  }

  private static func chapterPages(_ context: ReaderPageBuildContext) -> [ReaderPageView] {
    context.chapters.map {
      ReaderPageView(kind: .padChapter(chapter: $0, nickname: context.displayName, textScale: context.textScale))
    }
  }

  private static func loadingPages(_ context: ReaderPageBuildContext) -> [ReaderPageView] {
    guard context.includesLoadingPage else { return [] }
    return [ReaderPageView(kind: .padLoading(
      isGenerating: context.isGenerating,
      errorMessage: context.generationErrorMessage,
      onRetry: context.onRetryGeneration
    ))]
  }
}
