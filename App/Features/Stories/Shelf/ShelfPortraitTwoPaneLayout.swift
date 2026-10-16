import SwiftUI

struct ShelfPortraitTwoPaneLayout: View {
  @Environment(\.colorScheme) private var colorScheme
  var geometry: GeometryProxy
  var primary: ShelfPrimaryPane
  var secondary: ShelfSecondaryPane
  var onRefresh: () async -> Void

  private var metrics: ShelfTwoPaneMetrics { ShelfTwoPaneMetricsMapper.portrait(in: geometry) }

  var body: some View {
    VStack(spacing: 0) {
      secondary.padding(16).frame(maxWidth: .infinity).frame(height: metrics.contentExtent).clipped()
      if metrics.hingeGap > 0 { Color.clear.frame(height: metrics.hingeGap) }
      ScrollView {
        primary.padding(24).frame(maxWidth: 700, alignment: .leading).frame(maxWidth: .infinity)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(StoryPalette.page(for: colorScheme))
      .refreshable { await onRefresh() }
      .scrollIndicators(.hidden)
    }
  }
}
