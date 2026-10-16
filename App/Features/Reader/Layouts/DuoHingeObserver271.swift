import SwiftUI

#if os(iOS)
@available(iOS 27.1, *)
struct DuoHingeObserver271: ViewModifier {
  @Binding var spineIntensity: Double
  var isEnabled: Bool
  @State private var progress = HingeProgress()

  func body(content: Content) -> some View {
    content
      .environment(progress)
      .onHingeChange(isEnabled: isEnabled) { _, newContext in
        progress.update(newContext.hinge)
        if progress.isPartial {
          withAnimation(.interactiveSpring(response: 0.25, dampingFraction: 0.86)) {
            spineIntensity = StoryLayout.spineShadowIntensity(for: progress.value)
          }
        } else {
          withAnimation(.smooth(duration: 0.2)) {
            spineIntensity = StoryLayout.spineShadowIntensity(for: progress.value)
          }
        }
      }
  }
}
#endif
