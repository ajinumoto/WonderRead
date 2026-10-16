import SwiftUI

struct StoryBookCoverTypography: View {
  var seriesBadge: String?
  var title: String
  var metrics: StoryBookCoverMetrics

  var body: some View {
    VStack(spacing: metrics.contentSpacing) {
      if let badge = cleanedBadge { StoryBookCoverBadge(title: badge) }
      Text(title)
        .font(.system(size: metrics.titleFontSize, weight: .bold, design: .serif))
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .shadow(color: .black.opacity(0.75), radius: 6, x: 0, y: 2)
        .padding(.horizontal, 16)
        .lineLimit(2)
    }
    .frame(maxWidth: .infinity)
    .padding(.bottom, metrics.bottomPadding)
    .padding(.horizontal, 12)
  }

  private var cleanedBadge: String? {
    guard let value = seriesBadge?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty else { return nil }
    return value
  }
}
