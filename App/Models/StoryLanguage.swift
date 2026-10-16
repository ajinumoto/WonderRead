import Foundation

enum StoryLanguage: String, Equatable, CaseIterable, Codable, Sendable {
  case indonesian = "id"
  case english = "en"

  static var current: StoryLanguage {
    guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
      return .english
    }
    return from(code: preferredLanguage)
  }

  var identifier: String {
    rawValue
  }

  var displayName: String {
    switch self {
    case .indonesian: "Bahasa Indonesia"
    case .english: "English"
    }
  }

  var flagBadge: String {
    switch self {
    case .indonesian: "🇮🇩 ID"
    case .english: "🇬🇧 EN"
    }
  }

  static func from(code: String?) -> StoryLanguage {
    guard let code = code?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) else {
      return .english
    }
    return StoryLanguage(rawValue: code) ?? (code.hasPrefix("id") ? .indonesian : .english)
  }
}
