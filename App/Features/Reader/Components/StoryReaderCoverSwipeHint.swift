import SwiftUI

struct StoryReaderCoverSwipeHint: View {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  var body: some View {
    HStack(spacing: 7) {
      Image(systemName: "arrow.left")
        .font(.system(size: 11, weight: .bold))
        .symbolEffect(.wiggle.left, options: .repeat(.periodic(delay: 2.5)), isActive: !reduceMotion)
      Text(String(localized: "swipe to open", comment: "Localized app copy."))
        .font(.system(size: 12, weight: .semibold, design: .rounded))
        .tracking(0.4)
    }
    .foregroundStyle(.white.opacity(0.92))
    .padding(.horizontal, 14)
    .padding(.vertical, 7)
    .background(.ultraThinMaterial.opacity(0.6), in: Capsule())
    .overlay { Capsule().stroke(.white.opacity(0.25), lineWidth: 0.8) }
    .shadow(color: .black.opacity(0.35), radius: 5, x: 0, y: 2)
    .accessibilityHidden(true)
  }
}
