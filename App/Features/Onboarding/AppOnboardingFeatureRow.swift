import SwiftUI

struct AppOnboardingFeatureRow: View {
  var symbol: String
  var title: String
  var detail: String

  var body: some View {
    HStack(alignment: .top, spacing: 14) {
      Image(systemName: symbol)
        .font(.headline)
        .foregroundStyle(.tint)
        .frame(width: 40, height: 40)
        .background(StoryPalette.surface(for: colorScheme), in: RoundedRectangle(cornerRadius: 12))
        .accessibilityHidden(true)

      VStack(alignment: .leading, spacing: 4) {
        Text(title).font(.headline)
        Text(detail)
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
    .accessibilityElement(children: .combine)
  }

  @Environment(\.colorScheme) private var colorScheme
}
