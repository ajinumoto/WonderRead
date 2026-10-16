import SwiftUI

struct AppOnboardingSheetModifier: ViewModifier {
  @Binding var isPresented: Bool
  let onDismiss: () -> Void

  func body(content: Content) -> some View {
    content.sheet(isPresented: $isPresented, onDismiss: onDismiss) {
      AppOnboardingView { isPresented = false }
      #if os(iOS)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
      #else
        .frame(minWidth: 520, minHeight: 600)
      #endif
    }
  }
}

extension View {
  func appOnboardingSheet(
    isPresented: Binding<Bool>,
    onDismiss: @escaping () -> Void
  ) -> some View {
    modifier(AppOnboardingSheetModifier(isPresented: isPresented, onDismiss: onDismiss))
  }
}
