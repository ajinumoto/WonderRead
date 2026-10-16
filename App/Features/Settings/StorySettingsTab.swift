import SwiftUI

enum StorySettingsTab: String, CaseIterable, Identifiable {
  case curatedLibrary = "curatedLibrary"
  case computationalLiterature = "computationalLiterature"

  var id: String { rawValue }

  var title: String {
    switch self {
    case .computationalLiterature: String(localized: "Computational Literature", comment: "Localized app copy.")
    case .curatedLibrary: String(localized: "Curated Library", comment: "Localized app copy.")
    }
  }

  var icon: String {
    switch self {
    case .computationalLiterature: "sparkles"
    case .curatedLibrary: "books.vertical.fill"
    }
  }
}
