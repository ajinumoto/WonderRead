import SwiftUI

enum ReaderLayoutPageSourcesFactory {
  static func make(context: ReaderPageBuildContext) -> ReaderLayoutPageSources {
    ReaderLayoutPageSources(
      compact: { ReaderPageBuilder.buildCompactPages(context: context) },
      duoBook: { ReaderPageBuilder.buildDuoBookPages(context: context) },
      duoSpread: { ReaderPageBuilder.buildDuoSpreadPages(context: context) },
      twoPane: { ReaderPageBuilder.buildTwoPanePages(context: context) },
      padSpread: { ReaderPageBuilder.buildPadSpreadPages(context: context) }
    )
  }
}
