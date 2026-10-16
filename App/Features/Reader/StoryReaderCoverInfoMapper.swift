import Foundation

enum StoryReaderCoverInfoMapper {
  static func make(source: StoryReaderSource, libraryChapters: [StoryChapter]) -> ReaderCoverInfo? {
    switch source {
    case .collection(let collection): return collectionCoverInfo(collection)
    case .library: return libraryCoverInfo(libraryChapters.first)
    }
  }

  private static func collectionCoverInfo(_ collection: StoryCollection) -> ReaderCoverInfo {
    let firstChapter = collection.chapters.first
    return ReaderCoverInfo(
      seriesBadge: collection.badge,
      collectionTitle: collection.title,
      chapterTitle: firstChapter?.title ?? collection.title,
      chapterSummary: collection.description.isEmpty ? (firstChapter?.summary ?? "") : collection.description,
      chapterNumber: firstChapter?.number,
      chapter: firstChapter,
      coverImageURL: collection.coverImageURL
    )
  }

  private static func libraryCoverInfo(_ chapter: StoryChapter?) -> ReaderCoverInfo? {
    guard let chapter else { return nil }
    return ReaderCoverInfo(
      seriesBadge: nil,
      collectionTitle: chapter.seriesTitle.isEmpty ? String(localized: "WonderRead Adventure", comment: "Localized app copy.") : chapter.seriesTitle,
      chapterTitle: chapter.title,
      chapterSummary: chapter.summary,
      chapterNumber: chapter.number,
      chapter: chapter,
      coverImageURL: chapter.illustrationFilename
    )
  }
}
