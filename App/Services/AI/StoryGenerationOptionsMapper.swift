import Foundation

enum StoryGenerationOptionsMapper {
  static func provider(from rawValue: String) -> StoryAIProvider {
    StoryAIProvider(rawValue: rawValue) ?? .local
  }

  static func make(
    provider: StoryAIProvider,
    apiKey: String?,
    model: String,
    outputTokenLimit: Int,
    language: String
  ) -> StoryGenerationOptions {
    StoryGenerationOptions(
      provider: provider,
      geminiAPIKey: apiKey,
      geminiModel: model,
      outputTokenLimit: outputTokenLimit,
      language: language
    )
  }
}
