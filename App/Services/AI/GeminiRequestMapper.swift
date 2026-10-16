import Foundation

enum GeminiRequestMapper {
  static func storyPayload(
    request: StoryGenerationRequest,
    options: StoryGenerationOptions,
    maxOutputTokens: Int,
    recovery: Bool
  ) -> GeminiRequest {
    let prompt = StoryPromptBuilder.make(for: request, language: options.language, includesIllustrationPrompt: true, recovery: recovery)
    let config = GeminiGenerationConfig(
      responseMimeType: "application/json",
      maxOutputTokens: maxOutputTokens,
      thinkingConfig: thinkingConfig(for: options.geminiModel)
    )
    return GeminiRequest(
      contents: [GeminiContent(parts: [GeminiPart(text: prompt)])],
      generationConfig: config,
      safetySettings: childSafetySettings
    )
  }

  static func illustrationPayload(for draft: StoryDraft) -> GeminiRequest {
    let prompt = StoryIllustrationPrompt.make(for: draft)
    let imageConfig = GeminiImageConfig(aspectRatio: StoryIllustrationPrompt.aspectRatio, imageSize: StoryIllustrationPrompt.imageSize)
    let config = GeminiGenerationConfig(responseModalities: ["IMAGE"], imageConfig: imageConfig)
    return GeminiRequest(
      contents: [GeminiContent(parts: [GeminiPart(text: prompt)])],
      generationConfig: config,
      safetySettings: childSafetySettings
    )
  }

  static var childSafetySettings: [GeminiSafetySetting] {
    [
      GeminiSafetySetting(category: "HARM_CATEGORY_HARASSMENT", threshold: "BLOCK_LOW_AND_ABOVE"),
      GeminiSafetySetting(category: "HARM_CATEGORY_HATE_SPEECH", threshold: "BLOCK_LOW_AND_ABOVE"),
      GeminiSafetySetting(category: "HARM_CATEGORY_SEXUALLY_EXPLICIT", threshold: "BLOCK_LOW_AND_ABOVE"),
      GeminiSafetySetting(category: "HARM_CATEGORY_DANGEROUS_CONTENT", threshold: "BLOCK_LOW_AND_ABOVE")
    ]
  }

  private static func thinkingConfig(for model: String) -> GeminiThinkingConfig? {
    if model.localizedCaseInsensitiveContains("gemini-2.5") { return GeminiThinkingConfig(thinkingBudget: 0) }
    if model.localizedCaseInsensitiveContains("gemini-3") { return GeminiThinkingConfig(thinkingLevel: "LOW") }
    return nil
  }
}
