import SwiftUI

public struct StoryIllustrationMotionModifier: ViewModifier {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion
  @State private var isAnimating = false

  var size: CGSize
  var isCover: Bool

  private var profile: StoryIllustrationMotionProfile {
    StoryIllustrationMotionMapper.motionProfile(for: size, isCover: isCover)
  }

  public func body(content: Content) -> some View {
    let currentScale = reduceMotion ? 1.0 : (isAnimating ? profile.targetScale : profile.baseScale)
    let currentOffsetX = reduceMotion ? 0.0 : (isAnimating ? profile.targetOffsetX : -profile.targetOffsetX)
    let currentOffsetY = reduceMotion ? 0.0 : (isAnimating ? profile.targetOffsetY : -profile.targetOffsetY)

    content
      .scaleEffect(currentScale)
      .offset(x: currentOffsetX, y: currentOffsetY)
      .onAppear(perform: startAnimation)
      .onChange(of: reduceMotion) { _, _ in updateAnimation() }
  }

  private func startAnimation() {
    guard !reduceMotion else { return }
    withAnimation(.easeInOut(duration: profile.duration).repeatForever(autoreverses: true)) {
      isAnimating = true
    }
  }

  private func updateAnimation() {
    if reduceMotion {
      stopAnimation()
    } else {
      startAnimation()
    }
  }

  private func stopAnimation() {
    var transaction = Transaction(animation: nil)
    transaction.disablesAnimations = true
    withTransaction(transaction) {
      isAnimating = false
    }
  }
}

public extension View {
  func storyIllustrationMotion(in size: CGSize, isCover: Bool = false) -> some View {
    modifier(StoryIllustrationMotionModifier(size: size, isCover: isCover))
  }
}
