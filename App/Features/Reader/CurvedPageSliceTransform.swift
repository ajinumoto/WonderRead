import SwiftUI

struct CurvedPageSliceTransform {
  var scale: CGFloat
  var angle: Double

  static func make(index: Int, metrics: CurvedPageMetrics, reduceMotion: Bool) -> CurvedPageSliceTransform {
    let position = (CGFloat(index) + 0.5) / CGFloat(metrics.sliceCount)
    let arch = sin(Double.pi * Double(position))
    let slope = cos(Double.pi * Double(position))
    let scale = reduceMotion ? 1 : 1 + (0.045 * metrics.progressSin * arch)
    let angle = (metrics.isFrontVisible ? -1 : 1) * 18 * metrics.progressSin * slope
    return CurvedPageSliceTransform(scale: scale, angle: reduceMotion ? 0 : angle)
  }
}
