import SwiftUI

struct AppOnboardingPrivacyCard: View {
  let items: [AppOnboardingPrivacyItem]
  @Environment(\.colorScheme) private var colorScheme

  var body: some View {
    VStack(alignment: .leading, spacing: 14) {
      headerRow
      itemsList
    }
    .padding(16)
    .background(StoryPalette.surface(for: colorScheme), in: RoundedRectangle(cornerRadius: 16))
    .overlay {
      RoundedRectangle(cornerRadius: 16)
        .stroke(StoryPalette.line(for: colorScheme), lineWidth: 1)
    }
  }

  private var headerRow: some View {
    HStack(spacing: 12) {
      Image(systemName: "lock.shield.fill")
        .font(.title3)
        .foregroundStyle(StoryPalette.accent)
        .accessibilityHidden(true)

      Text(String(localized: "Privacy & Peace of Mind", comment: "Onboarding privacy section header."))
        .font(.headline)
    }
  }

  private var itemsList: some View {
    VStack(alignment: .leading, spacing: 12) {
      ForEach(items) { item in
        privacyItemRow(item: item)
      }
    }
  }

  private func privacyItemRow(item: AppOnboardingPrivacyItem) -> some View {
    HStack(alignment: .top, spacing: 12) {
      Image(systemName: item.icon)
        .font(.subheadline)
        .foregroundStyle(StoryPalette.accent)
        .frame(width: 24, height: 24)
        .background(StoryPalette.page(for: colorScheme), in: RoundedRectangle(cornerRadius: 6))
        .accessibilityHidden(true)

      VStack(alignment: .leading, spacing: 2) {
        Text(item.title)
          .font(.subheadline)
          .fontWeight(.medium)
        Text(item.detail)
          .font(.footnote)
          .foregroundStyle(.secondary)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
    .accessibilityElement(children: .combine)
  }
}
