import Foundation
import Testing
@testable import WonderRead

struct StoryAIProviderTests {
  @Test func exposesStableProviderIdentifiersAndTitles() {
    #expect(StoryAIProvider.defaultProvider == .local)
    #expect(StoryAIProvider.local.id == "local")
    #expect(StoryAIProvider.local.title == "Di perangkat")
    #expect(StoryAIProvider.gemini.id == "gemini")
    #expect(StoryAIProvider.gemini.title == "Gemini")
  }
}

struct StoryLanguageDisplayTests {
  @Test func exposesLocalizedNamesAndBadges() {
    #expect(StoryLanguage.indonesian.displayName == "Bahasa Indonesia")
    #expect(StoryLanguage.indonesian.flagBadge == "🇮🇩 ID")
    #expect(StoryLanguage.english.displayName == "English")
    #expect(StoryLanguage.english.flagBadge == "🇬🇧 EN")
  }
}

struct StoryPreferenceLabelTests {
  @Test func mapsKnownStoredLabelsThroughTheLocalizationCatalog() {
    #expect(StoryPreferenceLabel.localized("Hangat") == String(localized: "Warm and comforting"))
    #expect(StoryPreferenceLabel.localized("Petualangan") == String(localized: "Adventure"))
    #expect(StoryPreferenceLabel.localized("Rasa ingin tahu") == String(localized: "Curiosity"))
  }
}

struct StoryGenerationErrorTests {
  @Test func preservesRequestFailureDetails() {
    #expect(StoryGenerationError.requestFailed("Server detail").errorDescription == "Server detail")
  }

  @Test func givesEveryGenerationFailureReadableCopy() {
    let errors: [StoryGenerationError] = [
      .localModelUnavailable("reason"), .localGenerationFailed("reason"),
      .imageGenerationUnavailable("reason"), .invalidResponse, .requestFailed("reason"),
      .archiveFailed, .alreadyGenerating
    ]
    #expect(errors.allSatisfy { $0.errorDescription?.isEmpty == false })
  }
}

struct StoryCollectionCodableTests {
  @Test func collectionAndNestedChaptersRoundTrip() throws {
    let chapter = StoryFixtures.chapter(source: .curated, isFinalInCollection: true)
    let collection = StoryFixtures.collection(chapters: [chapter])
    let data = try JSONEncoder().encode(collection)
    let restored = try JSONDecoder().decode(StoryCollection.self, from: data)
    #expect(restored == collection)
    #expect(restored.chapters.first?.isFinalCuratedChapter == true)
  }
}
