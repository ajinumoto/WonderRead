import SwiftUI

// MARK: - Doodle Style

enum StoryDoodleStyle {
  case fullPage
  case thumbnail
}

// MARK: - Doodle Metrics

struct StoryDoodleMetrics {
  var minDimension: CGFloat
  var heroSize: CGFloat
  var satelliteSize: CGFloat

  static func fullPage(for size: CGSize) -> StoryDoodleMetrics {
    let minimum = min(size.width, size.height)
    let hero = max(56, minimum * 0.22)
    return StoryDoodleMetrics(minDimension: minimum, heroSize: hero, satelliteSize: hero * 0.38)
  }

  static func thumbnail(for size: CGSize) -> StoryDoodleMetrics {
    let minimum = min(size.width, size.height)
    let hero = max(28, minimum * 0.36)
    return StoryDoodleMetrics(minDimension: minimum, heroSize: hero, satelliteSize: hero * 0.38)
  }
}

// MARK: - Doodle Theme

enum StoryDoodleTheme: CaseIterable {
  case baby
  case fantasy
  case storybook
  case bedtime

  static func select(for chapter: StoryChapter) -> StoryDoodleTheme {
    let seed = chapter.id.uuidString.utf8.reduce(UInt(bitPattern: chapter.number)) { value, byte in
      (value &* 31) &+ UInt(byte)
    }
    return StoryDoodleTheme.allCases[Int(seed % UInt(allCases.count))]
  }

  var heroSymbol: String {
    switch self {
    case .baby: "teddybear.fill"
    case .fantasy: "wand.and.stars"
    case .storybook: "book.pages.fill"
    case .bedtime: "moon.stars.fill"
    }
  }

  var satelliteSymbols: [String] {
    switch self {
    case .baby:
      return ["balloon.2.fill", "bubbles.and.sparkles.fill", "heart.fill"]
    case .fantasy:
      return ["crown.fill", "sparkles", "star.fill"]
    case .storybook:
      return ["quote.bubble.fill", "scroll.fill", "bookmark.fill"]
    case .bedtime:
      return ["star.fill", "cloud.moon.fill", "sparkle"]
    }
  }

  var title: String {
    switch self {
    case .baby:
      String(localized: "Playful Care & Joy")
    case .fantasy:
      String(localized: "Wonder & Magic")
    case .storybook:
      String(localized: "Storybook Journey")
    case .bedtime:
      String(localized: "Starry Night & Dreams")
    }
  }

  func primaryColor(for colorScheme: ColorScheme) -> Color {
    switch self {
    case .baby:
      Color(red: 0.91, green: 0.49, blue: 0.56)
    case .fantasy:
      Color(red: 0.58, green: 0.46, blue: 0.85)
    case .storybook:
      StoryPalette.clay
    case .bedtime:
      Color(red: 0.35, green: 0.52, blue: 0.82)
    }
  }

  func secondaryColor(for colorScheme: ColorScheme) -> Color {
    switch self {
    case .baby:
      Color(red: 0.98, green: 0.74, blue: 0.45)
    case .fantasy:
      StoryPalette.gold
    case .storybook:
      StoryPalette.gold
    case .bedtime:
      StoryPalette.gold
    }
  }
}
