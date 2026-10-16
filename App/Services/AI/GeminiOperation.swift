import Foundation

enum GeminiOperation {
  case story
  case illustration
  case models

  var localizedTitle: String {
    switch self {
    case .story: String(localized: "story")
    case .illustration: String(localized: "illustration")
    case .models: String(localized: "model list")
    }
  }
}
