import Foundation
import Testing
@testable import WonderRead

struct SupabaseCollectionQueryTests {
  @Test func treatsMissingOrAllLanguageAsUnfiltered() {
    #expect(SupabaseCollectionQuery(language: nil).cacheKey == "all")
    #expect(SupabaseCollectionQuery(language: nil).language == nil)
    #expect(SupabaseCollectionQuery(language: "all").cacheKey == "all")
    #expect(SupabaseCollectionQuery(language: "all").language == nil)
  }

  @Test func preservesSpecificLanguageForRequestsAndCacheKeys() {
    let query = SupabaseCollectionQuery(language: "id")
    #expect(query.cacheKey == "id")
    #expect(query.language == "id")
    #expect(query.limit == 10)
    #expect(query.offset == 0)
  }

  @Test func respectsExplicitPaginationParameters() {
    let query = SupabaseCollectionQuery(language: "id", limit: 25, offset: 50)
    #expect(query.limit == 25)
    #expect(query.offset == 50)
  }
}

struct CollectionVersionDTOTests {
  @Test func defaultsMissingVersionToOne() {
    let item = CollectionVersionDTO(id: UUID(), version: nil, language: nil)
    #expect(item.effectiveVersion == 1)
  }

  @Test func preservesExplicitVersion() {
    let item = CollectionVersionDTO(id: UUID(), version: 12, language: "id")
    #expect(item.effectiveVersion == 12)
  }
}

struct SupabaseStoryDataMapperTests {
  @Test func mapsChapterFieldsAndParsesISODate() {
    let id = UUID()
    let dto = chapterDTO(id: id, number: 2, createdAt: "2024-01-02T03:04:05Z")
    let chapter = SupabaseStoryDataMapper.chapter(from: dto)
    #expect(chapter.id == id)
    #expect(chapter.number == 2)
    #expect(chapter.source == .curated)
    #expect(chapter.illustrationPrompt == "")
    #expect(chapter.generatedAt == ISO8601DateFormatter().date(from: "2024-01-02T03:04:05Z"))
  }

  @Test func mapsCollectionDefaultsAndFinalChapterFlags() {
    let chapters = [StoryFixtures.chapter(number: 1, source: .curated), StoryFixtures.chapter(number: 2, source: .curated)]
    let collection = SupabaseStoryDataMapper.collection(from: collectionDTO(), chapters: chapters)
    #expect(collection.subtitle.isEmpty)
    #expect(collection.language == "en")
    #expect(collection.version == 1)
    #expect(collection.chapters[0].isFinalInCollection == false)
    #expect(collection.chapters[1].isFinalCuratedChapter)
  }

  @Test func mapsNestedChaptersAndHandlesEmptyCollections() {
    let collection = SupabaseStoryDataMapper.collection(from: collectionDTO(chapters: [chapterDTO(number: 1)]))
    #expect(collection.chapters.count == 1)
    #expect(collection.chapters[0].isFinalCuratedChapter)
    #expect(SupabaseStoryDataMapper.markFinalChapters(in: [StoryFixtures.collection()]).first?.chapters.isEmpty == true)
  }

  @Test func marksOnlyTheLastChapterAcrossCollections() {
    let first = StoryFixtures.chapter(number: 1, isFinalInCollection: true)
    let last = StoryFixtures.chapter(number: 2, isFinalInCollection: false)
    let collection = StoryFixtures.collection(chapters: [first, last])
    let mapped = SupabaseStoryDataMapper.markFinalChapters(in: [collection])[0]
    #expect(mapped.chapters[0].isFinalInCollection == false)
    #expect(mapped.chapters[1].isFinalInCollection == true)
  }

  @Test func formatsRepoAlertMessages() {
    let confirmTitle = RepoAlertMessageMapper.confirmSwitchTitle()
    let confirmMsg = RepoAlertMessageMapper.confirmSwitchMessage(repoName: "Fairy Tales")
    let successTitle = RepoAlertMessageMapper.switchedSuccessTitle()
    let successMsg = RepoAlertMessageMapper.switchedSuccessMessage(repoName: "Fairy Tales")

    #expect(!confirmTitle.isEmpty)
    #expect(confirmMsg.contains("Fairy Tales"))
    #expect(!successTitle.isEmpty)
    #expect(successMsg.contains("Fairy Tales"))
  }
}

private func chapterDTO(id: UUID = UUID(), number: Int = 1, createdAt: String? = nil) -> SupabaseChapterDTO {
  SupabaseChapterDTO(
    id: id, collection_id: nil, number: number, series_title: "Moon Garden", title: "Star",
    summary: "A gentle adventure.", paragraphs: ["One", "Two", "Three."],
    illustration_prompt: nil, illustration_url: "https://example.test/star.png", created_at: createdAt
  )
}

private func collectionDTO(chapters: [SupabaseChapterDTO]? = nil) -> SupabaseCollectionDTO {
  SupabaseCollectionDTO(
    id: UUID(), slug: "moon-garden", title: "Moon Garden", subtitle: nil,
    description: "A little magic.", cover_image_url: "https://example.test/cover.png",
    badge: nil, language: nil, version: nil, story_chapters: chapters
  )
}

struct SupabaseConfigurationTests {
  @Test func acceptsHTTPAndHTTPSURLsWithKeys() {
    #expect(SupabaseConfiguration.isConfigured(projectURL: "https://database.example", anonKey: "public-key"))
    #expect(SupabaseConfiguration.isConfigured(projectURL: "http://localhost:54321", anonKey: "local-key"))
  }

  @Test func rejectsServiceRoleKeys() {
    let serviceRoleKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UifQ.mock_signature"
    #expect(SupabaseConfiguration.isServiceRoleKey(serviceRoleKey))
    #expect(SupabaseConfiguration.isConfigured(projectURL: "https://database.example", anonKey: serviceRoleKey) == false)
  }

  @Test(arguments: [
    ConfigurationCase(url: "", key: "key"),
    ConfigurationCase(url: "ftp://database.example", key: "key"),
    ConfigurationCase(url: "https://database.example", key: " "),
    ConfigurationCase(url: "httpx://database.example", key: "key"),
    ConfigurationCase(url: "http://database.example", key: "key")
  ])
  func rejectsIncompleteOrUnsupportedConfiguration(_ input: ConfigurationCase) {
    #expect(SupabaseConfiguration.isConfigured(projectURL: input.url, anonKey: input.key) == false)
  }
}

struct StoryRepositoryErrorTests {
  @Test func providesLocalizedDescriptionsAndRecoverySuggestions() {
    let unconfigured = StoryRepositoryError.unconfigured
    #expect(unconfigured.errorDescription?.contains("not configured") == true)
    #expect(unconfigured.recoverySuggestion?.contains("Settings") == true)

    let invalidResponse = StoryRepositoryError.invalidResponse(500)
    #expect(invalidResponse.errorDescription?.contains("500") == true)
    #expect(invalidResponse.recoverySuggestion != nil)
  }
}

struct ConfigurationCase: Sendable {
  var url: String
  var key: String
}
