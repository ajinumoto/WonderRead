import SwiftUI

struct StoryDoodleThumbnailView: View {
  @Environment(\.colorScheme) private var colorScheme
  var theme: StoryDoodleTheme
  var isFloating: Bool
  var isSwaying: Bool

  var body: some View {
    GeometryReader { geometry in
      let metrics = StoryDoodleMetrics.thumbnail(for: geometry.size)
      ZStack {
        StoryDoodleThumbnailBackdropView(theme: theme, colorScheme: colorScheme, metrics: metrics, isFloating: isFloating)
        StoryDoodleThumbnailArtworkView(theme: theme, colorScheme: colorScheme, metrics: metrics, isFloating: isFloating, isSwaying: isSwaying)
      }
      .frame(width: geometry.size.width, height: geometry.size.height)
    }
  }
}
