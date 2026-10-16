import SwiftUI

struct CuratedCollectionBadge: View {
  var title: String

  var body: some View {
    Text(title)
      .font(.caption2.weight(.bold))
      .padding(.horizontal, 8)
      .padding(.vertical, 3)
      .background(StoryPalette.clay.opacity(0.15), in: Capsule())
      .foregroundStyle(StoryPalette.clay)
  }
}
