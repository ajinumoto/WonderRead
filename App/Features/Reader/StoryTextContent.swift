import SwiftUI

struct StoryTextContent: View {
  @ScaledMetric(relativeTo: .largeTitle) private var titleFontSize: CGFloat = 34
  @ScaledMetric(relativeTo: .title3) private var paragraphFontSize: CGFloat = 20

  var chapter: StoryChapter
  var nickname: String
  var textScale: CGFloat = 1

  var body: some View {
    VStack(alignment: .leading, spacing: 28) {
      VStack(alignment: .leading, spacing: 12) {
        Text(StoryTextContentMapper.chapterHeader(for: chapter))
          .font(.caption.weight(.semibold))
          .tracking(1.1)
          .foregroundStyle(StoryPalette.forest)

        Text(chapter.title)
          .font(.system(size: titleFontSize * textScale, design: .serif))
          .fixedSize(horizontal: false, vertical: true)

        if !chapter.isCurated {
          Text(String(localized: "For \(nickname)", comment: "Localized app copy."))
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
      }

      VStack(alignment: .leading, spacing: 22) {
        ForEach(chapter.paragraphs.indices, id: \.self) { index in
          Text(chapter.paragraphs[index])
            .font(.system(size: paragraphFontSize * textScale, design: .serif))
            .lineSpacing(8 * textScale)
            .fixedSize(horizontal: false, vertical: true)
        }
        if chapter.isFinalCuratedChapter {
          StoryCollectionEndMark().padding(.top, 36)
        }
      }
      .foregroundStyle(.primary)
    }
  }
}
