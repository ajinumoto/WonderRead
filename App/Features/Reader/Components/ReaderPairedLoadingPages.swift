import SwiftUI

enum ReaderPairedLoadingPages {
  static func make(context: ReaderPageBuildContext, layout: ReaderPairedPageLayout) -> [ReaderPageView] {
    guard context.includesLoadingPage else { return [] }
    return [
      ReaderPageView(kind: .pairedLoadingIllustration(context: context, layout: layout)),
      ReaderPageView(kind: .pairedLoadingStory(context: context, layout: layout))
    ]
  }
}
