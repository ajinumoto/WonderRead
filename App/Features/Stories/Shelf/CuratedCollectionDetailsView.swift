import SwiftUI

struct CuratedCollectionDetailsView: View {
  @Environment(\.colorScheme) private var colorScheme
  var collection: StoryCollection

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      badges
      title
      description
      CuratedCollectionFooter(collection: collection).padding(.top, 4)
    }
  }

  @ViewBuilder
  private var badges: some View {
    HStack(spacing: 6) {
      if let badge = collection.badge, !badge.isEmpty { CuratedCollectionBadge(title: badge) }
      CuratedCollectionLanguageBadge(language: collection.storyLanguage, colorScheme: colorScheme)
    }
  }

  private var title: some View {
    Text(collection.title)
      .font(.system(.headline, design: .serif))
      .foregroundStyle(.primary)
      .multilineTextAlignment(.leading)
      .lineLimit(2)
  }

  @ViewBuilder
  private var description: some View {
    if !collection.description.isEmpty {
      Text(collection.description)
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .lineLimit(2)
        .multilineTextAlignment(.leading)
    }
  }
}
