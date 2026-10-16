import Foundation

enum SupabaseStoryDataMapper {
  private static let iso8601Formatter: ISO8601DateFormatter = {
    ISO8601DateFormatter()
  }()

  static func chapter(from dto: SupabaseChapterDTO) -> StoryChapter {
    StoryChapter(
      id: dto.id,
      number: dto.number,
      seriesTitle: dto.series_title,
      title: dto.title,
      summary: dto.summary,
      paragraphs: dto.paragraphs,
      illustrationPrompt: dto.illustration_prompt ?? "",
      illustrationFilename: dto.illustration_url,
      generatedAt: generatedDate(from: dto.created_at),
      source: .curated
    )
  }

  static func collection(from dto: SupabaseCollectionDTO) -> StoryCollection {
    let chapters = (dto.story_chapters ?? []).map(chapter(from:))
    return collection(from: dto, chapters: chapters)
  }

  static func collection(from dto: SupabaseCollectionDTO, chapters: [StoryChapter]) -> StoryCollection {
    StoryCollection(
      id: dto.id,
      slug: dto.slug,
      title: dto.title,
      subtitle: dto.subtitle ?? "",
      description: dto.description,
      coverImageURL: dto.cover_image_url,
      badge: dto.badge,
      language: dto.language ?? "en",
      version: dto.version ?? 1,
      chapters: markFinalChapters(in: chapters)
    )
  }

  static func chapters(from dtos: [SupabaseChapterDTO]) -> [StoryChapter] {
    markFinalChapters(in: dtos.map(chapter(from:)))
  }

  static func collections(from dtos: [SupabaseCollectionDTO]) -> [StoryCollection] {
    dtos.map(collection(from:))
  }

  static func markFinalChapters(in collections: [StoryCollection]) -> [StoryCollection] {
    collections.map { markFinalChapter(in: $0) }
  }

  private static func markFinalChapter(in collection: StoryCollection) -> StoryCollection {
    var markedCollection = collection
    markedCollection.chapters = markFinalChapters(in: collection.chapters)
    return markedCollection
  }

  static func markFinalChapters(in chapters: [StoryChapter]) -> [StoryChapter] {
    guard let finalIndex = chapters.indices.last else { return chapters }
    return chapters.enumerated().map { index, chapter in
      var markedChapter = chapter
      markedChapter.isFinalInCollection = index == finalIndex
      return markedChapter
    }
  }

  private static func generatedDate(from value: String?) -> Date {
    guard let value, let date = iso8601Formatter.date(from: value) else { return .now }
    return date
  }
}
