import Foundation

enum ReaderTextScaleMapper {
  static func scale(for step: Int) -> CGFloat {
    let boundedStep = min(max(step, 0), 4)
    return 0.85 + CGFloat(boundedStep) * 0.075
  }
}
