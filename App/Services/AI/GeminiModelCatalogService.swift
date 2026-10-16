import Foundation

enum GeminiModelCatalogService {
  static func fetchModels(apiKey: String) async throws -> [StoryGeminiModel] {
    var models: [StoryGeminiModel] = []
    var pageToken: String?
    repeat {
      let response = try await fetchModelsPage(apiKey: apiKey, pageToken: pageToken)
      models.append(contentsOf: GeminiModelCatalogMapper.generationModels(from: response))
      pageToken = response.nextPageToken
    } while pageToken != nil
    return GeminiModelCatalogMapper.sorted(models)
  }

  private static func fetchModelsPage(apiKey: String, pageToken: String?) async throws -> GeminiModelsResponse {
    let request = try GeminiModelCatalogMapper.request(apiKey: apiKey, pageToken: pageToken)
    return try await GeminiAPITransport.send(GeminiModelsResponse.self, request: request, operation: .models)
  }
}

enum GeminiModelCatalogMapper {
  static func request(apiKey: String, pageToken: String?) throws -> URLRequest {
    guard var components = URLComponents(string: "https://generativelanguage.googleapis.com/v1beta/models") else {
      throw StoryGenerationError.requestFailed(String(localized: "The Gemini URL is invalid.", comment: "Localized app copy."))
    }
    components.queryItems = [URLQueryItem(name: "pageSize", value: "1000")]
    if let pageToken { components.queryItems?.append(URLQueryItem(name: "pageToken", value: pageToken)) }
    guard let url = components.url else {
      throw StoryGenerationError.requestFailed(String(localized: "The Gemini model-list URL is invalid.", comment: "Localized app copy."))
    }
    var request = URLRequest(url: url)
    request.timeoutInterval = 45
    request.setValue(apiKey, forHTTPHeaderField: "x-goog-api-key")
    return request
  }

  static func generationModels(from response: GeminiModelsResponse) -> [StoryGeminiModel] {
    response.models.filter { $0.supportedGenerationMethods?.contains("generateContent") == true }
  }

  static func sorted(_ models: [StoryGeminiModel]) -> [StoryGeminiModel] {
    models.sorted { $0.title.localizedStandardCompare($1.title) == .orderedAscending }
  }
}
