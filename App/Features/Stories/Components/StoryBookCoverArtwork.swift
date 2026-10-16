import SwiftUI

struct StoryBookCoverArtwork: View {
  var seriesBadge: String?
  var title: String
  var chapter: StoryChapter?
  var imageURL: URL?
  var openTrigger: Int

  var body: some View {
    GeometryReader { proxy in
      let metrics = StoryBookCoverMetrics(size: proxy.size)
      StoryBookCoverCanvas(
        seriesBadge: seriesBadge,
        title: title,
        chapter: chapter,
        imageURL: imageURL,
        metrics: metrics,
        openTrigger: openTrigger
      )
    }
  }
}

struct StoryBookCoverMetrics {
  var size: CGSize
  var isCompact: Bool { size.height < 320 }
  var titleFontSize: CGFloat { isCompact ? 18 : 22 }
  var bottomPadding: CGFloat { isCompact ? 14 : 22 }
  var contentSpacing: CGFloat { isCompact ? 6 : 8 }
}
