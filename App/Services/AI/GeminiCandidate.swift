import Foundation

struct GeminiCandidate: Decodable {
  var content: GeminiResponseContent?
  var finishReason: String?
}
