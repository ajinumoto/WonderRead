import SwiftUI

struct ShelfLandscapeTwoPaneLayout: View {
  @Environment(\.colorScheme) private var colorScheme
  var geometry: GeometryProxy
  var primary: ShelfPrimaryPane
  var secondary: ShelfSecondaryPane
  var onRefresh: () async -> Void

  private var metrics: ShelfTwoPaneMetrics { ShelfTwoPaneMetricsMapper.landscape(in: geometry) }

  var body: some View {
    HStack(alignment: .top, spacing: 0) {
      secondary.padding(16).frame(width: metrics.contentExtent, height: geometry.size.height).clipped()
      if metrics.hingeGap > 0 { Color.clear.frame(width: metrics.hingeGap) }
      ScrollView {
        primary.padding(28).frame(maxWidth: 700, alignment: .leading).frame(maxWidth: .infinity)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(StoryPalette.page(for: colorScheme))
      .refreshable { await onRefresh() }
      .scrollIndicators(.hidden)
    }
  }
}
