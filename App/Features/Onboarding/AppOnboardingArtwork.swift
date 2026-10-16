import SwiftUI

struct AppOnboardingArtwork: View {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion
  @State private var hasAppeared = false

  var body: some View {
    ZStack {
      Circle()
        .fill(StoryPalette.gold.opacity(0.2))
        .frame(width: 184, height: 184)

      Image(systemName: "books.vertical.fill")
        .font(.system(size: 72, weight: .regular))
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(.tint)
        .symbolEffect(.bounce.up.byLayer, value: hasAppeared)

      Image(systemName: "sparkles")
        .font(.system(size: 28, weight: .medium))
        .foregroundStyle(StoryPalette.clay)
        .offset(x: 66, y: -58)
        .symbolEffect(.variableColor.iterative.reversing, options: .repeating, isActive: !reduceMotion)
    }
    .frame(maxWidth: .infinity)
    .frame(height: 210)
    .accessibilityHidden(true)
    .onAppear { hasAppeared = true }
  }
}
