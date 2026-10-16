import SwiftUI

enum ReaderSwipeDirectionMapper {
  static func direction(for translation: CGSize, minimumDistance: CGFloat, dominance: CGFloat) -> Int? {
    let horizontal = translation.width
    guard abs(horizontal) > minimumDistance, abs(horizontal) > abs(translation.height) * dominance else { return nil }
    return horizontal < 0 ? 1 : -1
  }
}
