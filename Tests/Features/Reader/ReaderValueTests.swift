import Foundation
import SwiftUI
import Testing
@testable import WonderRead

struct BookSpineEdgeTests {
  @Test func mapsHorizontalAxisAndForwardEdges() {
    #expect(BookSpineEdge.leading.isHorizontal)
    #expect(BookSpineEdge.trailing.isHorizontal)
    #expect(BookSpineEdge.leading.isForward == false)
    #expect(BookSpineEdge.trailing.isForward)
    #expect(BookSpineEdge.top.isHorizontal == false)
    #expect(BookSpineEdge.bottom.isForward)
  }
}

struct ReaderPairedPageLayoutTests {
  @Test func mapsSpineAndTextLayoutCharacteristics() {
    #expect(ReaderPairedPageLayout.twoPane.spineWidth == 32)
    #expect(ReaderPairedPageLayout.twoPane.displaysSpineWhenFlat)
    #expect(ReaderPairedPageLayout.twoPane.usesWideTextInsets == false)
    #expect(ReaderPairedPageLayout.duoBook.spineWidth == 32)
    #expect(ReaderPairedPageLayout.duoBook.usesWideTextInsets)
    #expect(ReaderPairedPageLayout.duoBook.displaysSpineWhenFlat)
  }
}

struct ReaderDeviceCategoryDisplayTests {
  @Test func exposesStableIdentifiersAndDisplayNames() {
    #expect(ReaderDeviceCategory.iphone.id == "iphone")
    #expect(ReaderDeviceCategory.iphone.displayName == "iPhone")
    #expect(ReaderDeviceCategory.iphoneDuo.displayName == "iPhone Duo")
    #expect(ReaderDeviceCategory.ipad.displayName == "iPad")
    #expect(ReaderDeviceCategory.mac.displayName == "Mac")
  }
}

struct ReaderPageBuildContextTests {
  @Test func derivesDisplayNameAndCoverArtworkFallback() {
    let chapter = StoryFixtures.chapter(illustrationFilename: "chapter-art.png")
    let context = makeContext(nickname: "", coverInfo: coverInfo(chapter: chapter, imageURL: ""))
    #expect(context.displayName == String(localized: "friend"))
    #expect(context.coverImageURL == "chapter-art.png")
  }

  @Test func prefersExplicitCoverArtworkAndPreservesNickname() {
    let chapter = StoryFixtures.chapter(illustrationFilename: "chapter-art.png")
    let context = makeContext(nickname: "Mira", coverInfo: coverInfo(chapter: chapter, imageURL: "cover.png"))
    #expect(context.displayName == "Mira")
    #expect(context.coverImageURL == "cover.png")
  }

  @Test func buildsTypedReaderPageViewsWithoutEagerErase() {
    let chapters = [StoryFixtures.chapter(number: 1), StoryFixtures.chapter(number: 2)]
    let context = ReaderPageBuildContext(
      chapters: chapters,
      coverInfo: coverInfo(chapter: chapters[0], imageURL: "cover.png"),
      isGenerating: false,
      generationErrorMessage: nil,
      nickname: "Mira",
      textScale: 1,
      spineIntensity: 1,
      colorScheme: .light,
      includesLoadingPage: true,
      onRetryGeneration: {}
    )
    let sources = ReaderLayoutPageSourcesFactory.make(context: context)
    #expect(sources.compact().count == 4)
    #expect(sources.twoPane().count == 8)
  }

  private func makeContext(nickname: String, coverInfo: ReaderCoverInfo?) -> ReaderPageBuildContext {
    ReaderPageBuildContext(
      chapters: [], coverInfo: coverInfo, isGenerating: false, generationErrorMessage: nil,
      nickname: nickname, textScale: 1, spineIntensity: 1, colorScheme: .light,
      includesLoadingPage: false, onRetryGeneration: {}
    )
  }

  private func coverInfo(chapter: StoryChapter, imageURL: String) -> ReaderCoverInfo {
    ReaderCoverInfo(
      seriesBadge: nil, collectionTitle: "Series", chapterTitle: chapter.title,
      chapterSummary: chapter.summary, chapterNumber: chapter.number, chapter: chapter,
      coverImageURL: imageURL
    )
  }
}
