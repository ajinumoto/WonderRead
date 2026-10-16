import Foundation

enum ShelfSecondaryPaneSelection {
  case resume(record: LastReadCuratedRecord, collection: StoryCollection?)
  case featured(StoryCollection)
  case empty
}

enum ShelfSecondaryPaneSelectionMapper {
  static func selection(lastRead: LastReadCuratedRecord?, collections: [StoryCollection]) -> ShelfSecondaryPaneSelection {
    if let lastRead {
      let collection = collections.first { $0.id == lastRead.collectionID }
      return .resume(record: lastRead, collection: collection)
    }
    if let featured = collections.first { return .featured(featured) }
    return .empty
  }

  static func resumeTarget(record: LastReadCuratedRecord, collection: StoryCollection?) -> StoryCollection {
    collection ?? placeholderCollection(for: record)
  }

  private static func placeholderCollection(for record: LastReadCuratedRecord) -> StoryCollection {
    StoryCollection(
      id: record.collectionID,
      slug: record.collectionSlug,
      title: record.collectionTitle,
      subtitle: "",
      description: "",
      coverImageURL: record.collectionCoverImageURL,
      badge: record.collectionBadge,
      chapters: [placeholderChapter(for: record)]
    )
  }

  private static func placeholderChapter(for record: LastReadCuratedRecord) -> StoryChapter {
    StoryChapter(
      id: record.chapterID,
      number: record.chapterNumber,
      seriesTitle: record.collectionTitle,
      title: record.chapterTitle,
      summary: record.chapterSummary,
      paragraphs: [],
      illustrationPrompt: "",
      illustrationFilename: "",
      generatedAt: record.lastReadAt,
      source: .curated
    )
  }
}
