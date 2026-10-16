import Foundation
import FoundationModels

enum LocalStoryGenerator {
  static func generate(for request: StoryGenerationRequest) async throws -> StoryDraft {
    try requireAvailableModel()
    let session = makeSession()
    do {
      return try await generateDraft(for: request, in: session)
    } catch is CancellationError {
      throw CancellationError()
    } catch let error as StoryGenerationError {
      throw error
    } catch {
      throw StoryGenerationError.localGenerationFailed(errorMessage(for: error))
    }
  }

  private static func requireAvailableModel() throws {
    let availability = StoryLocalAIStatus.current
    guard availability.canAttemptGeneration else {
      throw StoryGenerationError.localModelUnavailable(availability.message)
    }
  }

  private static func makeSession() -> LanguageModelSession {
    let language = StoryLanguage.current.displayName
    return LanguageModelSession(instructions: """
      You write gentle, complete, age-appropriate children's stories. Respond in \(language). Keep the ending warm and complete. Follow the supplied reader preferences naturally.
      """)
  }

  private static func generateDraft(
    for request: StoryGenerationRequest,
    in session: LanguageModelSession
  ) async throws -> StoryDraft {
    let prompt = StoryPromptBuilder.make(
      for: request,
      language: StoryLanguage.current.displayName,
      includesIllustrationPrompt: false
    )
    let response = try await session.respond(to: prompt, generating: LocalStoryDraft.self)
    return try StoryDraftValidator.validate(StoryDraft(response.content))
  }

  private static func errorMessage(for error: any Error) -> String {
    LocalStoryErrorMapper.message(for: error)
  }
}

@Generable
private struct LocalStoryDraft {
  @Guide(description: "A memorable series title in the requested language")
  var seriesTitle: String

  @Guide(description: "A short chapter title in the requested language")
  var chapterTitle: String

  @Guide(description: "A one-sentence summary in the requested language")
  var summary: String

  @Guide(description: "Exactly four complete story paragraphs in the requested language, with a satisfying ending")
  var paragraphs: [String]
}

private extension StoryDraft {
  init(_ draft: LocalStoryDraft) {
    self.init(
      seriesTitle: draft.seriesTitle,
      chapterTitle: draft.chapterTitle,
      summary: draft.summary,
      paragraphs: draft.paragraphs,
      illustrationPrompt: ""
    )
  }
}

enum LocalStoryErrorMapper {
  static func message(for error: any Error) -> String {
    let diagnostic = error as NSError
    if let code = sensitiveContentAnalysisCode(in: diagnostic) { return safetyServiceMessage(diagnostic, code: code) }
    if #available(iOS 27.0, macOS 27.0, *), let languageError = languageModelError(error) {
      return languageMessage(languageError, diagnostic: diagnostic)
    }
    if isFoundationModelError(error) { return foundationModelMessage(error, diagnostic: diagnostic) }
    return unavailableMessage(diagnostic)
  }

  @available(iOS 27.0, macOS 27.0, *)
  private static func languageModelError(_ error: any Error) -> LanguageModelError? {
    error as? LanguageModelError
  }

  private static func isFoundationModelError(_ error: any Error) -> Bool {
    guard #available(iOS 27.0, macOS 27.0, *) else { return false }
    return error is LanguageModelSession.Error || error is SystemLanguageModel.Error
  }

  @available(iOS 27.0, macOS 27.0, *)
  private static func languageMessage(_ error: LanguageModelError, diagnostic: NSError) -> String {
    switch error {
    case .guardrailViolation:
      return String(localized: "Apple's safety check couldn't complete this story. Change the story idea and try again.", comment: "Localized app copy.")
    case .unsupportedLanguageOrLocale:
      return String(localized: "Apple's model doesn't support this language for on-device stories. Choose Gemini to create stories.", comment: "Localized app copy.")
    case .refusal:
      return String(localized: "On-device AI couldn't create a story from this request. Change the story idea and try again.", comment: "Localized app copy.")
    default:
      return foundationModelMessage(error, diagnostic: diagnostic)
    }
  }

  private static func foundationModelMessage(_ error: any Error, diagnostic: NSError) -> String {
    String(localized: "Foundation Models failed (\(diagnostic.domain), code \(diagnostic.code)): \(error.localizedDescription)", comment: "Localized app copy.")
  }

  private static func unavailableMessage(_ error: NSError) -> String {
    String(localized: "On-device AI failed to create a story (\(error.domain), code \(error.code)). Check Apple Intelligence readiness and try again.", comment: "Localized app copy.")
  }

  private static func safetyServiceMessage(_ error: NSError, code: Int) -> String {
    String(localized: "Apple's built-in AI safety service failed (\(error.domain), code \(code)). The app follows this system check and can't bypass it. Make sure Apple Intelligence is enabled and its language model is ready, then try again.", comment: "Localized app copy.")
  }

  private static func sensitiveContentAnalysisCode(in error: NSError, depth: Int = 0) -> Int? {
    guard depth < 8 else { return nil }
    if error.domain.localizedCaseInsensitiveContains("sensitivecontentanalysisml") { return error.code }
    return nestedErrorCode(in: error, depth: depth)
  }

  private static func nestedErrorCode(in error: NSError, depth: Int) -> Int? {
    let nested = (error.userInfo[NSUnderlyingErrorKey] as? NSError).map { [$0] }
      ?? error.userInfo["NSMultipleUnderlyingErrorsKey"] as? [NSError]
      ?? []
    return nested.lazy.compactMap { sensitiveContentAnalysisCode(in: $0, depth: depth + 1) }.first
  }
}
