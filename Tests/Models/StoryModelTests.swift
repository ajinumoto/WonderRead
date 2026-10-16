import Foundation
import Testing
@testable import WonderRead

struct StoryLanguageTests {
  @Test(arguments: [
    LanguageCase(code: nil, expected: .english),
    LanguageCase(code: "  ", expected: .english),
    LanguageCase(code: "id", expected: .indonesian),
    LanguageCase(code: " ID-id ", expected: .indonesian),
    LanguageCase(code: "en-US", expected: .english),
    LanguageCase(code: "fr", expected: .english)
  ])
  func mapsLanguageCodes(_ input: LanguageCase) {
    #expect(StoryLanguage.from(code: input.code) == input.expected)
  }

  @Test func exposesStableIdentifiers() {
    #expect(StoryLanguage.indonesian.identifier == "id")
    #expect(StoryLanguage.english.identifier == "en")
  }
}

struct LanguageCase: Sendable, CustomTestStringConvertible {
  var code: String?
  var expected: StoryLanguage
  var testDescription: String { "\(code ?? "nil") maps to \(expected.rawValue)" }
}

struct StoryChapterTests {
  @Test func explicitCuratedSourceWinsForLocalArtwork() {
    let chapter = StoryFixtures.chapter(source: .curated)
    #expect(chapter.isCurated)
    #expect(chapter.isRemoteIllustration == false)
    #expect(chapter.isFinalCuratedChapter == false)
  }

  @Test(arguments: ["http://example.test/a.png", "https://example.test/a.png"])
  func recognizesLegacyRemoteIllustrations(_ url: String) {
    let chapter = StoryFixtures.chapter(illustrationFilename: url, source: nil)
    #expect(chapter.isRemoteIllustration)
    #expect(chapter.isCurated)
  }

  @Test func finalMarkerRequiresCuratedChapter() {
    let curated = StoryFixtures.chapter(source: .curated, isFinalInCollection: true)
    let generated = StoryFixtures.chapter(source: .generated, isFinalInCollection: true)
    #expect(curated.isFinalCuratedChapter)
    #expect(generated.isFinalCuratedChapter == false)
  }
}

struct StoryDraftCodableTests {
  @Test func decodingFillsMissingFieldsAndUsesSeriesTitle() throws {
    let data = Data(#"{"seriesTitle":"Moon Garden","paragraphs":["Once."]}"#.utf8)
    let draft = try JSONDecoder().decode(StoryDraft.self, from: data)
    #expect(draft.chapterTitle == "Moon Garden")
    #expect(draft.seriesTitle == "Moon Garden")
    #expect(draft.summary.isEmpty)
    #expect(draft.illustrationPrompt.isEmpty)
  }

  @Test func encodingRoundTripsEveryField() throws {
    let original = StoryDraft(seriesTitle: "Series", chapterTitle: "Chapter", summary: "Summary", paragraphs: ["One"], illustrationPrompt: "Scene")
    let data = try JSONEncoder().encode(original)
    let decoded = try JSONDecoder().decode(StoryDraft.self, from: data)
    #expect(decoded.seriesTitle == original.seriesTitle)
    #expect(decoded.paragraphs == original.paragraphs)
    #expect(decoded.illustrationPrompt == original.illustrationPrompt)
  }
}

struct StoryCollectionTests {
  @Test(arguments: [
    LanguageCase(code: "id-ID", expected: .indonesian),
    LanguageCase(code: "en-GB", expected: .english),
    LanguageCase(code: "unknown", expected: .english)
  ])
  func resolvesCollectionLanguage(_ input: LanguageCase) {
    let collection = StoryFixtures.collection(language: input.code ?? "")
    #expect(collection.storyLanguage == input.expected)
  }
}

struct StoryGeminiModelTests {
  @Test func usesDisplayNameOrNormalizedModelName() {
    let named = StoryGeminiModel(name: "models/gemini-test", baseModelId: nil, displayName: "Friendly name", outputTokenLimit: nil, supportedGenerationMethods: nil)
    let unnamed = StoryGeminiModel(name: "models/gemini-test", baseModelId: nil, displayName: nil, outputTokenLimit: nil, supportedGenerationMethods: nil)
    #expect(named.id == named.name)
    #expect(named.title == "Friendly name")
    #expect(unnamed.modelID == "models/gemini-test")
    #expect(unnamed.title == "gemini-test")
  }

