import SwiftUI

#if os(iOS)
struct DuoInnerBookReaderView: View, ReaderLayoutContextProviding {
  var context: StoryReaderLayoutContext
  var actions: StoryReaderLayoutActions

  private var targetWidth: CGFloat {
    DuoInnerBookWidthMapper.resolve(geometry: geometry, isFullscreen: isFullscreen)
  }

  var body: some View {
    Group {
      if reduceMotion { reducedMotionReader }
      else { pageCurlReader }
    }
    .frame(width: targetWidth, alignment: .leading)
  }

  private var pageCurlReader: some View {
    PageCurlReaderView(
      isFullscreen: isFullscreen,
      usesTwoPanes: true,
      ignoresPageSafeArea: true,
      pages: duoBookPages,
      chapterIndex: chapterIndex,
      onChapterChanged: onChapterChanged,
      contentIdentity: contentIdentity
    )
    .ignoresSafeArea(.all, edges: .horizontal)
    .background(ReaderBackgroundView())
    .accessibilityHint(String(localized: "Turn the two-page spread to open the previous or next story", comment: "Localized app copy."))
  }

  private var reducedMotionReader: some View {
    Group {
      if isShowingCover, let coverInfo { coverSpread(coverInfo) }
      else { DuoReducedMotionStoryPages(context: context, actions: actions) }
    }
    .background(ReaderBackgroundView())
    .modifier(DuoReaderSwipeModifier(
      chapterIndex: chapterIndex,
      minimumDistance: 48,
      completionDistance: 76,
      verticalDominance: 1.25,
      onChapterChanged: onChapterChanged
    ))
  }

  private func coverSpread(_ coverInfo: ReaderCoverInfo) -> some View {
    StorySpreadPage(
      illustrationPage: StoryBlankEndpaperPage(spineIntensity: spineIntensity),
      storyPage: StoryReaderCoverPage(
        seriesBadge: coverInfo.seriesBadge,
        collectionTitle: coverInfo.collectionTitle,
        chapter: coverInfo.chapter,
        coverImageURL: coverInfo.coverImageURL,
        spineIntensity: spineIntensity,
        showsSpineShadow: false
      ),
      spineIntensity: spineIntensity
    )
  }
}

enum DuoInnerBookWidthMapper {
  static func resolve(geometry: GeometryProxy, isFullscreen: Bool) -> CGFloat {
    let divisionMidX: CGFloat? = if #available(iOS 27.1, *) {
      geometry.reservedRegions(kind: .division, options: .includeInactive).first?.frame.midX
    } else { nil }
    return resolve(width: geometry.size.width, divisionMidX: divisionMidX, isFullscreen: isFullscreen)
  }

  static func resolve(width: CGFloat, divisionMidX: CGFloat?, isFullscreen: Bool) -> CGFloat {
    if let divisionMidX, divisionMidX > 0 { return divisionMidX * 2 }
    if !isFullscreen && width >= 800 && width < 920 { return width + 84 }
    return width
  }
}
#endif
