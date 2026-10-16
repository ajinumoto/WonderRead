import CoreGraphics
import Testing
@testable import WonderRead

struct StoryIllustrationMotionMapperTests {
  @Test func mapsTallNarrowStripLayout() {
    let size = CGSize(width: 250, height: 600)
    let kind = StoryIllustrationMotionMapper.mapFrameKind(width: size.width, height: size.height)
    let profile = StoryIllustrationMotionMapper.motionProfile(for: size)

    #expect(kind == .tallStrip)
    #expect(profile.kind == .tallStrip)
    #expect(profile.targetOffsetY == 8.0)
    #expect(profile.targetOffsetX == 0.0)
    #expect(profile.baseScale == 1.04)
    #expect(profile.targetScale == 1.07)
  }

  @Test func mapsWideTopBannerLayout() {
    let size = CGSize(width: 800, height: 300)
    let kind = StoryIllustrationMotionMapper.mapFrameKind(width: size.width, height: size.height)
    let profile = StoryIllustrationMotionMapper.motionProfile(for: size)

    #expect(kind == .wideBanner)
    #expect(profile.kind == .wideBanner)
    #expect(profile.targetOffsetX == 10.0)
    #expect(profile.targetOffsetY == 0.0)
    #expect(profile.baseScale == 1.04)
    #expect(profile.targetScale == 1.07)
  }

  @Test func mapsFullPageSpreadLayout() {
    let size = CGSize(width: 600, height: 750)
    let kind = StoryIllustrationMotionMapper.mapFrameKind(width: size.width, height: size.height)
    let profile = StoryIllustrationMotionMapper.motionProfile(for: size)

    #expect(kind == .fullSpread)
    #expect(profile.kind == .fullSpread)
    #expect(profile.targetOffsetX == 5.0)
    #expect(profile.targetOffsetY == 4.0)
    #expect(profile.baseScale == 1.03)
  }

  @Test func mapsCoverArtworkProfile() {
    let size = CGSize(width: 600, height: 750)
    let profile = StoryIllustrationMotionMapper.motionProfile(for: size, isCover: true)

    #expect(profile.targetOffsetX == 0.0)
    #expect(profile.targetOffsetY == 0.0)
    #expect(profile.baseScale == 1.02)
    #expect(profile.targetScale == 1.045)
  }
}
