import SwiftUI

struct StoryGenerationWelcomeView: View {
  var compact: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      Label("WonderRead", systemImage: "book.closed.fill")
        .font(.system(.headline, design: .serif))
        .foregroundStyle(StoryPalette.forest)

      HStack(alignment: .center, spacing: 18) {
        VStack(alignment: .leading, spacing: 10) {
          Text(String(localized: "One story. A world of possibilities.", comment: "Localized app copy."))
            .font(.system(compact ? .title : .largeTitle, design: .serif))
            .fixedSize(horizontal: false, vertical: true)

          Text(String(localized: "A continuing story shaped by the things your child loves.", comment: "Localized app copy."))
            .font(.body)
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)

        Image(systemName: "book.closed")
          .font(.system(size: compact ? 40 : 54, weight: .ultraLight))
          .foregroundStyle(.secondary)
          .frame(width: compact ? 80 : 108, height: compact ? 110 : 150)
          .accessibilityHidden(true)
      }

      Label(String(localized: "Computational Literature crafts each story around your choices.", comment: "Localized app copy."), systemImage: "sparkles")
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }
  }
}
