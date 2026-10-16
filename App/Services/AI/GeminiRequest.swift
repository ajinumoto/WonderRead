import Foundation

struct GeminiSafetySetting: Encodable, Sendable {
  var category: String
  var threshold: String
}

struct GeminiRequest: Encodable {
  var contents: [GeminiContent]
  var generationConfig: GeminiGenerationConfig
  var safetySettings: [GeminiSafetySetting]? = nil
}
