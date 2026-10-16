import Foundation
import Testing
@testable import WonderRead

struct StoryGenerationOptionsMapperTests {
  @Test(arguments: [
    ProviderCase(rawValue: "local", expected: .local),
    ProviderCase(rawValue: "gemini", expected: .gemini),
    ProviderCase(rawValue: "unknown", expected: .local)
  ])
  func mapsProviderAndFallsBack(_ input: ProviderCase) {
    #expect(StoryGenerationOptionsMapper.provider(from: input.rawValue) == input.expected)
  }

  @Test func assemblesOptionsWithoutDroppingValues() {
    let options = StoryGenerationOptionsMapper.make(provider: .gemini, apiKey: "key", model: "model", outputTokenLimit: 1200, language: "English")
    #expect(options.provider == .gemini)
    #expect(options.geminiAPIKey == "key")
    #expect(options.geminiModel == "model")
    #expect(options.outputTokenLimit == 1200)
    #expect(options.language == "English")
  }
}

struct ProviderCase: Sendable {
  var rawValue: String
  var expected: StoryAIProvider
}

struct GeminiRequestMapperTests {
  @Test(arguments: [
    ModelCase(name: "gemini-2.5-flash", expectedLevel: nil, expectedBudget: 0),
    ModelCase(name: "models/gemini-3.1-flash", expectedLevel: "LOW", expectedBudget: nil),
    ModelCase(name: "custom-model", expectedLevel: nil, expectedBudget: nil)
  ])
  func createsStoryPayloadForModelFamily(_ input: ModelCase) {
    let payload = GeminiRequestMapper.storyPayload(
      request: StoryFixtures.request(),
      options: StoryGenerationOptions(provider: .gemini, geminiAPIKey: nil, geminiModel: input.name, outputTokenLimit: 800, language: "English"),
      maxOutputTokens: 900,
      recovery: false
    )
    #expect(payload.generationConfig.responseMimeType == "application/json")
    #expect(payload.generationConfig.maxOutputTokens == 900)
    #expect(payload.generationConfig.thinkingConfig?.thinkingLevel == input.expectedLevel)
    #expect(payload.generationConfig.thinkingConfig?.thinkingBudget == input.expectedBudget)
    #expect(payload.contents.first?.parts.first?.text?.contains("Mira") == true)
  }

  @Test func createsImageOnlyPayload() {
    let payload = GeminiRequestMapper.illustrationPayload(for: StoryDraft(chapterTitle: "Star Parade"))
    #expect(payload.generationConfig.responseModalities == ["IMAGE"])
    #expect(payload.generationConfig.imageConfig?.aspectRatio == "4:3")
    #expect(payload.contents.first?.parts.first?.text?.contains("Star Parade") == true)
  }
}

struct ModelCase: Sendable {
  var name: String
  var expectedLevel: String?
  var expectedBudget: Int?
}

struct GeminiModelCatalogMapperTests {
  @Test func buildsRequestWithOptionalPageToken() throws {
    let request = try GeminiModelCatalogMapper.request(apiKey: "test-key", pageToken: "next page")
    let url = try #require(request.url)
    let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
    #expect(request.value(forHTTPHeaderField: "x-goog-api-key") == "test-key")
    #expect(components.queryItems?.first(where: { $0.name == "pageSize" })?.value == "1000")
    #expect(components.queryItems?.first(where: { $0.name == "pageToken" })?.value == "next page")
  }

  @Test func filtersUnsupportedModelsAndSortsTitles() {
    let models = [model("zeta", "Zeta", ["generateContent"]), model("hidden", "Hidden", ["embedContent"]), model("alpha", "Alpha", nil)]
    let supported = GeminiModelCatalogMapper.generationModels(from: GeminiModelsResponse(models: models, nextPageToken: nil))
    #expect(GeminiModelCatalogMapper.sorted(supported).map(\.title) == ["Zeta"])
  }
}

private func model(_ name: String, _ title: String?, _ methods: [String]?) -> StoryGeminiModel {
  StoryGeminiModel(name: name, baseModelId: nil, displayName: title, outputTokenLimit: nil, supportedGenerationMethods: methods)
}

