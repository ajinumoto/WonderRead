import SwiftUI

struct CurvedPageMetrics {
  var isForward: Bool
  var progress: CGFloat
  var halfWidth: CGFloat
  var sliceCount = 6

  var baseAngle: Double { (isForward ? -180 : 180) * Double(progress) }
  var progressSin: Double { sin(Double.pi * Double(progress)) }
  var cosProgress: Double { cos(Double.pi * Double(progress)) }
  var sliceWidth: CGFloat { halfWidth / CGFloat(sliceCount) }
  var isFrontVisible: Bool { abs(baseAngle) <= 90 }
}
