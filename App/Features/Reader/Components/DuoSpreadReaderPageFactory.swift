import SwiftUI

enum DuoSpreadReaderPageFactory {
  static func make(_ context: ReaderPageBuildContext) -> [ReaderPageView] {
    coverPages(context) + chapterPages(context) + loadingPages(context)
  }

  private static func coverPages(_ context: ReaderPageBuildContext) -> [ReaderPageView] {
    ReaderCoverPageFactory.single(context: context, id: "duo-spread-cover")
  }

  private static func chapterPages(_ context: ReaderPageBuildContext) -> [ReaderPageView] {
    context.chapters.map {
      ReaderPageView(kind: .duoSpreadChapter(
        chapter: $0,
        nickname: context.displayName,
        textScale: context.textScale,
        spineIntensity: context.spineIntensity
      ))
    }
  }

  private static func loadingPages(_ context: ReaderPageBuildContext) -> [ReaderPageView] {
    guard context.includesLoadingPage else { return [] }
    return [ReaderPageView(kind: .duoSpreadLoading(
      isGenerating: context.isGenerating,
      errorMessage: context.generationErrorMessage,
      spineIntensity: context.spineIntensity,
      onRetry: context.onRetryGeneration
    ))]
  }
}
