import SwiftUI

struct StoryReaderCoverScrim: View {
  var body: some View {
    LinearGradient(
      stops: [
        .init(color: .black.opacity(0.15), location: 0),
        .init(color: .clear, location: 0.35),
        .init(color: .black.opacity(0.25), location: 0.55),
        .init(color: .black.opacity(0.80), location: 1)
      ],
      startPoint: .top,
      endPoint: .bottom
    )
  }
}
