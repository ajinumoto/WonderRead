import Foundation

enum StoryDatabaseDataMapper {
  static func toEntity(collection: StoryCollection, orderIndex: Int = 0) -> StoryCollectionEntity {
    let entity = StoryCollectionEntity(
      id: collection.id,
      slug: collection.slug,
      title: collection.title,
      subtitle: collection.subtitle,
      summaryText: collection.description,
      coverImageURL: collection.coverImageURL,
      badge: collection.badge,
      language: collection.language,
      version: collection.version,
      orderIndex: orderIndex
    )
    entity.chapters = collection.chapters.map { toEntity(chapter: $0, collection: entity) }
    return entity
  }

  static func toDomain(entity: StoryCollectionEntity) -> StoryCollection {
    let sortedChapters = entity.chapters.sorted { $0.number < $1.number }
    return StoryCollection(
      id: entity.id,
      slug: entity.slug,
      title: entity.title,
      subtitle: entity.subtitle,
      description: entity.summaryText,
      coverImageURL: entity.coverImageURL,
      badge: entity.badge,
      language: entity.language,
      version: entity.version,
      chapters: sortedChapters.map(toDomain)
    )
  }

  static func toEntity(chapter: StoryChapter, collection: StoryCollectionEntity? = nil) -> StoryChapterEntity {
    StoryChapterEntity(
      id: chapter.id,
      number: chapter.number,
      seriesTitle: chapter.seriesTitle,
      title: chapter.title,
      summary: chapter.summary,
      paragraphs: chapter.paragraphs,
      illustrationPrompt: chapter.illustrationPrompt,
      illustrationFilename: chapter.illustrationFilename,
      generatedAt: chapter.generatedAt,
      sourceRawValue: chapter.source?.rawValue ?? StoryChapterSource.generated.rawValue,
      isFinalInCollection: chapter.isFinalInCollection,
      collection: collection
    )
  }

  static func toDomain(entity: StoryChapterEntity) -> StoryChapter {
    let source = StoryChapterSource(rawValue: entity.sourceRawValue)
    return StoryChapter(
      id: entity.id,
      number: entity.number,
      seriesTitle: entity.seriesTitle,
      title: entity.title,
      summary: entity.summary,
      paragraphs: entity.paragraphs,
      illustrationPrompt: entity.illustrationPrompt,
      illustrationFilename: entity.illustrationFilename,
      generatedAt: entity.generatedAt,
      source: source,
      isFinalInCollection: entity.isFinalInCollection
    )
  }

  static func toEntity(record: LastReadCuratedRecord) -> ReadingProgressEntity {
    ReadingProgressEntity(
      collectionID: record.collectionID,
      collectionSlug: record.collectionSlug,
      collectionTitle: record.collectionTitle,
      collectionCoverImageURL: record.collectionCoverImageURL,
      collectionBadge: record.collectionBadge,
      chapterID: record.chapterID,
      chapterNumber: record.chapterNumber,
      chapterTitle: record.chapterTitle,
      chapterSummary: record.chapterSummary,
      lastReadAt: record.lastReadAt
    )
  }

  static func toDomain(entity: ReadingProgressEntity) -> LastReadCuratedRecord {
    LastReadCuratedRecord(
      collectionID: entity.collectionID,
      collectionSlug: entity.collectionSlug,
      collectionTitle: entity.collectionTitle,
      collectionCoverImageURL: entity.collectionCoverImageURL,
      collectionBadge: entity.collectionBadge,
      chapterID: entity.chapterID,
      chapterNumber: entity.chapterNumber,
      chapterTitle: entity.chapterTitle,
      chapterSummary: entity.chapterSummary,
      lastReadAt: entity.lastReadAt
    )
  }
}
