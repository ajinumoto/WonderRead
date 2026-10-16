import SwiftUI

struct MacBookWideForwardTurnView: View {
  var size: CGSize
  var illustration: MacReaderPageContent
  var text: MacReaderPageContent
  var leafFront: MacReaderPageContent
  var leafBack: MacReaderPageContent
  var progress: CGFloat
  var spineIntensity: Double
  var reduceMotion: Bool

  var body: some View {
    let halfWidth = size.width / 2
    ZStack {
      HStack(spacing: 0) {
        illustration.frame(width: halfWidth, height: size.height)
          .overlay(alignment: .trailing) { BookSpineShadow(edge: .trailing, intensity: spineIntensity) }
        text.frame(width: halfWidth, height: size.height)
          .overlay(alignment: .leading) { BookSpineShadow(edge: .leading, intensity: spineIntensity) }
          .overlay { MacBookPageTurnShadeView(isForward: true, progress: progress, halfWidth: halfWidth) }
      }
      CurvedPageLeafView(
        front: leafFront,
        back: leafBack,
        isForward: true,
        dragProgress: progress,
        halfWidth: halfWidth,
        height: size.height,
        spineIntensity: spineIntensity,
        reduceMotion: reduceMotion
      )
      .position(x: halfWidth * 1.5, y: size.height / 2)
    }
    .frame(width: size.width, height: size.height)
  }
}
