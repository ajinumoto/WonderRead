import Foundation
import SwiftUI
import Testing
@testable import WonderRead

struct StoryDoodleMetricsTests {
  @Test func fullPageMetricsRespectMinimumArtworkSize() {
    let metrics = StoryDoodleMetrics.fullPage(for: CGSize(width: 80, height: 80))
    #expect(metrics.minDimension == 80)
    #expect(metrics.heroSize == 56)
    #expect(metrics.satelliteSize == 56 * 0.38)
  }

  @Test func thumbnailMetricsScaleFromShortestDimension() {
    let metrics = StoryDoodleMetrics.thumbnail(for: CGSize(width: 400, height: 200))
    #expect(metrics.minDimension == 200)
    #expect(metrics.heroSize == 72)
    #expect(metrics.satelliteSize == 72 * 0.38)
  }
}

struct StoryBookCoverMetricsTests {
  @Test func compactThresholdChangesTypographyAndSpacing() {
    let compact = StoryBookCoverMetrics(size: CGSize(width: 200, height: 319))
    let regular = StoryBookCoverMetrics(size: CGSize(width: 200, height: 320))
    #expect(compact.isCompact)
    #expect(compact.titleFontSize == 18)
    #expect(compact.bottomPadding == 14)
    #expect(compact.contentSpacing == 6)
    #expect(regular.isCompact == false)
    #expect(regular.titleFontSize == 22)
  }
}

struct StoryDoodleThemeTests {
  @Test func themeSelectionIsStableForTheSameChapter() {
    let chapter = StoryFixtures.chapter(id: UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1)))
    #expect(StoryDoodleTheme.select(for: chapter) == StoryDoodleTheme.select(for: chapter))
    #expect(StoryDoodleTheme.allCases.contains(StoryDoodleTheme.select(for: chapter)))
    #expect(StoryDoodleTheme.select(for: chapter) == .storybook)
  }

  @Test func eachThemeProvidesOneHeroAndThreeSatelliteSymbols() {
    #expect(StoryDoodleTheme.allCases.allSatisfy { !$0.heroSymbol.isEmpty })
    #expect(StoryDoodleTheme.allCases.allSatisfy { $0.satelliteSymbols.count == 3 })
    #expect(StoryDoodleTheme.allCases.allSatisfy { !$0.title.isEmpty })
  }
}
