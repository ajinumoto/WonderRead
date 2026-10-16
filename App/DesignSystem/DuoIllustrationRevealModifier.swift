import SwiftUI

#if os(iOS)
@available(iOS 27.1, *)
public struct DuoIllustrationRevealModifier: ViewModifier {
  @Environment(HingeProgress.self) private var hingeProgress: HingeProgress?

  public func body(content: Content) -> some View {
    let progressValue = hingeProgress?.value ?? 1.0
    let scale = 0.95 + (0.05 * progressValue)
    let opacity = 0.6 + (0.4 * progressValue)

    content
      .scaleEffect(scale)
      .opacity(opacity)
      .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.8), value: progressValue)
  }
}

public extension View {
  @ViewBuilder
  func duoRevealEffect() -> some View {
    if #available(iOS 27.1, *) {
      self.modifier(DuoIllustrationRevealModifier())
    } else {
      self
    }
  }
}
#endif
