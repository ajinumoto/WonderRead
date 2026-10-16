import Foundation

enum StoryGenerationError: LocalizedError {
  case localModelUnavailable(String)
  case localGenerationFailed(String)
  case imageGenerationUnavailable(String)
  case invalidResponse
  case requestFailed(String)
  case archiveFailed
  case alreadyGenerating

  var errorDescription: String? {
    switch self {
    case .localModelUnavailable(let reason):
      String(localized: "On-device AI isn't ready. \(reason)", comment: "Localized app copy.")
    case .localGenerationFailed(let reason):
      String(localized: "On-device AI couldn't create the story. \(reason)", comment: "Localized app copy.")
    case .imageGenerationUnavailable(let reason):
      String(localized: "AI couldn't create the illustration. \(reason)", comment: "Localized app copy.")
    case .invalidResponse:
      String(localized: "AI returned a response that couldn't be read. Please try again.", comment: "Localized app copy.")
    case .requestFailed(let message):
      message
    case .archiveFailed:
      String(localized: "The story was created but couldn't be saved on this device.", comment: "Localized app copy.")
    case .alreadyGenerating:
      String(localized: "A story is already being created. Please wait a moment.", comment: "Localized app copy.")
    }
  }
}
