import SwiftUI

struct StoryHistoryEntriesView: View {
  @Environment(\.colorScheme) private var colorScheme
  var chapters: [StoryChapter]
  var onSelectChapter: (UUID) -> Void
  var onDelete: (IndexSet) -> Void

  var body: some View {
    List {
      ForEach(chapters) { chapter in
        historyButton(for: chapter)
      }
      .onDelete(perform: onDelete)
    }
    .scrollContentBackground(.hidden)
    #if os(iOS)
    .listStyle(.insetGrouped)
    #else
    .listStyle(.inset)
    #endif
  }

  private func historyButton(for chapter: StoryChapter) -> some View {
    Button { onSelectChapter(chapter.id) } label: { StoryHistoryRow(chapter: chapter) }
      .buttonStyle(.plain)
      .listRowBackground(StoryPalette.surface(for: colorScheme))
      .accessibilityHint(String(localized: "Opens this story", comment: "Localized app copy."))
  }
}
