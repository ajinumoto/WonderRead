import SwiftUI

enum TwoPaneReaderPageFactory {
  static func make(_ context: ReaderPageBuildContext) -> [ReaderPageView] {
    ReaderCoverPageFactory.paired(context: context, prefix: "reader")
      + chapterPages(context)
      + ReaderPairedLoadingPages.make(context: context, layout: .twoPane)
  }

  private static func chapterPages(_ context: ReaderPageBuildContext) -> [ReaderPageView] {
    context.chapters.flatMap { ReaderPairedChapterPageFactory.pages(for: $0, context: context, layout: .twoPane) }
  }
}
