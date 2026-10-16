import Foundation

// MARK: - Story Repository Domain Error

enum StoryRepositoryError: LocalizedError, Sendable, Equatable {
  case unconfigured
  case invalidEndpoint(String)
  case networkFailure(String)
  case invalidResponse(Int)
  case decodingFailed(String)
  case unauthorized

  var errorDescription: String? {
    switch self {
    case .unconfigured:
      String(localized: "Story repository is not configured. Please check your Supabase credentials in Settings.")
    case .invalidEndpoint(let endpoint):
      String(localized: "The story repository endpoint is invalid: \(endpoint)")
    case .networkFailure(let message):
      String(localized: "Unable to connect to the story repository: \(message)")
    case .invalidResponse(let statusCode):
      String(localized: "The story repository responded with error code \(statusCode).")
    case .decodingFailed:
      String(localized: "Unable to read the story collection data from the repository.")
    case .unauthorized:
      String(localized: "Invalid API key or unauthorized access to the story repository.")
    }
  }

  var recoverySuggestion: String? {
    switch self {
    case .unconfigured:
      String(localized: "Open Settings > Story Repository and connect a valid repository URL and anonymous key.")
    case .invalidEndpoint:
      String(localized: "Verify the project URL scheme and domain in Settings.")
    case .networkFailure:
      String(localized: "Check your internet connection and try refreshing the shelf.")
    case .invalidResponse:
      String(localized: "Please try again later or check your Supabase service status.")
    case .decodingFailed:
      String(localized: "Ensure your repository tables match the required WonderRead schema.")
    case .unauthorized:
      String(localized: "Verify that the anonymous key has public read permissions in your Supabase project.")
    }
  }
}
