import SwiftUI

struct ShelfTwoPaneLayout: View {
  var geometry: GeometryProxy
  var isPortrait: Bool = false
  var primary: ShelfPrimaryPane
  var secondary: ShelfSecondaryPane
  var onRefresh: () async -> Void = {}

  var body: some View {
    Group {
      if isPortrait {
        ShelfPortraitTwoPaneLayout(geometry: geometry, primary: primary, secondary: secondary, onRefresh: onRefresh)
      } else {
        ShelfLandscapeTwoPaneLayout(geometry: geometry, primary: primary, secondary: secondary, onRefresh: onRefresh)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(StoryPalette.page(for: colorScheme))
  }

  @Environment(\.colorScheme) private var colorScheme
}
