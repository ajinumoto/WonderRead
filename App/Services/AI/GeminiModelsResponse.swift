import Foundation

struct GeminiModelsResponse: Decodable {
  var models: [StoryGeminiModel]
  var nextPageToken: String?
}
