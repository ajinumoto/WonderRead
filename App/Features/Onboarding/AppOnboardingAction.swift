import Foundation

enum AppOnboardingAction {
  case exploreCuratedStories
  case done

  var title: String {
    switch self {
    case .exploreCuratedStories: String(localized: "Explore curated stories", comment: "Primary action in app introduction.")
    case .done: String(localized: "Done", comment: "Closes the app introduction from Settings.")
    }
  }

  var accessibilityHint: String {
    switch self {
    case .exploreCuratedStories:
      String(localized: "Closes the introduction and opens the curated story shelf.", comment: "App introduction action hint.")
    case .done:
      String(localized: "Closes the introduction and returns to Settings.", comment: "Settings app introduction action hint.")
    }
  }
}
