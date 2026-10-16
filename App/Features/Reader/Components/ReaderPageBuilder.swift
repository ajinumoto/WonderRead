import SwiftUI

enum ReaderPageBuilder {
  static func buildTwoPanePages(context: ReaderPageBuildContext) -> [ReaderPageView] {
    TwoPaneReaderPageFactory.make(context)
  }

  static func buildDuoBookPages(context: ReaderPageBuildContext) -> [ReaderPageView] {
    DuoBookReaderPageFactory.make(context)
  }

  static func buildCompactPages(context: ReaderPageBuildContext) -> [ReaderPageView] {
    CompactReaderPageFactory.make(context)
  }

  static func buildPadSpreadPages(context: ReaderPageBuildContext) -> [ReaderPageView] {
    PadReaderPageFactory.make(context)
  }

  static func buildDuoSpreadPages(context: ReaderPageBuildContext) -> [ReaderPageView] {
    DuoSpreadReaderPageFactory.make(context)
  }
}
