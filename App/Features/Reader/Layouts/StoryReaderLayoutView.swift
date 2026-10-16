import SwiftUI

struct StoryReaderLayoutView: View {
  var context: StoryReaderLayoutContext
  var actions: StoryReaderLayoutActions

  @ViewBuilder
  var body: some View {
    switch context.category {
    case .iphone:
      BookReaderPhoneLayoutView(context: context, actions: actions)
    #if os(iOS)
    case .iphoneDuo:
      BookReaderDuoLayoutView(context: context, actions: actions)
    case .ipad:
      BookReaderPadLayoutView(context: context, actions: actions)
    #else
    case .iphoneDuo, .ipad:
      EmptyView()
    #endif
    case .mac:
      BookReaderMacLayoutView(context: context, actions: actions)
    }
  }
}
