import NukeUI
import SwiftUI

struct StoryReaderCoverRemoteArtwork: View {
  var url: URL
  var size: CGSize
  var chapter: StoryChapter?
  var collectionTitle: String

  var body: some View {
    LazyImage(url: url) { state in
      if let image = state.image {
        image
          .resizable()
          .scaledToFill()
          .storyIllustrationMotion(in: size, isCover: true)
          .frame(width: size.width, height: size.height)
          .clipped()
      } else if state.isLoading {
        Rectangle().fill(StoryReaderCoverFallbackView.gradient)
          .overlay { ProgressView().tint(StoryPalette.gold) }
      } else if let chapter {
        StoryDoodleIllustrationView(chapter: chapter, style: .fullPage)
      } else {
        StoryReaderCoverFallbackView(collectionTitle: collectionTitle)
      }
    }
    .pipeline(StoryImageLoader.sharedPipeline)
  }
}
