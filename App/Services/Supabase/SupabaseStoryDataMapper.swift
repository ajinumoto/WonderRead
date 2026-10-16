import Foundation

// MARK: - Idiomatic DTO Extensions

extension StoryChapter {
  init(dto: SupabaseChapterDTO) {
    let date: Date
    if let createdAt = dto.created_at, let parsed = ISO8601DateFormatter().date(from: createdAt) {
      date = parsed
    } else {
      date = .now
    }
    self.init(
      id: dto.id,
      number: dto.number,
      seriesTitle: dto.series_title,
      title: dto.title,
      summary: dto.summary,
      paragraphs: dto.paragraphs,
      illustrationPrompt: dto.illustration_prompt ?? "",
      illustrationFilename: dto.illustration_url,
      generatedAt: date,
      source: .curated
    )
  }
}

extension StoryCollection {
  init(dto: SupabaseCollectionDTO, chapters: [StoryChapter]? = nil) {
    let resolvedChapters = chapters ?? (dto.story_chapters ?? []).map(StoryChapter.init(dto:))
    self.init(
      id: dto.id,
      slug: dto.slug,
      title: dto.title,
      subtitle: dto.subtitle ?? "",
      description: dto.description,
      coverImageURL: dto.cover_image_url,
      badge: dto.badge,
      language: dto.language ?? "en",
      version: dto.version ?? 1,
      chapters: SupabaseStoryDataMapper.markFinalChapters(in: resolvedChapters)
    )
  }
}

// MARK: - Supabase Story Data Adapter

enum SupabaseStoryDataMapper {
  static func chapter(from dto: SupabaseChapterDTO) -> StoryChapter {
    StoryChapter(dto: dto)
  }

  static func collection(from dto: SupabaseCollectionDTO) -> StoryCollection {
    StoryCollection(dto: dto)
  }

  static func collection(from dto: SupabaseCollectionDTO, chapters: [StoryChapter]) -> StoryCollection {
    StoryCollection(dto: dto, chapters: chapters)
  }

  static func chapters(from dtos: [SupabaseChapterDTO]) -> [StoryChapter] {
    markFinalChapters(in: dtos.map(StoryChapter.init(dto:)))
  }

  static func collections(from dtos: [SupabaseCollectionDTO]) -> [StoryCollection] {
    dtos.map { StoryCollection(dto: $0) }
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
}
