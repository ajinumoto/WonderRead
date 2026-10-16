import Foundation

enum GeminiOperation {
  case story
  case illustration
  case models

  var localizedTitle: String {
    switch self {
    case .story: String(localized: "story", comment: "Localized app copy.")
    case .illustration: String(localized: "illustration", comment: "Localized app copy.")
    case .models: String(localized: "model list", comment: "Localized app copy.")
    }
  }
}