struct GeminiAPITransportTests {
  @Test func buildsAuthenticatedJSONPostRequest() throws {
    let payload = GeminiRequest(contents: [], generationConfig: GeminiGenerationConfig(maxOutputTokens: 500))
    let request = try GeminiAPITransport.request(model: "gemini-test", apiVersion: "v1beta", apiKey: "sample-key", payload: payload)
    #expect(request.url?.path == "/v1beta/models/gemini-test:generateContent")
    #expect(request.httpMethod == "POST")
    #expect(request.value(forHTTPHeaderField: "x-goog-api-key") == "sample-key")
    #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")
    let body = try #require(request.httpBody)
    let object = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])
    #expect(object["generationConfig"] != nil)
  }

  @Test func decodesSuccessfulPayloadAndRejectsInvalidJSON() throws {
    let data = Data(#"{"models":[],"nextPageToken":"next"}"#.utf8)
    let response = try GeminiAPIResponseValidator.decode(GeminiModelsResponse.self, from: data)
    #expect(response.models.isEmpty)
    #expect(response.nextPageToken == "next")
    expectInvalidResponse(GeminiModelsResponse.self, data: Data("{".utf8))
  }

  @Test func acceptsSuccessfulHTTPStatus() throws {
    let url = try #require(URL(string: "https://example.test"))
    let response = try #require(HTTPURLResponse(url: url, statusCode: 204, httpVersion: nil, headerFields: nil))
    #expect(throws: Never.self) { try GeminiAPIResponseValidator.validateSuccess(response, data: Data(), operation: .story) }
  }

  @Test func rejectsNonHTTPResponse() {
    let url = URL(string: "https://example.test") ?? URL(fileURLWithPath: "/")
    let response = URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    expectRequestFailure { try GeminiAPIResponseValidator.validateSuccess(response, data: Data(), operation: .models) }
  }

  @Test(arguments: [400, 401, 403, 404, 429, 503])
  func mapsHTTPFailuresWithServerDetail(_ status: Int) throws {
    let url = try #require(URL(string: "https://example.test"))
    let response = try #require(HTTPURLResponse(url: url, statusCode: status, httpVersion: nil, headerFields: nil))
    let data = Data(#"{"error":{"message":"server-detail-token"}}"#.utf8)
    do {
      try GeminiAPIResponseValidator.validateSuccess(response, data: data, operation: .illustration)
      Issue.record("Expected the unsuccessful status to throw.")
    } catch StoryGenerationError.requestFailed(let message) {
      #expect(message.contains("server-detail-token"))
      if status == 401 || status == 403 { #expect(message.contains(String(status))) }
    } catch {
      Issue.record("Unexpected error: \(error)")
    }
  }
}

private func expectInvalidResponse<Response: Decodable>(_ type: Response.Type, data: Data) {
  do {
    _ = try GeminiAPIResponseValidator.decode(type, from: data)
    Issue.record("Expected an invalid payload to be rejected.")
  } catch StoryGenerationError.invalidResponse {
  } catch {
    Issue.record("Unexpected error: \(error)")
  }
}

private func expectRequestFailure(_ action: () throws -> Void) {
  do {
    try action()
    Issue.record("Expected an invalid HTTP response to be rejected.")
  } catch StoryGenerationError.requestFailed {
  } catch {
    Issue.record("Unexpected error: \(error)")
  }
}

struct GeminiErrorMessageMapperTests {
  @Test func limitsUntrustedServerDetailLength() {
    let detail = String(repeating: "x", count: 400)
    let data = Data("{\"error\":{\"message\":\"\(detail)\"}}".utf8)
    let message = GeminiErrorMessageMapper.message(statusCode: 400, data: data, operation: .story)
    #expect(message.count < 400)
    #expect(message.contains(String(repeating: "x", count: 260)))
  }

  @Test func providesFallbackForMalformedServerError() {
    let message = GeminiErrorMessageMapper.message(statusCode: 503, data: Data("bad".utf8), operation: .models)
    #expect(message.contains("503"))
    #expect(message.isEmpty == false)
  }
}
