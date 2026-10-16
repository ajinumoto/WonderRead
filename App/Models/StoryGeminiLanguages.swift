import Foundation

enum StoryGeminiLanguages {
  static let defaultLanguage = "English"

  static func allLanguages() -> [String] {
    let currentLocale = Locale.current
    let languageCodes = Locale.LanguageCode.isoLanguageCodes
    let languageNames = languageCodes.compactMap { code -> String? in
      currentLocale.localizedString(forLanguageCode: code.identifier)?.capitalized
    }
    var uniqueLanguages = Array(Set(languageNames)).sorted {
      $0.localizedCaseInsensitiveCompare($1) == .orderedAscending
    }
    if !uniqueLanguages.contains("English") {
      uniqueLanguages.insert("English", at: 0)
    }
    return uniqueLanguages
  }
}
