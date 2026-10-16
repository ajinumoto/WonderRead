import SwiftUI

struct StoryHistoryRow: View {
  var chapter: StoryChapter

  var body: some View {
    HStack(spacing: 16) {
      StoryArtworkThumbnail(chapter: chapter, height: 72)
        .frame(width: 54)
        .accessibilityHidden(true)

      VStack(alignment: .leading, spacing: 6) {
        Text(chapter.seriesTitle)
          .font(.system(.headline, design: .serif))
          .foregroundStyle(.primary)
          .lineLimit(1)

        Text(chapter.title)
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .lineLimit(2)

        Text(String(localized: "Chapter \(chapter.number) · \(generatedDate)", comment: "Localized app copy."))
          .font(.caption)
          .foregroundStyle(.tertiary)
      }

      Spacer(minLength: 4)

      Image(systemName: "chevron.right")
        .font(.footnote.weight(.semibold))
        .foregroundStyle(.tertiary)
        .accessibilityHidden(true)
    }
    .padding(.vertical, 7)
    .contentShape(Rectangle())
  }

  private var generatedDate: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: StoryLanguage.current.identifier)
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: chapter.generatedAt)
  }
}
