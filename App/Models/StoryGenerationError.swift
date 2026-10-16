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
      String(localized: "On-device AI isn't ready. \(reason)")
    case .localGenerationFailed(let reason):
      String(localized: "On-device AI couldn't create the story. \(reason)")
    case .imageGenerationUnavailable(let reason):
      String(localized: "AI couldn't create the illustration. \(reason)")
    case .invalidResponse:
      String(localized: "AI returned a response that couldn't be read. Please try again.")
    case .requestFailed(let message):
      message
    case .archiveFailed:
      String(localized: "The story was created but couldn't be saved on this device.")
    case .alreadyGenerating:
      String(localized: "A story is already being created. Please wait a moment.")
    }
  }

  var recoverySuggestion: String? {
    switch self {
    case .localModelUnavailable:
      String(localized: "Switch to Google Gemini in Settings or ensure on-device model assets are fully downloaded.")
    case .localGenerationFailed:
      String(localized: "Try selecting different story preferences or generating again.")
    case .imageGenerationUnavailable:
      String(localized: "The story text was preserved. You can read the story with generated illustrations.")
    case .invalidResponse:
      String(localized: "Check your internet connection or try generating with a shorter prompt.")
    case .requestFailed:
      String(localized: "Verify your API key in Settings and check your network connection.")
    case .archiveFailed:
      String(localized: "Ensure sufficient device storage space is available and try again.")
    case .alreadyGenerating:
      String(localized: "Please wait until the current story finishes generating before creating another.")
    }
  }
}
