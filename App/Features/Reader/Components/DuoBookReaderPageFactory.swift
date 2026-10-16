import SwiftUI

enum DuoBookReaderPageFactory {
  static func make(_ context: ReaderPageBuildContext) -> [ReaderPageView] {
    ReaderCoverPageFactory.paired(context: context, prefix: "duo")
      + chapterPages(context)
      + ReaderPairedLoadingPages.make(context: context, layout: .duoBook)
  }

  private static func chapterPages(_ context: ReaderPageBuildContext) -> [ReaderPageView] {
    context.chapters.flatMap { ReaderPairedChapterPageFactory.pages(for: $0, context: context, layout: .duoBook) }
  }
}
