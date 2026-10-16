import ImageIO
import NukeUI
import SwiftUI

struct StoryIllustrationPage: View {
  @Environment(StoryLibrary.self) private var storyLibrary
  @Environment(\.colorScheme) private var colorScheme
  var chapter: StoryChapter

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
            .storyIllustrationMotion(in: geometry.size)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
            .accessibilityLabel(String(localized: "Story illustration for chapter \(chapter.number)", comment: "Localized app copy."))
        } else if storyLibrary.generatingIllustrationIDs.contains(chapter.id) || state.isLoading {
          StoryIllustrationShimmer()
        } else {
          StoryDoodleIllustrationView(chapter: chapter, style: .fullPage)
        }
      }
      .pipeline(StoryImageLoader.sharedPipeline)
      .id("\(chapter.illustrationFilename)-\(storyLibrary.illustrationRevision)")
      .frame(width: geometry.size.width, height: geometry.size.height)
      .background(StoryPalette.surface(for: colorScheme))
    }
    .ignoresSafeArea()
    .background(StoryPalette.surface(for: colorScheme))
  }
}
