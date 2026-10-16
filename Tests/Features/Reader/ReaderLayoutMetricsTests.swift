import Foundation
import SwiftUI
import Testing
@testable import WonderRead

struct StoryLayoutTests {
  @Test(arguments: [
    HingeProgressCase(progress: 0, expectedIntensity: 2.5),
    HingeProgressCase(progress: 0.5, expectedIntensity: 1.75),
    HingeProgressCase(progress: 1, expectedIntensity: 1.0)
  ])
  func mapsHingeProgressToSpineIntensity(_ input: HingeProgressCase) {
    #expect(StoryLayout.spineShadowIntensity(for: input.progress) == input.expectedIntensity)
  }

  @Test func detectsWideLayoutAndDivisionAsTwoPaneLayouts() {
    #expect(StoryLayout.usesTwoPanes(size: CGSize(width: 700, height: 500), hasDivision: false))
    #expect(StoryLayout.usesTwoPanes(size: CGSize(width: 400, height: 800), hasDivision: true))
    #expect(StoryLayout.usesTwoPanes(size: CGSize(width: 699, height: 500), hasDivision: false) == false)
    #expect(StoryLayout.usesTwoPanes(size: CGSize(width: 500, height: 500), hasDivision: false) == false)
  }

  @Test func resolvesHingeOrientationFromDivisionBeforeOverallSize() {
    #expect(StoryLayout.hingeOrientation(size: CGSize(width: 900, height: 600), divisionFrame: nil) == .vertical)
    #expect(StoryLayout.hingeOrientation(size: CGSize(width: 600, height: 900), divisionFrame: nil) == .horizontal)
    #expect(StoryLayout.hingeOrientation(size: CGSize(width: 900, height: 600), divisionFrame: CGRect(x: 0, y: 400, width: 900, height: 20)) == .horizontal)
    #expect(StoryLayout.hingeOrientation(size: CGSize(width: 600, height: 900), divisionFrame: CGRect(x: 280, y: 0, width: 20, height: 900)) == .vertical)
  }
}

struct HingeProgressCase: Sendable {
  var progress: Double
  var expectedIntensity: Double
}

struct DuoReaderPoseMapperTests {
  @Test func resolvesOuterPoseByOrientation() {
    #expect(DuoReaderPoseMapper.resolve(size: CGSize(width: 800, height: 400), hasActiveDivision: false, hingeOrientation: .vertical) == .outerLandscape)
    #expect(DuoReaderPoseMapper.resolve(size: CGSize(width: 400, height: 800), hasActiveDivision: false, hingeOrientation: .horizontal) == .outerPortrait)
  }

  @Test func resolvesInnerPoseFromDivisionOrExpandedWindow() {
    #expect(DuoReaderPoseMapper.resolve(size: CGSize(width: 400, height: 600), hasActiveDivision: true, hingeOrientation: .horizontal) == .innerTable)
    #expect(DuoReaderPoseMapper.resolve(size: CGSize(width: 600, height: 600), hasActiveDivision: false, hingeOrientation: .vertical) == .innerBook)
    #expect(DuoReaderPoseMapper.resolve(size: CGSize(width: 549, height: 800), hasActiveDivision: false, hingeOrientation: .vertical) == .outerPortrait)
  }
}

struct DuoInnerBookWidthMapperTests {
  @Test func doublesDivisionMidXWhenPresent() {
    let width = DuoInnerBookWidthMapper.resolve(width: 867, divisionMidX: 475.5, isFullscreen: false)
    #expect(width == 951)
  }

  @Test func usesFallbackTrailingInsetWhenNotFullscreenAndNearDuoWidth() {
    let width = DuoInnerBookWidthMapper.resolve(width: 867, divisionMidX: nil, isFullscreen: false)
    #expect(width == 951)
  }

  @Test func preservesWidthWhenFullscreenOrOutsideRange() {
    let fullscreen = DuoInnerBookWidthMapper.resolve(width: 951, divisionMidX: nil, isFullscreen: true)
    #expect(fullscreen == 951)

    let standardPhone = DuoInnerBookWidthMapper.resolve(width: 393, divisionMidX: nil, isFullscreen: false)
    #expect(standardPhone == 393)
  }
}

struct ReaderDeviceCategoryTests {
  @Test func resolvesPlatformAndFormFactorWithMacPrecedence() {
    #expect(ReaderDeviceCategory.resolve(isMac: true, isPad: true, hasDivision: true) == .mac)
    #expect(ReaderDeviceCategory.resolve(isMac: false, isPad: true, hasDivision: true) == .ipad)
    #expect(ReaderDeviceCategory.resolve(isMac: false, isPad: false, hasDivision: true) == .iphoneDuo)
    #expect(ReaderDeviceCategory.resolve(isMac: false, isPad: false, hasDivision: false) == .iphone)
  }
}

