import Foundation
import Testing
@testable import WonderRead

struct AppOnboardingTests {
  @Test func defaultStoryLanguageIsEnglish() {
    #expect(StoryGeminiLanguages.defaultLanguage == "English")
    let defaultCode = StoryLanguage.english.identifier
    #expect(defaultCode == "en")
  }

  @Test func onboardingActionTitlesAreNotEmpty() {
    let explore = AppOnboardingAction.exploreCuratedStories
    #expect(!explore.title.isEmpty)
    #expect(!explore.accessibilityHint.isEmpty)

    let done = AppOnboardingAction.done
    #expect(!done.title.isEmpty)
    #expect(!done.accessibilityHint.isEmpty)
  }

  @Test func storyLanguageMappingSupportsExpectedLanguages() {
    #expect(StoryLanguage.from(code: "en") == .english)
    #expect(StoryLanguage.from(code: "id") == .indonesian)
    #expect(StoryLanguage.from(code: "invalid") == .english)
  }

  @Test func onboardingDataMapperProvidesPrivacyItems() {
    let items = AppOnboardingDataMapper.privacyItems()
    #expect(items.count == 3)
    #expect(items.map(\.id) == ["on-device-storage", "no-tracking", "family-safe"])
    for item in items {
      #expect(!item.title.isEmpty)
      #expect(!item.detail.isEmpty)
      #expect(!item.icon.isEmpty)
    }
  }

  @Test func onboardingDataMapperProvidesWelcomeCopy() {
    #expect(!AppOnboardingDataMapper.welcomeHeadline().isEmpty)
    #expect(!AppOnboardingDataMapper.welcomeSubheadline().isEmpty)
    #expect(!AppOnboardingDataMapper.curatedStoriesFeatureTitle().isEmpty)
    #expect(!AppOnboardingDataMapper.curatedStoriesFeatureDetail().isEmpty)
  }
}
