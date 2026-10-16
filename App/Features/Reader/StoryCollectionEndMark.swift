import SwiftUI

struct StoryCollectionEndMark: View {
  var body: some View {
    Text(String(localized: "The End", comment: "Closing mark shown after the final curated story chapter."))
      .font(.system(.title2, design: .serif).italic())
      .foregroundStyle(.secondary)
      .frame(maxWidth: .infinity)
      .accessibilityAddTraits(.isHeader)
  }
}
