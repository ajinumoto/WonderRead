import SwiftUI

struct StoryDoodleCaptionView: View {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion
  var chapter: StoryChapter
  var theme: StoryDoodleTheme
  var colorScheme: ColorScheme

  var body: some View {
    VStack(spacing: 6) {
      Text(chapter.title.isEmpty ? String(localized: "Chapter \(chapter.number)", comment: "Localized app copy.") : chapter.title)
        .font(.headline)
        .foregroundStyle(.primary)
        .multilineTextAlignment(.center)
        .lineLimit(2)
        .padding(.horizontal, 32)
      themeLabel
    }
  }

  private var themeLabel: some View {
    HStack(spacing: 6) {
      sparkle
      Text(theme.title)
      sparkle
    }
    .font(.caption.weight(.medium))
    .foregroundStyle(theme.primaryColor(for: colorScheme))
  }

  @ViewBuilder
  private var sparkle: some View {
    if reduceMotion {
      Image(systemName: "sparkles")
    } else {
      Image(systemName: "sparkles")
        .symbolEffect(.pulse, options: .repeat(2))
    }
  }
}
