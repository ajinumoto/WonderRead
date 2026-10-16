import SwiftUI

struct CuratedCollectionsEmptyState: View {
  @Environment(\.colorScheme) private var colorScheme

  var body: some View {
    HStack(spacing: 10) {
      Image(systemName: "books.vertical")
        .font(.subheadline)
        .foregroundStyle(.tertiary)
      Text(String(localized: "No story collections from Supabase available for this language.", comment: "Localized app copy."))
      .font(.footnote)
      .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.vertical, 14)
    .padding(.horizontal, 16)
    .background(StoryPalette.surface(for: colorScheme), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    .overlay {
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .stroke(StoryPalette.line(for: colorScheme), lineWidth: 1)
    }
  }
}
