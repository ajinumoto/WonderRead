import Foundation

struct GeminiErrorEnvelope: Decodable {
  var error: GeminiErrorDetail?
}
