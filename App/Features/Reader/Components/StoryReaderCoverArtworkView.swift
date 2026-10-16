import SwiftUI

struct StoryReaderCoverArtworkView: View {
  var url: URL?
  var chapter: StoryChapter?
  var collectionTitle: String

  var body: some View {
    GeometryReader { geometry in
      if let url {
        StoryReaderCoverRemoteArtwork(url: url, size: geometry.size, chapter: chapter, collectionTitle: collectionTitle)
      } else {
        fallbackArtwork
      }
    }
  }

  @ViewBuilder
  private var fallbackArtwork: some View {
    if let chapter {
      StoryDoodleIllustrationView(chapter: chapter, style: .fullPage)
    } else {
      StoryReaderCoverFallbackView(collectionTitle: collectionTitle)
    }
  }
}
