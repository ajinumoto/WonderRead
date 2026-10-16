import SwiftUI

struct StoryBookCoverCanvas: View {
  var seriesBadge: String?
  var title: String
  var chapter: StoryChapter?
  var imageURL: URL?
  var metrics: StoryBookCoverMetrics
  var openTrigger: Int

  var body: some View {
    ZStack(alignment: .bottom) {
      StoryBookCoverFullBleedArtwork(title: title, chapter: chapter, imageURL: imageURL)
        .frame(width: metrics.size.width, height: metrics.size.height)
        .clipped()
      coverScrim.frame(width: metrics.size.width, height: metrics.size.height)
      StoryBookCoverTypography(seriesBadge: seriesBadge, title: title, metrics: metrics)
    }
    .frame(width: metrics.size.width, height: metrics.size.height)
    .overlay(alignment: .topTrailing) { StoryBookCoverTapBadge(openTrigger: openTrigger) }
    .overlay(alignment: .leading) {
      BookSpineShadow(edge: .leading, width: 22, intensity: 0.85, showsCreaseLine: false)
    }
    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
  }

  private var coverScrim: some View {
    LinearGradient(
      stops: [
        .init(color: .black.opacity(0.18), location: 0),
        .init(color: .clear, location: 0.35),
        .init(color: .black.opacity(0.28), location: 0.55),
        .init(color: .black.opacity(0.82), location: 1)
      ],
      startPoint: .top,
      endPoint: .bottom
    )
  }
}
