import SwiftUI

struct CuratedCollectionsList: View {
  var collections: [StoryCollection]
  var isLoadingMore: Bool = false
  var hasMore: Bool = false
  var onSelectCollection: (StoryCollection) -> Void
  var onLoadMore: () -> Void = {}

  var body: some View {
    LazyVStack(spacing: 16) {
      cardsList
      CuratedCollectionLoadingFooterView(isLoading: isLoadingMore, hasMore: hasMore)
    }
  }

  private var cardsList: some View {
    ForEach(collections) { collection in
      CuratedCollectionCard(collection: collection) {
        onSelectCollection(collection)
      }
      .onAppear { checkLoadMore(for: collection) }
    }
  }

  private func checkLoadMore(for collection: StoryCollection) {
    if SupabaseCollectionPaginationMapper.shouldTriggerLoadMore(item: collection, in: collections) {
      onLoadMore()
    }
  }
}
