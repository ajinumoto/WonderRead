import SwiftUI

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
