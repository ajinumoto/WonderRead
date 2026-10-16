import Foundation

public enum StoryIllustrationFrameKind: Equatable, Sendable {
  case tallStrip
  case wideBanner
  case fullSpread
}

public struct StoryIllustrationMotionProfile: Equatable, Sendable {
  public var kind: StoryIllustrationFrameKind
  public var baseScale: Double
  public var targetScale: Double
  public var targetOffsetX: Double
  public var targetOffsetY: Double
  public var duration: Double

  public init(
    kind: StoryIllustrationFrameKind,
    baseScale: Double,
    targetScale: Double,
    targetOffsetX: Double,
    targetOffsetY: Double,
    duration: Double
  ) {
    self.kind = kind
    self.baseScale = baseScale
    self.targetScale = targetScale
    self.targetOffsetX = targetOffsetX
    self.targetOffsetY = targetOffsetY
    self.duration = duration
  }
}
