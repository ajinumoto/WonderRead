import Foundation

enum GeminiAPITransport {
  static func send<Response: Decodable>(
    _ type: Response.Type,
    request: URLRequest,
    operation: GeminiOperation
  ) async throws -> Response {
    let data = try await responseData(for: request, operation: operation)
    return try GeminiAPIResponseValidator.decode(type, from: data)
  }

  static func responseData(for request: URLRequest, operation: GeminiOperation) async throws -> Data {
    let (data, response) = try await URLSession.shared.data(for: request)
    try GeminiAPIResponseValidator.validateSuccess(response, data: data, operation: operation)
    return data
  }

  static func request(model: String, apiVersion: String, apiKey: String, payload: GeminiRequest) throws -> URLRequest {
    let modelPath = model.hasPrefix("models/") ? model : "models/\(model)"
    guard let url = URL(string: "https://generativelanguage.googleapis.com/\(apiVersion)/\(modelPath):generateContent") else {
      throw StoryGenerationError.requestFailed(String(localized: "The Gemini service URL is invalid.", comment: "Localized app copy."))
    }
    return try postRequest(url: url, apiKey: apiKey, payload: payload)
  }

  private static func postRequest(url: URL, apiKey: String, payload: GeminiRequest) throws -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.timeoutInterval = 180
    request.setValue(apiKey, forHTTPHeaderField: "x-goog-api-key")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONEncoder().encode(payload)
    return request
  }

}

enum GeminiAPIResponseValidator {
  static func validateSuccess(_ response: URLResponse, data: Data, operation: GeminiOperation) throws {
    let httpResponse = try validatedHTTPResponse(response, operation: operation)
    guard (200..<300).contains(httpResponse.statusCode) else {
      throw StoryGenerationError.requestFailed(GeminiErrorMessageMapper.message(statusCode: httpResponse.statusCode, data: data, operation: operation))
    }
  }

  static func decode<Response: Decodable>(_ type: Response.Type, from data: Data) throws -> Response {
    guard let response = try? JSONDecoder().decode(type, from: data) else { throw StoryGenerationError.invalidResponse }
    return response
  }

  private static func validatedHTTPResponse(_ response: URLResponse, operation: GeminiOperation) throws -> HTTPURLResponse {
    guard let response = response as? HTTPURLResponse else {
      throw StoryGenerationError.requestFailed(String(localized: "Gemini returned an invalid response while loading the \(operation.localizedTitle).", comment: "Localized app copy."))
    }
    return response
  }
}
