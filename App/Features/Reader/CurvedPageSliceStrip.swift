import SwiftUI

struct CurvedPageSliceStrip<Front: View, Back: View>: View {
  var front: Front
  var back: Back
  var metrics: CurvedPageMetrics
  var height: CGFloat
  var reduceMotion: Bool

  var body: some View {
    HStack(spacing: 0) {
      ForEach(0..<metrics.sliceCount, id: \.self) { index in
        CurvedPageSlice(
          front: front,
          back: back,
          index: index,
          metrics: metrics,
          height: height,
          reduceMotion: reduceMotion
        )
      }
    }
    .frame(width: metrics.halfWidth, height: height)
  }
}
