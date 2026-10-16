import SwiftUI

struct StoryReaderCoverBottomContent: View {
  var seriesBadge: String?
  var collectionTitle: String

  var body: some View {
    VStack(spacing: 12) {
      if let seriesBadge, !seriesBadge.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        StoryReaderCoverBadge(title: seriesBadge)
      }
      Text(collectionTitle)
        .font(.system(size: 32, weight: .bold, design: .serif))
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .shadow(color: .black.opacity(0.7), radius: 6, x: 0, y: 2)
        .padding(.horizontal, 28)
      StoryReaderCoverSwipeHint().padding(.top, 4)
    }
    .frame(maxWidth: .infinity)
  }
}
