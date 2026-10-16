import SwiftUI

struct StoryDoodleFullPageView: View {
  @Environment(\.colorScheme) private var colorScheme
  var chapter: StoryChapter
  var theme: StoryDoodleTheme
  var isFloating: Bool
  var isSwaying: Bool

  var body: some View {
    GeometryReader { geometry in
      let metrics = StoryDoodleMetrics.fullPage(for: geometry.size)
      ZStack {
        StoryDoodleBackdropView(theme: theme, colorScheme: colorScheme, minDimension: metrics.minDimension, isFloating: isFloating)
        VStack(spacing: 20) {
          Spacer(minLength: 0)
          StoryDoodleHeroArtworkView(theme: theme, colorScheme: colorScheme, metrics: metrics, isFloating: isFloating, isSwaying: isSwaying)
          StoryDoodleCaptionView(chapter: chapter, theme: theme, colorScheme: colorScheme)
          Spacer(minLength: 0)
        }
      }
      .frame(width: geometry.size.width, height: geometry.size.height)
    }
  }
}
