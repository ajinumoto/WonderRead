import NukeUI
import SwiftUI

struct CuratedCollectionCoverView: View {
  @Environment(\.colorScheme) private var colorScheme
  var url: URL?

  var body: some View {
    LazyImage(url: url) { state in
      if let image = state.image {
        image.resizable().scaledToFill().frame(width: 88, height: 110).clipped()
      } else if state.isLoading {
        placeholder { ProgressView().tint(StoryPalette.clay) }
      } else {
        placeholder {
          Image(systemName: "book.closed").font(.title2).foregroundStyle(StoryPalette.clay)
        }
      }
    }
    .pipeline(StoryImageLoader.sharedPipeline)
    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    .overlay { RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(StoryPalette.line(for: colorScheme), lineWidth: 1) }
  }

  private func placeholder<Content: View>(@ViewBuilder content: () -> Content) -> some View {
    Rectangle()
      .fill(StoryPalette.clay.opacity(0.12))
      .frame(width: 88, height: 110)
      .overlay(content: content)
  }
}
