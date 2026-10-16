import Foundation

struct GeminiGenerationConfig: Encodable {
  var responseModalities: [String]? = nil
  var responseMimeType: String? = nil
  var maxOutputTokens: Int? = nil
  var imageConfig: GeminiImageConfig? = nil
  var thinkingConfig: GeminiThinkingConfig? = nil
}
