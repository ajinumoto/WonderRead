import Foundation

struct StoryGeminiModel: Decodable, Identifiable, Hashable, Sendable {
  var name: String
  var baseModelId: String?
  var displayName: String?
  var outputTokenLimit: Int?
  var supportedGenerationMethods: [String]?

  static let defaultModelID = "models/gemini-3.8-flash"
  static let defaultIllustrationModelID = "gemini-3.1-flash-image"

  static var availableModels: [StoryGeminiModel] {
    [
      StoryGeminiModel(
        name: "models/gemini-3.8-flash",
        baseModelId: nil,
        displayName: String(localized: "Gemini 3.8 Flash (Default)"),
        outputTokenLimit: 65536,
        supportedGenerationMethods: ["generateContent"]
      ),
      StoryGeminiModel(
        name: "models/gemini-3.7-flash",
        baseModelId: nil,
        displayName: "Gemini 3.7 Flash",
        outputTokenLimit: 65536,
        supportedGenerationMethods: ["generateContent"]
      ),
      StoryGeminiModel(
        name: "models/gemini-3.6-flash",
        baseModelId: nil,
        displayName: "Gemini 3.6 Flash",
        outputTokenLimit: 65536,
        supportedGenerationMethods: ["generateContent"]
      ),
    ]
  }

  var id: String { name }
  var modelID: String { name }
  var title: String { displayName ?? name.replacingOccurrences(of: "models/", with: "") }
}
