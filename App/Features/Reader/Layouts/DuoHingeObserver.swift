import SwiftUI

#if os(iOS)
struct DuoHingeObserver: ViewModifier {
  @Binding var spineIntensity: Double
  var isEnabled: Bool

  func body(content: Content) -> some View {
    if #available(iOS 27.1, *) {
      content.modifier(DuoHingeObserver271(spineIntensity: $spineIntensity, isEnabled: isEnabled))
    } else {
      content
    }
  }
}
#endif
