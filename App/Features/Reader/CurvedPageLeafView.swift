import SwiftUI

struct CurvedPageLeafView<Front: View, Back: View>: View {
  var front: Front
  var back: Back
  var isForward: Bool
  var dragProgress: CGFloat
  var halfWidth: CGFloat
  var height: CGFloat
  var spineIntensity: Double
  var reduceMotion: Bool

  private var metrics: CurvedPageMetrics {
    CurvedPageMetrics(isForward: isForward, progress: dragProgress, halfWidth: halfWidth)
  }

  var body: some View {
    ZStack {
      CurvedPageSliceStrip(front: front, back: back, metrics: metrics, height: height, reduceMotion: reduceMotion)
      CurvedPageBindingCrease(isForward: isForward, metrics: metrics, height: height, spineIntensity: spineIntensity)
      CurvedPageHighlight(isForward: isForward, metrics: metrics, height: height)
    }
    .frame(width: halfWidth, height: height)
    .rotation3DEffect(
      .degrees(reduceMotion ? 0 : metrics.baseAngle),
      axis: (x: 0, y: 1, z: 0),
      anchor: isForward ? .leading : .trailing,
      perspective: 0.65
    )
    .shadow(
      color: StoryPalette.deepForest.opacity(0.28 * metrics.progressSin),
      radius: 16 * metrics.progressSin,
      x: (isForward ? -14 : 14) * metrics.cosProgress,
      y: 6
    )
  }
}
