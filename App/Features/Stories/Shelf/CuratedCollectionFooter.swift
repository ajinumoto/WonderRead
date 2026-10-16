import SwiftUI

struct CuratedCollectionFooter: View {
  var collection: StoryCollection

  var body: some View {
    HStack(spacing: 6) {
      Image(systemName: "book").font(.caption)
      Text(String(localized: "\(collection.chapters.count) Stories", comment: "Localized app copy."))
        .font(.caption.weight(.medium))
      Spacer()
      Text(String(localized: "Open Book →", comment: "Localized app copy."))
        .font(.caption.weight(.semibold))
        .foregroundStyle(StoryPalette.accent)
    }
  }
}
