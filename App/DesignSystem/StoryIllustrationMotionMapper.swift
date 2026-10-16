import CoreGraphics

public enum StoryIllustrationMotionMapper {
  public static func mapFrameKind(width: CGFloat, height: CGFloat) -> StoryIllustrationFrameKind {
    let safeHeight = max(1.0, height)
    let ratio = width / safeHeight
    if ratio < 0.65 {
      return .tallStrip
    }
    if ratio > 1.35 {
      return .wideBanner
    }
    return .fullSpread
  }

  public static func motionProfile(for size: CGSize, isCover: Bool = false) -> StoryIllustrationMotionProfile {
    if isCover {
      return coverProfile()
    }
    let kind = mapFrameKind(width: size.width, height: size.height)
    return profile(for: kind)
  }

  private static func coverProfile() -> StoryIllustrationMotionProfile {
    StoryIllustrationMotionProfile(
      kind: .fullSpread,
      baseScale: 1.02,
      targetScale: 1.045,
      targetOffsetX: 0.0,
      targetOffsetY: 0.0,
      duration: 12.0
    )
  }

  private static func profile(for kind: StoryIllustrationFrameKind) -> StoryIllustrationMotionProfile {
    switch kind {
    case .tallStrip:
      return StoryIllustrationMotionProfile(
        kind: .tallStrip,
        baseScale: 1.04,
        targetScale: 1.07,
        targetOffsetX: 0.0,
        targetOffsetY: 8.0,
        duration: 14.0
      )
    case .wideBanner:
      return StoryIllustrationMotionProfile(
        kind: .wideBanner,
        baseScale: 1.04,
        targetScale: 1.07,
        targetOffsetX: 10.0,
        targetOffsetY: 0.0,
        duration: 16.0
      )
    case .fullSpread:
      return StoryIllustrationMotionProfile(
        kind: .fullSpread,
        baseScale: 1.03,
        targetScale: 1.06,
        targetOffsetX: 5.0,
        targetOffsetY: 4.0,
        duration: 16.0
      )
    }
  }
}
