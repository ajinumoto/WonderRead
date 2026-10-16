import SwiftUI

struct StoryReaderCoverBadge: View {
  var title: String

  var body: some View {
    HStack(spacing: 5) {
      Image(systemName: "bookmark.fill").font(.system(size: 9))
      Text(title.trimmingCharacters(in: .whitespacesAndNewlines).uppercased())
        .font(.system(size: 11, weight: .bold, design: .serif))
        .tracking(2)
    }
    .foregroundStyle(StoryPalette.gold)
    .padding(.horizontal, 14)
    .padding(.vertical, 6)
    .background(.ultraThinMaterial, in: Capsule())
    .overlay { Capsule().stroke(StoryPalette.gold.opacity(0.45), lineWidth: 1) }
  }
}
