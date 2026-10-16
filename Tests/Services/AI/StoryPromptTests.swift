import Foundation
import Testing
@testable import WonderRead

struct StoryPromptMapperTests {
  @Test func trimsCustomInputsAndAppliesFallbacks() {
    let preferences = StoryPreferences(nickname: " ", age: 6, interests: " \n ", style: "Warm", theme: "Adventure", moral: "Kindness")
    let context = StoryPromptMapper.map(request: StoryFixtures.request(customIdea: "  Find a comet.  ", preferences: preferences), language: "", includesIllustrationPrompt: false, recovery: true)
    #expect(context.targetLanguage == "English")
    #expect(context.childName == String(localized: "main character"))
    #expect(context.childInterests == String(localized: "adventure and exploration"))
    #expect(context.ideaText == "Ide tambahan: Find a comet..")
    #expect(context.recovery)
    #expect(context.includesIllustrationPrompt == false)
  }

  @Test func preservesExplicitLanguageAndPreferences() {
    let context = StoryPromptMapper.map(request: StoryFixtures.request(), language: "Bahasa Indonesia", includesIllustrationPrompt: true, recovery: false)
    #expect(context.targetLanguage == "Bahasa Indonesia")
    #expect(context.childName == "Mira")
    #expect(context.childInterests == "stars")
    #expect(context.age == 7)
    #expect(context.factorsDescription.contains("Garden"))
  }
}

struct StoryPromptTemplateTests {
  @Test func rendersIllustrationAndRecoveryInstructionsWhenEnabled() {
    let context = StoryPromptMapper.map(request: StoryFixtures.request(), language: "English", includesIllustrationPrompt: true, recovery: true)
    let prompt = StoryPromptTemplate.render(context)
    #expect(prompt.contains("Mira"))
    #expect(prompt.contains("Catatan illustrationPrompt"))
    #expect(prompt.contains("Tulis ulang agar lebih ringkas"))
  }

  @Test func omitsOptionalIllustrationAndRecoveryInstructions() {
    let context = StoryPromptMapper.map(request: StoryFixtures.request(), language: "English", includesIllustrationPrompt: false, recovery: false)
    let prompt = StoryPromptBuilder.make(for: StoryFixtures.request(), language: "English", includesIllustrationPrompt: false)
    #expect(StoryPromptTemplate.render(context).contains("\"paragraphs\""))
    #expect(prompt.contains("JSON murni"))
    #expect(prompt.contains("\"illustrationPrompt\"") == false)
    #expect(prompt.contains("Tulis ulang agar lebih ringkas") == false)
  }
}

struct StoryIllustrationPromptTests {
  @Test func includesSceneAndStableCompositionGuidance() {
    let draft = StoryDraft(chapterTitle: "Star Parade", illustrationPrompt: "A fox follows lanterns.")
    let prompt = StoryIllustrationPrompt.make(for: draft)
    #expect(prompt.contains("Star Parade"))
    #expect(prompt.contains("A fox follows lanterns."))
    #expect(prompt.contains("inner 50% safe zone"))
    #expect(StoryIllustrationPrompt.aspectRatio == "4:3")
  }
}
