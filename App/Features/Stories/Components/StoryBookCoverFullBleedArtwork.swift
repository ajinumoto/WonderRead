import NukeUI
import SwiftUI

struct StoryBookCoverFullBleedArtwork: View {
  var title: String
  var chapter: StoryChapter?
  var imageURL: URL?

  var body: some View {
    if let imageURL {
      LazyImage(url: imageURL) { state in
        if let image = state.image {
          image.resizable().scaledToFill().clipped()
        } else if state.isLoading {
          StoryBookCoverLoadingArtwork()
        } else {
          fallbackArtwork
        }
      }
      .pipeline(StoryImageLoader.sharedPipeline)
    } else {
      fallbackArtwork
    }
  }

  @ViewBuilder
  private var fallbackArtwork: some View {
    if let chapter {
      StoryDoodleIllustrationView(chapter: chapter, style: .fullPage)
    } else {
      StoryBookCoverFallbackArtwork(title: title)
    }
  }
}

private struct StoryBookCoverLoadingArtwork: View {
  var body: some View {
    Rectangle()
      .fill(StoryBookCoverFallbackArtwork.gradient)
      .overlay { ProgressView().tint(StoryPalette.gold) }
  }
}
