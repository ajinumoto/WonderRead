import Foundation
@testable import WonderRead

enum StoryFixtures {
  static func chapter(
    id: UUID = UUID(),
    number: Int = 1,
    seriesTitle: String = "Moon Garden",
    title: String = "The Missing Star",
    summary: String = "A gentle adventure.",
    paragraphs: [String] = ["One.", "Two.", "Three."],
    illustrationFilename: String = "chapter.image",
    source: StoryChapterSource? = .generated,
    isFinalInCollection: Bool? = nil
  ) -> StoryChapter {
    StoryChapter(
      id: id, number: number, seriesTitle: seriesTitle, title: title, summary: summary,
      paragraphs: paragraphs, illustrationPrompt: "A moonlit garden.",
      illustrationFilename: illustrationFilename, generatedAt: Date(timeIntervalSince1970: 1_700_000_000),
      source: source, isFinalInCollection: isFinalInCollection
    )
  }

  static func collection(
    id: UUID = UUID(),
    slug: String = "moon-garden",
    title: String = "Moon Garden",
    chapters: [StoryChapter] = [],
    language: String = "en",
    version: Int = 1
  ) -> StoryCollection {
    StoryCollection(
      id: id, slug: slug, title: title, subtitle: "A collection", description: "A little magic.",
      coverImageURL: "https://example.test/cover.png", badge: "Featured",
      language: language, version: version, chapters: chapters
    )
  }

  static func preferences() -> StoryPreferences {
    StoryPreferences(nickname: "Mira", age: 7, interests: "stars", style: "Warm", theme: "Adventure", moral: "Kindness")
  }

  static func factors() -> SelectedStoryFactors {
    SelectedStoryFactors(setting: "Garden", companion: "Owl", mission: "Find a star", magicItem: "Lantern", weatherMood: "Clear night", kindAction: "Help a friend")
  }

  static func request(customIdea: String? = nil, preferences: StoryPreferences? = nil) -> StoryGenerationRequest {
    StoryGenerationRequest(preferences: preferences ?? self.preferences(), customIdea: customIdea, selectedFactors: factors())
  }

  static func curatedRecord(collectionID: UUID = UUID(), chapterID: UUID = UUID()) -> LastReadCuratedRecord {
    LastReadCuratedRecord(
      collectionID: collectionID, collectionSlug: "moon-garden", collectionTitle: "Moon Garden",
      collectionCoverImageURL: "https://example.test/cover.png", collectionBadge: "Featured",
      chapterID: chapterID, chapterNumber: 3, chapterTitle: "The Missing Star",
      chapterSummary: "A gentle adventure.", lastReadAt: Date(timeIntervalSince1970: 1_700_000_000)
    )
  }
}
