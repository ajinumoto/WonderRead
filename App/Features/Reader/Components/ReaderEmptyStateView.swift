import SwiftUI

struct ReaderEmptyStateView: View {
  var body: some View {
    ContentUnavailableView(
      String(localized: "No story available"),
      systemImage: "book.closed",
      description: Text(String(localized: "Create your first story from the home screen."))
    )
  }
}
