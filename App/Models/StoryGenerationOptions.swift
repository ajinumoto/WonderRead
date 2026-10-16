import Foundation

struct StoryGenerationOptions: Sendable {
  var provider: StoryAIProvider
  var geminiAPIKey: String?
  var geminiModel: String
  var outputTokenLimit: Int
  var language: String
}
