import SwiftUI

struct BookSpineShadow: View {
  @Environment(\.colorScheme) private var colorScheme
  var edge: BookSpineEdge
  var width: CGFloat = 28
  var intensity: Double = 1
  var showsCreaseLine = true

  var body: some View {
    BookSpineShadowRenderer(
      edge: edge,
      width: width,
      shadowColor: BookSpineShadowMapper.shadowColor(colorScheme: colorScheme, intensity: intensity),
      creaseColor: BookSpineShadowMapper.creaseColor(colorScheme: colorScheme, intensity: intensity),
      showsCreaseLine: showsCreaseLine
    )
    .allowsHitTesting(false)
  }
}
