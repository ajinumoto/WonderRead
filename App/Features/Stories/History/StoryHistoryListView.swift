import SwiftUI

struct StoryHistoryListView: View {
  @Environment(StoryLibrary.self) private var storyLibrary
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.accessibilityReduceMotion) private var reduceMotion
  @State private var showingResetConfirmation = false

  var onSelectChapter: (UUID) -> Void

  private var chaptersNewestFirst: [StoryChapter] {
    storyLibrary.chapters.sorted { $0.generatedAt > $1.generatedAt }
  }

  var body: some View {
    Group {
      if chaptersNewestFirst.isEmpty { StoryHistoryEmptyState() }
      else { historyEntries }
    }
    .background(StoryPalette.page(for: colorScheme))
    .navigationTitle(String(localized: "History", comment: "Localized app copy."))
    #if os(iOS)
    .navigationBarTitleDisplayMode(.inline)
    #endif
    .toolbar { resetToolbar }
    .modifier(StoryHistoryResetDialog(isPresented: $showingResetConfirmation, onDeleteAll: resetAllChapters))
  }

  private var historyEntries: some View {
    StoryHistoryEntriesView(
      chapters: chaptersNewestFirst,
      onSelectChapter: onSelectChapter,
      onDelete: deleteChapters(at:)
    )
  }

  @ToolbarContentBuilder
  private var resetToolbar: some ToolbarContent {
    if !chaptersNewestFirst.isEmpty {
      ToolbarItem(placement: .automatic) {
        Button(role: .destructive) { showingResetConfirmation = true } label: {
          Label(String(localized: "Delete All", comment: "Localized app copy."), systemImage: "trash")
        }
      }
    }
  }

  private func resetAllChapters() {
    withAnimation(reduceMotion ? nil : .smooth) { storyLibrary.resetAllChapters() }
  }

  private func deleteChapters(at offsets: IndexSet) {
    for index in offsets {
      guard chaptersNewestFirst.indices.contains(index) else { continue }
      let chapter = chaptersNewestFirst[index]
      withAnimation(reduceMotion ? nil : .smooth) { storyLibrary.deleteChapter(id: chapter.id) }
    }
  }
}
