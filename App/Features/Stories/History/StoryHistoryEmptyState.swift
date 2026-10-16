import SwiftUI

struct StoryHistoryEmptyState: View {
  var body: some View {
    ContentUnavailableView(
      String(localized: "No stories yet", comment: "Localized app copy."),
      systemImage: "book.closed",
      description: Text(String(localized: "Stories you create will be saved here.", comment: "Localized app copy."))
    )
  }
}
