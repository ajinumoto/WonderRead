import SwiftUI

enum BookSpineShadowMapper {
  static func shadowColor(colorScheme: ColorScheme, intensity: Double) -> Color {
    let opacities = opacityMetrics(colorScheme: colorScheme, intensity: intensity)
    return colorScheme == .dark
      ? Color.black.opacity(opacities.shadow)
      : StoryPalette.deepForest.opacity(opacities.shadow)
  }

  static func creaseColor(colorScheme: ColorScheme, intensity: Double) -> Color {
    let opacities = opacityMetrics(colorScheme: colorScheme, intensity: intensity)
    return colorScheme == .dark
      ? Color.black.opacity(opacities.crease)
      : StoryPalette.deepForest.opacity(opacities.crease)
  }

  static func opacityMetrics(colorScheme: ColorScheme, intensity: Double) -> BookSpineShadowOpacity {
    let normalized = max(0.1, min(intensity, 2.5))
    let shadowScale = colorScheme == .dark ? 0.58 : 0.38
    let creaseScale = colorScheme == .dark ? 0.35 : 0.40
    return BookSpineShadowOpacity(
      shadow: min(1, shadowScale * normalized),
      crease: min(1, creaseScale * normalized)
    )
  }
}

struct BookSpineShadowOpacity: Equatable, Sendable {
  var shadow: Double
  var crease: Double
}
