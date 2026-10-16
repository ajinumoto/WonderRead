import SwiftUI

struct StoryBookCoverBadge: View {
  var title: String

  var body: some View {
    HStack(spacing: 5) {
      Image(systemName: "bookmark.fill").font(.system(size: 8))
      Text(title.uppercased()).font(.system(size: 9, weight: .bold, design: .serif)).tracking(1.5)
    }
    .foregroundStyle(StoryPalette.gold)
    .padding(.horizontal, 10)
    .padding(.vertical, 4)
    .background(.ultraThinMaterial, in: Capsule())
    .overlay { Capsule().stroke(StoryPalette.gold.opacity(0.45), lineWidth: 0.8) }
  }
}
