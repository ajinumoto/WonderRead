import Foundation
import Testing
@testable import WonderRead

struct ReaderTextScaleMapperTests {
  @Test(arguments: [
    ScaleCase(step: -10, expected: 0.85),
    ScaleCase(step: 0, expected: 0.85),
    ScaleCase(step: 2, expected: 1.0),
    ScaleCase(step: 4, expected: 1.15),
    ScaleCase(step: 10, expected: 1.15)
  ])
  func clampsTextSizeSteps(_ input: ScaleCase) {
    #expect(ReaderTextScaleMapper.scale(for: input.step) == input.expected)
  }
}

struct ScaleCase: Sendable {
  var step: Int
  var expected: CGFloat
}

struct ReaderSwipeDirectionMapperTests {
  @Test func mapsHorizontalSwipesToChapterDirection() {
    #expect(ReaderSwipeDirectionMapper.direction(for: CGSize(width: -100, height: 0), minimumDistance: 40, dominance: 1.2) == 1)
    #expect(ReaderSwipeDirectionMapper.direction(for: CGSize(width: 100, height: 0), minimumDistance: 40, dominance: 1.2) == -1)
  }

  @Test func ignoresShortOrMostlyVerticalGestures() {
    #expect(ReaderSwipeDirectionMapper.direction(for: CGSize(width: 40, height: 0), minimumDistance: 40, dominance: 1.2) == nil)
    #expect(ReaderSwipeDirectionMapper.direction(for: CGSize(width: 50, height: 60), minimumDistance: 40, dominance: 1.2) == nil)
  }
}

struct ReaderPageIdentityMapperTests {
  @Test func identityChangesOnlyForStructuralReaderContent() {
    let ids = [UUID(), UUID()]
    let base = ReaderPageIdentityMapper.make(chapterIDs: ids, hasCoverPage: true, isCuratedMode: false)
    #expect(base == ReaderPageIdentityMapper.make(chapterIDs: ids, hasCoverPage: true, isCuratedMode: false))
    #expect(base != ReaderPageIdentityMapper.make(chapterIDs: ids, hasCoverPage: false, isCuratedMode: false))
    #expect(base != ReaderPageIdentityMapper.make(chapterIDs: ids, hasCoverPage: true, isCuratedMode: true))
  }
}

struct StoryTextContentMapperTests {
  @Test func curatedHeadingUsesCollectionTitle() {
    let chapter = StoryFixtures.chapter(number: 5, seriesTitle: "  Moon Garden  ", source: .curated)
    let heading = StoryTextContentMapper.chapterHeader(for: chapter)
    #expect(heading.contains("Moon Garden"))
    #expect(heading.contains("5"))
  }

  @Test func generatedHeadingDoesNotUseSeriesTitleAsCollectionHeading() {
    let chapter = StoryFixtures.chapter(number: 4, seriesTitle: "Moon Garden", source: .generated)
    let heading = StoryTextContentMapper.chapterHeader(for: chapter)
    #expect(heading.contains("Moon Garden") == false)
    #expect(heading.contains("4"))
  }

  @Test func curatedHeadingFallsBackWhenCollectionTitleIsEmpty() {
    let chapter = StoryFixtures.chapter(number: 2, seriesTitle: " ", source: .curated)
    #expect(StoryTextContentMapper.chapterHeader(for: chapter).contains("2"))
  }
}

struct StoryReaderCoverInfoMapperTests {
  @Test func collectionCoverUsesCollectionMetadataAndFirstChapter() throws {
    let chapter = StoryFixtures.chapter(number: 7)
    let collection = StoryFixtures.collection(title: "Moon Garden", chapters: [chapter])
    let cover = try #require(StoryReaderCoverInfoMapper.make(source: .collection(collection), libraryChapters: []))
    #expect(cover.collectionTitle == "Moon Garden")
    #expect(cover.chapterTitle == chapter.title)
    #expect(cover.chapterNumber == 7)
    #expect(cover.coverImageURL == collection.coverImageURL)
  }

  @Test func collectionCoverFallsBackToChapterSummaryWhenDescriptionIsEmpty() throws {
    var collection = StoryFixtures.collection(chapters: [StoryFixtures.chapter()])
    collection.description = ""
    let cover = try #require(StoryReaderCoverInfoMapper.make(source: .collection(collection), libraryChapters: []))
    #expect(cover.chapterSummary == collection.chapters[0].summary)
  }

  @Test func libraryCoverUsesLatestChapterAndMissingLibraryHasNoCover() throws {
    let first = StoryFixtures.chapter(number: 1)
    let cover = try #require(StoryReaderCoverInfoMapper.make(source: .library, libraryChapters: [first]))
    #expect(cover.chapter == first)
    #expect(cover.coverImageURL == first.illustrationFilename)
    #expect(StoryReaderCoverInfoMapper.make(source: .library, libraryChapters: []) == nil)
  }
}
