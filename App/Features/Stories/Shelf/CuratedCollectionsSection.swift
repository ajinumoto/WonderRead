import SwiftUI

struct CuratedCollectionsSection: View {
  @AppStorage("supabase.preferredLanguage") private var selectedLanguage = "en"
  var dataSource: StoryCollectionsDataSource?
  var refreshID: UUID = UUID()
  var onSelectCollection: (StoryCollection) -> Void

  @State private var fallbackDataSource = StoryCollectionsDataSource()

  private var currentSource: StoryCollectionsDataSource {
    dataSource ?? fallbackDataSource
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 14) {
      CuratedCollectionsHeader(isLoading: currentSource.isLoading)
      description
      collectionContent
    }
    .task(id: "\(selectedLanguage)-\(refreshID)") { await loadInitial() }
  }

  private var description: some View {
    Text(String(localized: "A collection of legendary folklore and fables from the online library.", comment: "Localized app copy."))
      .font(.subheadline)
      .foregroundStyle(.secondary)
  }

  @ViewBuilder
  private var collectionContent: some View {
    if currentSource.collections.isEmpty && !currentSource.isLoading {
      CuratedCollectionsEmptyState()
    } else {
      CuratedCollectionsList(
        collections: currentSource.collections,
        isLoadingMore: currentSource.isLoadingMore,
        hasMore: currentSource.hasMore,
        onSelectCollection: onSelectCollection,
        onLoadMore: triggerLoadMore
      )
    }
  }

  private func loadInitial() async {
    await currentSource.loadInitial(language: selectedLanguage)
  }

  private func triggerLoadMore() {
    Task { @MainActor in
      await currentSource.loadMore(language: selectedLanguage)
    }
  }
}
