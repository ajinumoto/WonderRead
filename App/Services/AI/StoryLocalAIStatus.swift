import Foundation
import FoundationModels

enum StoryLocalAIStatus {
  case ready(languageName: String)
  case unsupportedOS
  case deviceNotEligible
  case appleIntelligenceNotEnabled
  case modelNotReady
  case unsupportedLanguage(languageName: String)
  case unavailable

  var canAttemptGeneration: Bool {
    if case .ready = self { return true }
    return false
  }

  var message: String {
    switch self {
    case .ready(let languageName):
      String(localized: "Apple Intelligence is ready. On-device stories will be written in \(languageName).", comment: "Localized app copy.")
    case .unsupportedOS:
      String(localized: "On-device AI requires iOS 26 or macOS 26 or later.", comment: "Localized app copy.")
    case .deviceNotEligible:
      String(localized: "This device isn't eligible for Apple Intelligence. Choose Gemini to create stories.", comment: "Localized app copy.")
    case .appleIntelligenceNotEnabled:
      String(localized: "Apple Intelligence is turned off. Enable it in Settings, then try again.", comment: "Localized app copy.")
    case .modelNotReady:
      String(localized: "Apple's language model isn't ready or is still downloading. Connect to Wi-Fi and power, then wait for the download to finish.", comment: "Localized app copy.")
    case .unsupportedLanguage(let languageName):
      String(localized: "Apple's model doesn't support \(languageName) for on-device stories. Choose Gemini to create stories.", comment: "Localized app copy.")
    case .unavailable:
      String(localized: "Apple Intelligence isn't available right now. Your profile and preferences are saved; choose Gemini to create stories.", comment: "Localized app copy.")
    }
  }

  static var current: StoryLocalAIStatus {
    guard #available(iOS 26.0, macOS 26.0, *) else {
      return .unsupportedOS
    }

    let languageName = StoryLanguage.current.displayName
    let model = SystemLanguageModel.default

    switch model.availability {
    case .available:
      guard model.supportsLocale(Locale(identifier: StoryLanguage.current.identifier)) else {
        return .unsupportedLanguage(languageName: languageName)
      }
      return .ready(languageName: languageName)
    case .unavailable(.appleIntelligenceNotEnabled):
      return .appleIntelligenceNotEnabled
    case .unavailable(.deviceNotEligible):
      return .deviceNotEligible
    case .unavailable(.modelNotReady):
      return .modelNotReady
    case .unavailable:
      return .unavailable
    }
  }
}
