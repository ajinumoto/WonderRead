import SwiftUI

struct StoryReaderSurface: View {
  var isEmpty: Bool
  var context: StoryReaderLayoutContext
  var actions: StoryReaderLayoutActions
  var reduceMotion: Bool
  var isFullscreen: Bool = false

  private var geometry: GeometryProxy { context.geometry }
  private var isDuo: Bool { context.category == .iphoneDuo }
  private var isDuoInnerLandscape: Bool {
    isDuo && geometry.size.width >= 550 && geometry.size.width > geometry.size.height
  }
  private var edgePadding: CGFloat {
    guard !isFullscreen, isDuo && !isDuoInnerLandscape else { return 0 }
    return geometry.safeAreaInsets.leading
  }
  private var trailingPadding: CGFloat {
    guard !isFullscreen, isDuo && !isDuoInnerLandscape else { return 0 }
    return geometry.safeAreaInsets.trailing
  }

  var body: some View {
    Group {
      if isEmpty { ReaderEmptyStateView() }
      else { StoryReaderLayoutView(context: context, actions: actions) }
    }
    .padding(.leading, edgePadding)
    .padding(.trailing, trailingPadding)
    .animation(reduceMotion ? nil : .smooth(duration: 0.35), value: isDuoInnerLandscape)
  }
}
