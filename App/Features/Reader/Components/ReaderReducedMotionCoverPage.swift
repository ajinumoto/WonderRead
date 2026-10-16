import SwiftUI

struct ReaderReducedMotionCoverPage: View {
  var info: ReaderCoverInfo
  var isWide: Bool
  var spineIntensity: Double

  @ViewBuilder
  var body: some View {
    if isWide {
      StorySpreadPage(
        illustrationPage: StoryBlankEndpaperPage(spineIntensity: spineIntensity),
        storyPage: StoryReaderCoverPage(
          seriesBadge: info.seriesBadge,
          collectionTitle: info.collectionTitle,
          chapter: info.chapter,
          coverImageURL: info.coverImageURL,
          spineIntensity: spineIntensity,
          showsSpineShadow: false
        ),
        spineIntensity: spineIntensity
      )
      .id("reduced-cover-wide")
    } else {
      StoryReaderCoverPage(
        seriesBadge: info.seriesBadge,
        collectionTitle: info.collectionTitle,
        chapter: info.chapter,
        coverImageURL: info.coverImageURL,
        spineIntensity: 0,
        showsSpineShadow: false
      )
      .id("reduced-cover-compact")
    }
  }
}
