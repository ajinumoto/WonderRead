import SwiftUI

struct CuratedCollectionCard: View {
  @Environment(\.colorScheme) private var colorScheme
  var collection: StoryCollection
  var onSelect: () -> Void

  private var coverURL: URL? { StoryImageLoader.resolveURL(for: collection.coverImageURL) }

  var body: some View {
    Button(action: onSelect) {
      HStack(spacing: 16) {
        CuratedCollectionCoverView(url: coverURL)
        CuratedCollectionDetailsView(collection: collection)
      }
      .padding(14)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(StoryPalette.surface(for: colorScheme), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
      .overlay { RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(StoryPalette.line(for: colorScheme), lineWidth: 1) }
      .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
      #if os(iOS)
      .hoverEffect(.lift)
      #endif
    }
    .buttonStyle(.plain)
  }
}
