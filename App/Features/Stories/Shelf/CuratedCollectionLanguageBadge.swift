import SwiftUI

struct CuratedCollectionLanguageBadge: View {
  var language: StoryLanguage
  var colorScheme: ColorScheme

  var body: some View {
    Text(language.flagBadge)
      .font(.caption2.weight(.semibold))
      .padding(.horizontal, 6)
      .padding(.vertical, 3)
      .background(StoryPalette.surface(for: colorScheme), in: Capsule())
      .overlay { Capsule().stroke(StoryPalette.line(for: colorScheme), lineWidth: 1) }
      .foregroundStyle(.secondary)
  }
}
