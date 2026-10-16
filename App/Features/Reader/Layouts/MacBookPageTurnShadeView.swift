import SwiftUI

struct MacBookPageTurnShadeView: View {
  var isForward: Bool
  var progress: CGFloat
  var halfWidth: CGFloat

  var body: some View {
    LinearGradient(
      colors: [Color.black.opacity(shadowStrength), .clear],
      startPoint: isForward ? .leading : .trailing,
      endPoint: isForward ? .trailing : .leading
    )
    .frame(maxWidth: halfWidth * (1 - progress * 0.4), alignment: alignment)
    .frame(maxWidth: .infinity, alignment: alignment)
    .allowsHitTesting(false)
  }

  private var shadowStrength: Double { 0.32 * sin(Double.pi * Double(progress)) }
  private var alignment: Alignment { isForward ? .leading : .trailing }
}
