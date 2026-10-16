import SwiftUI

struct StoryDoodleOrbitingSymbol: View {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  enum Effect { case pulse, variableColor, breathe }

  var symbol: String
  var size: CGFloat
  var primary: Color
  var secondary: Color
  var renderingMode: SymbolRenderingMode
  var effect: Effect
  var offset: CGSize
  var rotation: Double
  var isDark = false
  var showsHeroShadow = false

  var body: some View {
    animatedSymbol
      .offset(offset)
      .rotationEffect(.degrees(rotation))
  }

  @ViewBuilder
  private var animatedSymbol: some View {
    if reduceMotion {
      styledSymbol
    } else {
      switch effect {
      case .pulse:
        styledSymbol.symbolEffect(.pulse, options: .repeating)
      case .variableColor:
        styledSymbol.symbolEffect(.variableColor.iterative.reversing, options: .repeating)
      case .breathe:
        breathingSymbol
      }
    }
  }

  @ViewBuilder
  private var breathingSymbol: some View {
    if showsHeroShadow {
      styledSymbol
        .symbolEffect(.breathe, options: .repeating)
        .shadow(color: primary.opacity(isDark ? 0.35 : 0.20), radius: 16, y: 8)
    } else {
      styledSymbol.symbolEffect(.breathe, options: .repeating)
    }
  }

  private var styledSymbol: some View {
    Image(systemName: symbol)
      .font(.system(size: size, weight: .medium))
      .symbolRenderingMode(renderingMode)
      .foregroundStyle(primary, secondary)
  }
}
