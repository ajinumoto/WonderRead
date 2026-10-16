import SwiftUI

struct StoryDoodleThumbnailBackdropView: View {
  var theme: StoryDoodleTheme
  var colorScheme: ColorScheme
  var metrics: StoryDoodleMetrics
  var isFloating: Bool

  var body: some View {
    ZStack {
      StoryPalette.surface(for: colorScheme)
      Circle()
        .fill(RadialGradient(
          colors: [theme.primaryColor(for: colorScheme).opacity(0.18), .clear],
          center: .center,
          startRadius: 10,
          endRadius: metrics.minDimension * 0.5
        ))
        .scaleEffect(isFloating ? 1.08 : 0.94)
    }
  }
}
