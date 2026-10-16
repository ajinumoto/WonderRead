import SwiftUI

struct StoryDoodleThumbnailArtworkView: View {
  var theme: StoryDoodleTheme
  var colorScheme: ColorScheme
  var metrics: StoryDoodleMetrics
  var isFloating: Bool
  var isSwaying: Bool

  var body: some View {
    ZStack {
      Image(systemName: "sparkle")
        .font(.system(size: metrics.satelliteSize, weight: .semibold))
        .foregroundStyle(theme.secondaryColor(for: colorScheme))
        .offset(x: metrics.heroSize * 0.7, y: -metrics.heroSize * 0.6 + (isFloating ? 3 : -3))
      StoryDoodleOrbitingSymbol(
        symbol: theme.heroSymbol,
        size: metrics.heroSize,
        primary: theme.primaryColor(for: colorScheme),
        secondary: theme.secondaryColor(for: colorScheme),
        renderingMode: .palette,
        effect: .breathe,
        offset: CGSize(width: 0, height: isFloating ? -4 : 4),
        rotation: isSwaying ? 2.5 : -2.5
      )
    }
  }
}
