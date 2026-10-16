import SwiftUI

struct ShelfSecondaryPane: View {
  @AppStorage("supabase.preferredLanguage") private var selectedLanguage = "en"
  @Environment(CuratedReadingTracker.self) private var tracker
  @State private var cachedCollections: [StoryCollection] = []

  var refreshID: UUID = UUID()
  var isTwoPanes: Bool = false
  var portraitHeight: CGFloat = 360
  var onOpenCollection: (StoryCollection) -> Void
  var onOpenCuratedChapter: (StoryCollection, UUID) -> Void

  private var selection: ShelfSecondaryPaneSelection {
    ShelfSecondaryPaneSelectionMapper.selection(lastRead: tracker.lastRead, collections: cachedCollections)
  }

  var body: some View {
    ShelfSecondaryPaneContent(
      selection: selection,
      onOpenCollection: onOpenCollection,
      onOpenCuratedChapter: onOpenCuratedChapter
    )
    .frame(maxWidth: .infinity)
    .frame(height: isTwoPanes ? nil : portraitHeight)
    .frame(maxHeight: isTwoPanes ? .infinity : nil)
    .task(id: refreshID) { await loadCachedCollections() }
  }

  private func loadCachedCollections() async {
    if let cached = await loadCollections(language: selectedLanguage) { cachedCollections = cached }
    else if let cached = await loadCollections(language: "all") { cachedCollections = cached }
  }

  private func loadCollections(language: String) async -> [StoryCollection]? {
    guard let collections = await SupabaseStoryCache.shared.load(language: language), !collections.isEmpty else { return nil }
    return collections
  }
}
