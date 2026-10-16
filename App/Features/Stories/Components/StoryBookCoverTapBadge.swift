import SwiftUI

struct StoryBookCoverTapBadge: View {
  var openTrigger: Int

  var body: some View {
    HStack(spacing: 5) {
      Text(String(localized: "tap to open", comment: "Localized app copy."))
        .font(.system(size: 11, weight: .semibold, design: .rounded))
        .tracking(0.3)
      Image(systemName: "book.pages.fill")
        .font(.system(size: 10, weight: .bold))
        .symbolEffect(.bounce, value: openTrigger)
    }
    .foregroundStyle(.white.opacity(0.95))
    .padding(.horizontal, 11)
    .padding(.vertical, 6)
    .background(.ultraThinMaterial.opacity(0.65), in: Capsule())
    .overlay { Capsule().stroke(Color.white.opacity(0.28), lineWidth: 0.8) }
    .shadow(color: .black.opacity(0.35), radius: 6, x: 0, y: 2)
    .padding(.top, 14)
    .padding(.trailing, 14)
  }
}
