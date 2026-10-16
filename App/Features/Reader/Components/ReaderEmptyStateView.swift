import SwiftUI

// MARK: - Reusable Reader Background

struct ReaderEmptyStateView: View {
  var body: some View {
    ContentUnavailableView(
      String(localized: "No story available", comment: "Localized app copy."),
      systemImage: "book.closed",
      description: Text(String(localized: "Create your first story from the home screen.", comment: "Localized app copy."))
    )
  }
}
