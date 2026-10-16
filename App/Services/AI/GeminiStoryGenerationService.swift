import Foundation

enum GeminiStoryGenerationService {
  static func generate(for request: StoryGenerationRequest, options: StoryGenerationOptions) async throws -> StoryDraft {
    let maximumTokens = options.outputTokenLimit > 0 ? options.outputTokenLimit : 8192
    let initialTokens = min(8192, maximumTokens)
    if let draft = try await initialDraft(request, options: options, initialTokens: initialTokens, maximumTokens: maximumTokens) { return draft }
    return try await recoveryDraft(request, options: options, maximumTokens: maximumTokens)
  }

  private static func initialDraft(
    _ request: StoryGenerationRequest,
    options: StoryGenerationOptions,
    initialTokens: Int,
    maximumTokens: Int
  ) async throws -> StoryDraft? {
    let response = try await requestStory(request, options: options, maxOutputTokens: initialTokens)
    let candidate = try checkedCandidate(in: response)
    if let draft = validatedDraft(from: candidate) { return draft }
    guard candidate.finishReason == "MAX_TOKENS", maximumTokens > initialTokens else { return nil }
    let expanded = try await requestStory(request, options: options, maxOutputTokens: maximumTokens)
    return validatedDraft(from: try checkedCandidate(in: expanded))
  }

  private static func recoveryDraft(
    _ request: StoryGenerationRequest,
    options: StoryGenerationOptions,
    maximumTokens: Int
  ) async throws -> StoryDraft {
    let response = try await requestStory(request, options: options, maxOutputTokens: maximumTokens, recovery: true)
    let candidate = try checkedCandidate(in: response)
    guard candidate.finishReason != "MAX_TOKENS", let draft = decodedStory(from: candidate) else { throw incompleteRecoveryError() }
    return try StoryDraftValidator.validate(draft)
  }

  private static func requestStory(
    _ request: StoryGenerationRequest,
    options: StoryGenerationOptions,
    maxOutputTokens: Int,
    recovery: Bool = false
  ) async throws -> GeminiResponse {
    let payload = GeminiRequestMapper.storyPayload(request: request, options: options, maxOutputTokens: maxOutputTokens, recovery: recovery)
    let urlRequest = try GeminiAPITransport.request(model: options.geminiModel, apiVersion: "v1beta", apiKey: options.geminiAPIKey ?? "", payload: payload)
    return try await GeminiAPITransport.send(GeminiResponse.self, request: urlRequest, operation: .story)
  }

  private static func checkedCandidate(in response: GeminiResponse) throws -> GeminiCandidate {
    try validatePrompt(response)
    guard let candidate = response.candidates?.first else { throw noStoryError() }
    try rejectSafetyBlocked(candidate)
    return candidate
  }

  private static func validatedDraft(from candidate: GeminiCandidate?) -> StoryDraft? {
    guard let candidate, candidate.finishReason != "MAX_TOKENS", let draft = decodedStory(from: candidate) else { return nil }
    return try? StoryDraftValidator.validate(draft)
  }

  private static func decodedStory(from candidate: GeminiCandidate) -> StoryDraft? {
    guard let text = candidate.content?.parts?.compactMap(\.text).joined() else { return nil }
    return StoryDraftValidator.decode(from: text)
  }

  private static func validatePrompt(_ response: GeminiResponse) throws {
    guard let reason = response.promptFeedback?.blockReason else { return }
    throw StoryGenerationError.requestFailed(String(localized: "Gemini couldn't create this story (\(reason)). Change the story idea and try again.", comment: "Localized app copy."))
  }

  private static func rejectSafetyBlocked(_ candidate: GeminiCandidate) throws {
    guard candidate.finishReason == "SAFETY" else { return }
    throw StoryGenerationError.requestFailed(String(localized: "Gemini held this story for a safety check. Change the story idea and try again.", comment: "Localized app copy."))
  }

  private static func noStoryError() -> StoryGenerationError {
    .requestFailed(String(localized: "Gemini returned no story.", comment: "Localized app copy."))
  }

  private static func incompleteRecoveryError() -> StoryGenerationError {
    .requestFailed(String(localized: "Gemini still couldn't finish the story after a recovery attempt. Try again or choose a model with a larger output limit.", comment: "Localized app copy."))
  }
}
