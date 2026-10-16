import Foundation

enum GeminiStoryService {
  static func fetchModels(apiKey: String) async throws -> [StoryGeminiModel] {
    try await GeminiModelCatalogService.fetchModels(apiKey: apiKey)
  }

  static func generateStory(for request: StoryGenerationRequest, options: StoryGenerationOptions) async throws -> StoryDraft {
    try await GeminiStoryGenerationService.generate(for: request, options: options)
  }

  static func generateIllustration(for draft: StoryDraft, apiKey: String) async throws -> Data {
    try await GeminiIllustrationService.generate(for: draft, apiKey: apiKey)
  }
}
