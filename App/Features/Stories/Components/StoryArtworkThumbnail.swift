import NukeUI
import SwiftUI

struct StoryArtworkThumbnail: View {
  @Environment(StoryLibrary.self) private var storyLibrary
  @Environment(\.colorScheme) private var colorScheme
  var chapter: StoryChapter
  var height: CGFloat

  private var imageURL: URL? {
    StoryImageLoader.resolveURL(for: chapter.illustrationFilename)
  }

  var body: some View {
    GeometryReader { geometry in
      LazyImage(url: imageURL) { state in
        if let image = state.image {
          image
            .resizable()
            .scaledToFill()
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
        } else if storyLibrary.generatingIllustrationIDs.contains(chapter.id) || state.isLoading {
          StoryIllustrationShimmer()
        } else {
          StoryDoodleIllustrationView(chapter: chapter, style: .thumbnail)
        }
      }
      .pipeline(StoryImageLoader.sharedPipeline)
      .frame(width: geometry.size.width, height: geometry.size.height)
      .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
    .frame(height: height)
    .accessibilityLabel(String(localized: "Illustration for chapter \(chapter.number)", comment: "Localized app copy."))
  }
}
