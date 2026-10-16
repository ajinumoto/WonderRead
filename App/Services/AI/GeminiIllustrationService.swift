import Foundation

enum GeminiIllustrationService {
  static func generate(for draft: StoryDraft, apiKey: String) async throws -> Data {
    let payload = GeminiRequestMapper.illustrationPayload(for: draft)
    let request = try GeminiAPITransport.request(
      model: StoryGeminiModel.defaultIllustrationModelID,
      apiVersion: "v1beta",
      apiKey: apiKey,
      payload: payload
    )
    let response = try await GeminiAPITransport.send(GeminiResponse.self, request: request, operation: .illustration)
    guard let image = imageData(from: response) else { throw illustrationUnavailableError() }
    return image
  }

  private static func imageData(from response: GeminiResponse) -> Data? {
    response.candidates?.first?.content?.parts?
      .compactMap { part in
        guard let encoded = part.inlineData?.data else { return nil }
        return Data(base64Encoded: encoded)
      }
      .first
  }

  private static func illustrationUnavailableError() -> StoryGenerationError {
    .imageGenerationUnavailable(String(localized: "Gemini didn't return an illustration. The story is still saved.", comment: "Localized app copy."))
  }
}
