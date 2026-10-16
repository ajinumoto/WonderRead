import SwiftUI

struct StoryDoodleBackdropView: View {
  var theme: StoryDoodleTheme
  var colorScheme: ColorScheme
  var minDimension: CGFloat
  var isFloating: Bool

  var body: some View {
    ZStack {
      StoryPalette.surface(for: colorScheme).ignoresSafeArea()
      aura
      RoundedRectangle(cornerRadius: 24, style: .continuous)
        .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [8, 8]))
        .foregroundStyle(theme.primaryColor(for: colorScheme).opacity(0.20))
        .padding(20)
    }
  }

  private var aura: some View {
    Circle()
      .fill(RadialGradient(
        colors: [
          theme.primaryColor(for: colorScheme).opacity(colorScheme == .dark ? 0.22 : 0.14),
          theme.secondaryColor(for: colorScheme).opacity(colorScheme == .dark ? 0.08 : 0.05),
          .clear
        ],
        center: .center,
        startRadius: 20,
        endRadius: minDimension * 0.45
      ))
      .frame(width: minDimension * 0.9, height: minDimension * 0.9)
      .scaleEffect(isFloating ? 1.05 : 0.96)
  }
}
