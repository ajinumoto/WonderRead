import SwiftUI

enum StoryPalette {
  static let accent = Color.accentColor
  static let forest = Color.accentColor
  static let deepForest = Color(red: 0.145, green: 0.263, blue: 0.224)
  static let gold = Color(red: 0.894, green: 0.741, blue: 0.471)
  static let clay = Color(red: 0.741, green: 0.475, blue: 0.365)

  static func page(for colorScheme: ColorScheme) -> Color {
    colorScheme == .dark
      ? Color(red: 0.075, green: 0.075, blue: 0.075)
      : Color(red: 0.965, green: 0.953, blue: 0.925)
  }

  static func surface(for colorScheme: ColorScheme) -> Color {
    colorScheme == .dark
      ? Color(red: 0.125, green: 0.125, blue: 0.125)
      : Color(red: 0.995, green: 0.989, blue: 0.969)
  }

  static func line(for colorScheme: ColorScheme) -> Color {
    colorScheme == .dark ? .white.opacity(0.10) : deepForest.opacity(0.12)
  }

  static func imagePlaceholder(for colorScheme: ColorScheme) -> Color {
    colorScheme == .dark
      ? Color(red: 0.16, green: 0.16, blue: 0.16)
      : Color(red: 0.88, green: 0.87, blue: 0.84)
  }
}
