import SwiftUI

struct StoryIllustrationShimmer: View {
  @Environment(\.colorScheme) private var colorScheme

  var body: some View {
    ZStack {
      StoryPalette.imagePlaceholder(for: colorScheme)
      StoryShimmerSweep(bandWidthRatio: 0.38)
    }
    .clipped()
    .accessibilityLabel(String(localized: "Preparing illustration", comment: "Localized app copy."))
  }
}
