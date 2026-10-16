import Foundation

enum StoryGenerator {
  static func generate(
    request: StoryGenerationRequest,
    options: StoryGenerationOptions
  ) async throws -> StoryDraft {
    switch options.provider {
    case .local:
      return try await LocalStoryGenerator.generate(for: request)
    case .gemini:
      return try await generateGeminiStory(request: request, options: options)
    }
  }

  private static func generateGeminiStory(request: StoryGenerationRequest, options: StoryGenerationOptions) async throws -> StoryDraft {
    try await GeminiStoryService.generateStory(for: request, options: options)
  }

  static func fetchGeminiModels(apiKey: String) async throws -> [StoryGeminiModel] {
    try await GeminiStoryService.fetchModels(apiKey: apiKey)
  }

  static func generateGeminiIllustration(for draft: StoryDraft, apiKey: String) async throws -> Data {
    try await GeminiStoryService.generateIllustration(for: draft, apiKey: apiKey)
  }
}
