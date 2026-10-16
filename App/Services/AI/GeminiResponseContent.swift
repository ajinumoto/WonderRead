import Foundation

struct GeminiResponseContent: Decodable {
  var parts: [GeminiPart]?
}
