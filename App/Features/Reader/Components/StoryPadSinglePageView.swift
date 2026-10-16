import SwiftUI

// MARK: - Reusable Reader Background

struct StoryPadSinglePageView: View {
  @Environment(\.colorScheme) private var colorScheme
  var chapter: StoryChapter
  var nickname: String
  var textScale: CGFloat

  var body: some View {
    GeometryReader { geometry in
      HStack(spacing: 0) {
        StoryIllustrationPage(chapter: chapter)
          .frame(width: max(geometry.size.width * 0.33, 200))
          .frame(maxHeight: .infinity)
          .clipped()

        StoryTextPage(
          chapter: chapter,
          nickname: nickname,
          textScale: textScale
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(StoryPalette.surface(for: colorScheme))
    }
  }
}
