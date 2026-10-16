import SwiftUI

struct ShelfSecondaryPaneContent: View {
  var selection: ShelfSecondaryPaneSelection
  var onOpenCollection: (StoryCollection) -> Void
  var onOpenCuratedChapter: (StoryCollection, UUID) -> Void

  var body: some View {
    Group {
      switch selection {
      case .resume(let record, let collection):
        resumeCover(record: record, collection: collection)
      case .featured(let collection):
        featuredCover(collection)
      case .empty:
        emptyCover
      }
    }
  }

  private func resumeCover(record: LastReadCuratedRecord, collection: StoryCollection?) -> some View {
    StoryBookCoverView(
      seriesBadge: collection?.badge ?? record.collectionBadge,
      collectionTitle: record.collectionTitle,
      coverImageURL: record.collectionCoverImageURL,
      onRead: { openLastRead(record: record, collection: collection) }
    )
  }

  private func featuredCover(_ collection: StoryCollection) -> some View {
    StoryBookCoverView(
      seriesBadge: collection.badge,
      collectionTitle: collection.title,
      chapter: collection.chapters.first,
      coverImageURL: collection.coverImageURL,
      onRead: { onOpenCollection(collection) }
    )
  }

  private var emptyCover: some View {
    StoryBookCoverView(
      seriesBadge: nil,
      collectionTitle: String(localized: "WonderRead Library", comment: "Localized app copy."),
      onRead: { openFeaturedIfAvailable() }
    )
  }

  private func openLastRead(record: LastReadCuratedRecord, collection: StoryCollection?) {
    let target = ShelfSecondaryPaneSelectionMapper.resumeTarget(record: record, collection: collection)
    onOpenCuratedChapter(target, record.chapterID)
  }

  private func openFeaturedIfAvailable() {
    guard case .featured(let collection) = selection else { return }
    onOpenCollection(collection)
  }
}
