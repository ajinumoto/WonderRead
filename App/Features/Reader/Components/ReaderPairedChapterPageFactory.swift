import SwiftUI

enum ReaderPairedChapterPageFactory {
  static func pages(for chapter: StoryChapter, context: ReaderPageBuildContext, layout: ReaderPairedPageLayout) -> [ReaderPageView] {
    [
      ReaderPageView(kind: .pairedIllustration(chapter: chapter, context: context, layout: layout)),
      ReaderPageView(kind: .pairedText(chapter: chapter, context: context, layout: layout))
    ]
  }
}
