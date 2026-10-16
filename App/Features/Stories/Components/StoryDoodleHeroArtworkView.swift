import SwiftUI

struct StoryDoodleHeroArtworkView: View {
  var theme: StoryDoodleTheme
  var colorScheme: ColorScheme
  var metrics: StoryDoodleMetrics
  var isFloating: Bool
  var isSwaying: Bool

  var body: some View {
    ZStack {
      satellite(at: 0)
      satellite(at: 1)
      satellite(at: 2)
      hero
    }
    .frame(width: metrics.minDimension * 0.75, height: metrics.minDimension * 0.55)
  }

  private func satellite(at index: Int) -> some View {
    let offsets = satelliteOffsets
    let rotations = satelliteRotations
    return StoryDoodleOrbitingSymbol(
      symbol: theme.satelliteSymbols[index],
      size: metrics.satelliteSize * (index == 0 ? 1 : index == 1 ? 0.9 : 0.85),
      primary: index < 2 ? theme.secondaryColor(for: colorScheme) : theme.primaryColor(for: colorScheme),
      secondary: index < 2 ? theme.primaryColor(for: colorScheme) : theme.secondaryColor(for: colorScheme),
      renderingMode: index == 1 ? .hierarchical : .palette,
      effect: index == 1 ? .variableColor : .pulse,
      offset: offsets[index],
      rotation: rotations[index]
    )
  }

  private var hero: some View {
    StoryDoodleOrbitingSymbol(
      symbol: theme.heroSymbol,
      size: metrics.heroSize,
      primary: theme.primaryColor(for: colorScheme),
      secondary: theme.secondaryColor(for: colorScheme),
      renderingMode: .palette,
      effect: .breathe,
      offset: CGSize(width: 0, height: isFloating ? -8 : 8),
      rotation: isSwaying ? 3 : -3,
      isDark: colorScheme == .dark,
      showsHeroShadow: true
    )
  }

  private var satelliteOffsets: [CGSize] {
    [
      CGSize(width: -metrics.heroSize * 0.9, height: -metrics.heroSize * 0.75 + (isFloating ? -8 : 6)),
      CGSize(width: metrics.heroSize * 0.95, height: -metrics.heroSize * 0.65 + (isFloating ? 6 : -8)),
      CGSize(width: metrics.heroSize * 0.85, height: metrics.heroSize * 0.75 + (isFloating ? -6 : 7))
    ]
  }

  private var satelliteRotations: [Double] {
    [isSwaying ? -8 : 6, isSwaying ? 8 : -6, isSwaying ? -6 : 8]
  }
}
