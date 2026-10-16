import SwiftUI

struct StoryCompactPage: View {
  @Environment(\.colorScheme) private var colorScheme
  var chapter: StoryChapter
  var nickname: String
  var textScale: CGFloat

  var body: some View {
    GeometryReader { geometry in
      scrollablePages(height: geometry.size.height)
    }
  }

  private func scrollablePages(height: CGFloat) -> some View {
    ScrollView {
      VStack(spacing: 0) {
        illustration(height: height)
        storyText
      }
      .frame(maxWidth: .infinity)
    }
    .scrollIndicators(.hidden)
    .background(StoryPalette.surface(for: colorScheme))
  }

  private func illustration(height: CGFloat) -> some View {
    StoryIllustrationPage(chapter: chapter)
      .frame(maxWidth: .infinity)
      .frame(height: max(230, height * 0.38))
      .clipped()
  }

  private var storyText: some View {
    StoryTextContent(chapter: chapter, nickname: nickname, textScale: textScale)
      .padding(.horizontal, 26)
      .padding(.vertical, 30)
      .frame(maxWidth: 640, alignment: .leading)
      .frame(maxWidth: .infinity)
      .background(StoryPalette.surface(for: colorScheme))
      .safeAreaPadding(.horizontal)
      .safeAreaPadding(.bottom)
  }
}
