import SwiftUI

struct StoryHistoryResetDialog: ViewModifier {
  @Binding var isPresented: Bool
  var onDeleteAll: () -> Void

  func body(content: Content) -> some View {
    content.confirmationDialog(
      String(localized: "Delete All Stories?", comment: "Localized app copy."),
      isPresented: $isPresented,
      titleVisibility: .visible
    ) {
      Button(String(localized: "Delete All Stories", comment: "Localized app copy."), role: .destructive, action: onDeleteAll)
      Button(String(localized: "Cancel", comment: "Localized app copy."), role: .cancel) {}
    } message: {
      Text(String(localized: "All saved stories and illustrations will be deleted from your book. This action cannot be undone.", comment: "Localized app copy."))
    }
  }
}