struct ShelfTwoPaneMetricsMapperTests {
  @Test func usesPortraitFallbackAndActiveHingeMetrics() {
    let fallback = ShelfTwoPaneMetricsMapper.portrait(size: CGSize(width: 400, height: 800), divisionFrame: nil, activeDivisionFrame: nil)
    let frame = CGRect(x: 0, y: 390, width: 400, height: 40)
    let divided = ShelfTwoPaneMetricsMapper.portrait(size: CGSize(width: 400, height: 800), divisionFrame: frame, activeDivisionFrame: frame)
    #expect(fallback.contentExtent == 384)
    #expect(fallback.hingeGap == 0)
    #expect(divided.contentExtent == 390)
    #expect(divided.hingeGap == 40)
  }

  @Test func usesLandscapeFallbackAndHingeWidth() {
    let fallback = ShelfTwoPaneMetricsMapper.landscape(size: CGSize(width: 900, height: 400), divisionFrame: nil, activeDivisionFrame: nil)
    let frame = CGRect(x: 440, y: 0, width: 20, height: 400)
    let divided = ShelfTwoPaneMetricsMapper.landscape(size: CGSize(width: 900, height: 400), divisionFrame: frame, activeDivisionFrame: frame)
    #expect(fallback.contentExtent == 450)
    #expect(divided.contentExtent == 440)
    #expect(divided.hingeGap == 20)
  }
}

struct CurvedPageMetricsTests {
  @Test func calculatesAngleVisibilityAndSliceWidth() {
    let metrics = CurvedPageMetrics(isForward: true, progress: 0.5, halfWidth: 300)
    #expect(metrics.baseAngle == -90)
    #expect(metrics.isFrontVisible)
    #expect(metrics.sliceWidth == 50)
    #expect(abs(metrics.progressSin - 1) < 0.0001)
    #expect(abs(metrics.cosProgress) < 0.0001)
  }

  @Test func calculatesBackwardAndHiddenPageAtEndOfTurn() {
    let metrics = CurvedPageMetrics(isForward: false, progress: 1, halfWidth: 200)
    #expect(metrics.baseAngle == 180)
    #expect(metrics.isFrontVisible == false)
    #expect(abs(metrics.progressSin) < 0.0001)
  }
}

struct CurvedPageSliceTransformTests {
  @Test func reduceMotionRemovesScaleAndRotation() {
    let metrics = CurvedPageMetrics(isForward: true, progress: 0.5, halfWidth: 300)
    let transform = CurvedPageSliceTransform.make(index: 2, metrics: metrics, reduceMotion: true)
    #expect(transform.scale == 1)
    #expect(transform.angle == 0)
  }

  @Test func pageSliceCurvesDuringTurn() {
    let metrics = CurvedPageMetrics(isForward: true, progress: 0.5, halfWidth: 300)
    let transform = CurvedPageSliceTransform.make(index: 2, metrics: metrics, reduceMotion: false)
    #expect(transform.scale > 1)
    #expect(transform.angle < 0)
  }
}

struct BookSpineShadowMapperTests {
  @Test func clampsOpacityMetricsForBothColorSchemes() {
    let minimum = BookSpineShadowMapper.opacityMetrics(colorScheme: .light, intensity: -5)
    let maximum = BookSpineShadowMapper.opacityMetrics(colorScheme: .dark, intensity: 10)
    #expect(abs(minimum.shadow - 0.038) < 0.0001)
    #expect(abs(minimum.crease - 0.040) < 0.0001)
    #expect(maximum.shadow == 1)
    #expect(abs(maximum.crease - 0.875) < 0.0001)
  }
}

struct StoryShimmerMetricsTests {
  @Test func calculatesBandAndClampedSweepPositions() {
    let bandWidth = StoryShimmerMetrics.bandWidth(in: 100, ratio: 0.4)
    #expect(bandWidth == 40)
    #expect(StoryShimmerMetrics.horizontalOffset(viewWidth: 100, bandWidth: bandWidth, progress: 0) == -70)
    #expect(StoryShimmerMetrics.horizontalOffset(viewWidth: 100, bandWidth: bandWidth, progress: 0.5) == 0)
    #expect(StoryShimmerMetrics.horizontalOffset(viewWidth: 100, bandWidth: bandWidth, progress: 1) == 70)
    #expect(StoryShimmerMetrics.horizontalOffset(viewWidth: 100, bandWidth: bandWidth, progress: 2) == 70)
  }
}
