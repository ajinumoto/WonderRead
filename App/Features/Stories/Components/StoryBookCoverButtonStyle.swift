import SwiftUI

struct StoryBookCoverButtonStyle: ButtonStyle {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  func makeBody(configuration: Configuration) -> some View {
    let isPressed = configuration.isPressed && !reduceMotion
    configuration.label
      .scaleEffect(isPressed ? 0.975 : 1)
      .rotation3DEffect(.degrees(isPressed ? -3 : 0), axis: (x: 0, y: 1, z: 0), anchor: .leading, perspective: 0.72)
      .animation(reduceMotion ? nil : .spring(duration: 0.3, bounce: 0.2), value: configuration.isPressed)
  }
}
