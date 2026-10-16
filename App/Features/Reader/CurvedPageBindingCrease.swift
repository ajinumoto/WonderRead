import SwiftUI

struct CurvedPageBindingCrease: View {
  var isForward: Bool
  var metrics: CurvedPageMetrics
  var height: CGFloat
  var spineIntensity: Double

  var body: some View {
    HStack(spacing: 0) {
      if isForward {
        BookSpineShadow(edge: .leading, intensity: intensity)
        Spacer(minLength: 0)
      } else {
        Spacer(minLength: 0)
        BookSpineShadow(edge: .trailing, intensity: intensity)
      }
    }
    .frame(width: metrics.halfWidth, height: height)
    .allowsHitTesting(false)
  }

  private var intensity: Double { spineIntensity * (1 + metrics.progressSin * 0.75) }
}
