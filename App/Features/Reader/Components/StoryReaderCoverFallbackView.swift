import SwiftUI

struct StoryReaderCoverFallbackView: View {
  var collectionTitle: String

  var body: some View {
    ZStack {
      Self.gradient
      VStack(spacing: 12) {
        Image(systemName: "books.vertical.fill")
          .font(.system(size: 52))
          .foregroundStyle(StoryPalette.gold.opacity(0.7))
        Text(collectionTitle)
          .font(.system(.title2, design: .serif).weight(.medium))
          .foregroundStyle(.white.opacity(0.85))
          .multilineTextAlignment(.center)
          .padding(.horizontal, 32)
      }
    }
  }

  static var gradient: LinearGradient {
    LinearGradient(
      colors: [Color(red: 0.16, green: 0.28, blue: 0.24), StoryPalette.deepForest, Color(red: 0.09, green: 0.18, blue: 0.15)],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    )
  }
}
