import SwiftUI

struct StoryBookCoverFallbackArtwork: View {
  var title: String

  var body: some View {
    ZStack {
      Self.gradient
      VStack(spacing: 12) {
        Image(systemName: "books.vertical.fill")
          .font(.system(size: 46))
          .foregroundStyle(StoryPalette.gold.opacity(0.75))
        Text(title)
          .font(.system(.title3, design: .serif).weight(.medium))
          .foregroundStyle(.white.opacity(0.85))
          .multilineTextAlignment(.center)
          .padding(.horizontal, 24)
      }
      .padding(.bottom, 40)
    }
  }

  static var gradient: LinearGradient {
    LinearGradient(
      colors: [
        Color(red: 0.16, green: 0.28, blue: 0.24),
        StoryPalette.deepForest,
        Color(red: 0.09, green: 0.18, blue: 0.15)
      ],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    )
  }
}