  @Test func defaultCatalogContainsGenerationModels() {
    #expect(StoryGeminiModel.availableModels.allSatisfy { $0.supportedGenerationMethods?.contains("generateContent") == true })
    #expect(StoryGeminiModel.availableModels.contains { $0.name == StoryGeminiModel.defaultModelID })
  }
}

struct StoryPreferenceTests {
  @Test func unknownLabelsRemainReadable() {
    #expect(StoryPreferenceLabel.localized("New custom value") == "New custom value")
  }

  @Test func factorsPromptIncludesAllSelectedChoices() {
    let prompt = StoryFixtures.factors().promptDescription
    #expect(prompt.contains("Garden"))
    #expect(prompt.contains("Owl"))
    #expect(prompt.contains("Find a star"))
    #expect(prompt.contains("Lantern"))
    #expect(prompt.contains("Clear night"))
    #expect(prompt.contains("Help a friend"))
  }

  @Test func randomRollOnlySelectsKnownFactors() {
    let roll = StoryCombinators.randomRoll()
    #expect(StoryCombinators.settings.contains(roll.setting))
    #expect(StoryCombinators.companions.contains(roll.companion))
    #expect(StoryCombinators.missions.contains(roll.mission))
    #expect(StoryCombinators.magicItems.contains(roll.magicItem))
    #expect(StoryCombinators.weatherMoods.contains(roll.weatherMood))
    #expect(StoryCombinators.kindActions.contains(roll.kindAction))
  }
}

struct StoryGeminiLanguagesTests {
  @Test func languageCatalogIsUniqueSortedAndIncludesEnglish() {
    let languages = StoryGeminiLanguages.allLanguages()
    #expect(languages.contains("English"))
    #expect(Set(languages).count == languages.count)
    #expect(languages == languages.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending })
  }
}

@MainActor
struct StoryPreferencesStoreTests {
  @Test func suppliesExpectedProfileAndStoryDefaults() throws {
    let (suiteName, defaults) = try isolatedDefaults()
    defer { defaults.removePersistentDomain(forName: suiteName) }
    let store = StoryPreferencesStore(defaults: defaults)
    #expect(store.childAge == 6)
    #expect(store.storyStyle == "Hangat")
    #expect(store.storyTheme == "Petualangan")
    #expect(store.storyMoral == "Berani mencoba")
  }

  @Test func trimsProfileInputsBeforeStoryGeneration() throws {
    let (suiteName, defaults) = try isolatedDefaults()
    defer { defaults.removePersistentDomain(forName: suiteName) }
    let store = StoryPreferencesStore(defaults: defaults)
    store.nickname = "  Mira  "
    store.childAge = 8
    store.interests = "  stars  "
    #expect(store.storyPreferences.nickname == "Mira")
    #expect(store.storyPreferences.interests == "stars")
    #expect(defaults.integer(forKey: "profile.age") == 8)
  }

  @Test func persistsStoryPreferenceEdits() throws {
    let (suiteName, defaults) = try isolatedDefaults()
    defer { defaults.removePersistentDomain(forName: suiteName) }
    let store = StoryPreferencesStore(defaults: defaults)
    store.storyStyle = "Lucu"
    store.storyTheme = "Fantasi"
    store.storyMoral = "Rasa ingin tahu"
    #expect(store.storyPreferences.style == "Lucu")
    #expect(store.storyPreferences.theme == "Fantasi")
    #expect(store.storyPreferences.moral == "Rasa ingin tahu")
    #expect(defaults.string(forKey: "story.style") == "Lucu")
    #expect(defaults.string(forKey: "story.theme") == "Fantasi")
    #expect(defaults.string(forKey: "story.moral") == "Rasa ingin tahu")
  }

  @Test func restoresPreviouslySavedProfileValues() throws {
    let (suiteName, defaults) = try isolatedDefaults()
    defer { defaults.removePersistentDomain(forName: suiteName) }
    defaults.set("Nara", forKey: "profile.nickname")
    defaults.set(9, forKey: "profile.age")
    let store = StoryPreferencesStore(defaults: defaults)
    #expect(store.nickname == "Nara")
    #expect(store.childAge == 9)
  }

  private func isolatedDefaults() throws -> (String, UserDefaults) {
    let suiteName = "WonderReadTests.\(UUID().uuidString)"
    return (suiteName, try #require(UserDefaults(suiteName: suiteName)))
  }
}
