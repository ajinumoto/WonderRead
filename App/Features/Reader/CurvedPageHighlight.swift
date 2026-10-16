import SwiftUI

struct CurvedPageHighlight: View {
  var isForward: Bool
  var metrics: CurvedPageMetrics
  var height: CGFloat

  var body: some View {
    LinearGradient(
      stops: [
        .init(color: .black.opacity(0.16 * metrics.progressSin), location: 0),
        .init(color: .clear, location: 0.20),
        .init(color: .white.opacity(0.26 * metrics.progressSin), location: 0.50),
        .init(color: .clear, location: 0.78),
        .init(color: .black.opacity(0.14 * metrics.progressSin), location: 1)
      ],
      startPoint: isForward ? .leading : .trailing,
      endPoint: isForward ? .trailing : .leading
    )
    .frame(width: metrics.halfWidth, height: height)
    .allowsHitTesting(false)
  }
}
