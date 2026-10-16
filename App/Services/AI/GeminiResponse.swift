import Foundation

struct GeminiResponse: Decodable {
  var candidates: [GeminiCandidate]?
  var promptFeedback: GeminiPromptFeedback?
}
