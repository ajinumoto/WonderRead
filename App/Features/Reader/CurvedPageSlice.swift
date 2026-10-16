import SwiftUI

struct CurvedPageSlice<Front: View, Back: View>: View {
  @Environment(\.colorScheme) private var colorScheme
  var front: Front
  var back: Back
  var index: Int
  var metrics: CurvedPageMetrics
  var height: CGFloat
  var reduceMotion: Bool

  private var transform: CurvedPageSliceTransform {
    CurvedPageSliceTransform.make(index: index, metrics: metrics, reduceMotion: reduceMotion)
  }

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 1).fill(StoryPalette.surface(for: colorScheme))
      pageFace
    }
    .frame(width: metrics.sliceWidth, height: height)
    .rotation3DEffect(.degrees(transform.angle), axis: (x: 0, y: 1, z: 0), anchor: .center, perspective: 0.65)
    .scaleEffect(transform.scale)
  }

  @ViewBuilder
  private var pageFace: some View {
    if metrics.isFrontVisible {
      front.frame(width: metrics.halfWidth, height: height)
        .offset(x: -CGFloat(index) * metrics.sliceWidth)
        .frame(width: metrics.sliceWidth, height: height, alignment: .leading)
        .clipped()
    } else {
      back.frame(width: metrics.halfWidth, height: height)
        .scaleEffect(x: -1)
        .offset(x: -CGFloat(index) * metrics.sliceWidth)
        .frame(width: metrics.sliceWidth, height: height, alignment: .leading)
        .clipped()
    }
  }
}
