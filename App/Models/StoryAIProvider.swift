import Foundation

enum StoryAIProvider: String, CaseIterable, Equatable, Identifiable, Sendable {
  case local
  case gemini

  static let defaultProvider: StoryAIProvider = .local

  var id: String { rawValue }

  var title: String {
    switch self {
    case .local: "Di perangkat"
    case .gemini: "Gemini"
    }
  }
}
