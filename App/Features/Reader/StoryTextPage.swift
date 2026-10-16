import SwiftUI

struct StoryTextPage: View {
  @Environment(\.colorScheme) private var colorScheme
  var chapter: StoryChapter
  var nickname: String
  var textScale: CGFloat
  var additionalTrailingPadding: CGFloat = 0
  var maxContentWidth: CGFloat? = nil

  var body: some View {
    GeometryReader { geometry in
      let isCompactHeight = geometry.size.height > 0 && geometry.size.height < 450
      ScrollView {
        StoryTextContent(chapter: chapter, nickname: nickname, textScale: textScale)
          .padding(.leading, isCompactHeight ? 16 : 24)
          .padding(.trailing, (isCompactHeight ? 28 : 48) + additionalTrailingPadding)
          .padding(.top, isCompactHeight ? 18 : 34)
          .padding(.bottom, isCompactHeight ? 56 : 72)
          .frame(maxWidth: maxContentWidth ?? 680, alignment: .leading)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .scrollIndicators(.hidden)
    }
    .background(StoryPalette.surface(for: colorScheme))
  }
}
