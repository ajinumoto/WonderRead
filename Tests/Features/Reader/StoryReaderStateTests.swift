import Foundation
import Testing
@testable import WonderRead

struct StoryReaderStateTests {
  @Test func coverStateStartsAtPageZeroAndOffersFirstChapter() {
    let chapter = StoryFixtures.chapter()
    let state = StoryReaderState(initialChapterID: chapter.id, startsAtCover: true)
    #expect(state.isShowingCoverPage)
    #expect(state.currentChapter(in: [chapter]) == nil)
    #expect(state.nextChapter(in: [chapter])?.id == chapter.id)
    #expect(state.readerPageIndex(in: [chapter], coverOffset: 1) == 0)
    #expect(state.canGoToPrevious(in: [chapter], coverOffset: 1) == false)
  }

  @Test func selectedChapterCalculatesNeighborsAndPageOffset() {
    let chapters = (1...3).map { StoryFixtures.chapter(number: $0) }
    let state = StoryReaderState(initialChapterID: chapters[1].id, startsAtCover: false)
    #expect(state.currentChapter(in: chapters)?.id == chapters[1].id)
    #expect(state.previousChapter(in: chapters)?.id == chapters[0].id)
    #expect(state.nextChapter(in: chapters)?.id == chapters[2].id)
    #expect(state.readerPageIndex(in: chapters, coverOffset: 1) == 2)
  }

  @Test func missingSelectedChapterFallsBackToFirst() {
    let first = StoryFixtures.chapter(number: 1)
    let state = StoryReaderState(initialChapterID: UUID(), startsAtCover: false)
    #expect(state.currentChapter(in: [first])?.id == first.id)
    #expect(state.currentChapterIndex(in: [first]) == 0)
  }

  @Test func curatedNavigationStopsAtLastChapter() {
    let chapters = (1...2).map { StoryFixtures.chapter(number: $0, source: .curated) }
    let state = StoryReaderState(initialChapterID: chapters[1].id, startsAtCover: false)
    #expect(state.nextChapter(in: chapters) == nil)
    #expect(state.canGoToNext(in: chapters, isCuratedMode: true) == false)
    #expect(state.canGoToNext(in: chapters, isCuratedMode: false))
    #expect(state.canGoToPrevious(in: chapters, coverOffset: 1))
  }

  @Test func selectingCoverAndChapterUpdatesDisplayedPage() {
    let chapters = (1...2).map { StoryFixtures.chapter(number: $0) }
    var state = StoryReaderState(initialChapterID: chapters[0].id, startsAtCover: false)
    state.selectPage(0, chapters: chapters, coverOffset: 1, hasCoverPage: true, isCuratedMode: false)
    #expect(state.isShowingCoverPage)
    state.selectPage(2, chapters: chapters, coverOffset: 1, hasCoverPage: true, isCuratedMode: false)
    #expect(state.currentChapter(in: chapters)?.id == chapters[1].id)
    #expect(state.isShowingCoverPage == false)
  }

  @Test func selectingPageAfterLastChapterBeginsGenerationOnlyForLibrary() {
    let chapter = StoryFixtures.chapter()
    var library = StoryReaderState(initialChapterID: chapter.id, startsAtCover: false)
    library.selectPage(1, chapters: [chapter], coverOffset: 0, hasCoverPage: false, isCuratedMode: false)
    #expect(library.isShowingLoadingPage)
    #expect(library.loadingPageIndex == 1)
    var curated = StoryReaderState(initialChapterID: chapter.id, startsAtCover: false)
    curated.selectPage(1, chapters: [chapter], coverOffset: 0, hasCoverPage: false, isCuratedMode: true)
    #expect(curated.isShowingLoadingPage == false)
  }

  @Test func loadingStateReportsNeighborsAndPageIndex() {
    let chapters = (1...2).map { StoryFixtures.chapter(number: $0) }
    var state = StoryReaderState(initialChapterID: chapters[0].id, startsAtCover: false)
    state.beginGeneration(chapterCount: chapters.count, isCuratedMode: false)
    #expect(state.currentChapter(in: chapters) == nil)
    #expect(state.previousChapter(in: chapters)?.id == chapters.last?.id)
    #expect(state.nextChapter(in: chapters) == nil)
    #expect(state.readerPageIndex(in: chapters, coverOffset: 1) == 3)
    #expect(state.canGoToPrevious(in: chapters, coverOffset: 1))
  }

  @Test func selectingEarlierChapterCancelsLoadingAndClearsError() {
    let chapters = (1...3).map { StoryFixtures.chapter(number: $0) }
    var state = StoryReaderState(initialChapterID: chapters[0].id, startsAtCover: false)
    state.beginGeneration(chapterCount: chapters.count, isCuratedMode: false)
    state.reportGenerationFailure("Try again")
    state.selectPage(1, chapters: chapters, coverOffset: 0, hasCoverPage: false, isCuratedMode: false)
    #expect(state.currentChapter(in: chapters)?.id == chapters[1].id)
    #expect(state.isShowingLoadingPage == false)
    #expect(state.generationErrorMessage == nil)
    #expect(state.generationAttempt == 2)
  }

  @Test func retryAndGenerationCompletionUpdateState() {
    let generated = StoryFixtures.chapter(number: 3)
    var state = StoryReaderState(initialChapterID: UUID(), startsAtCover: false)
    state.reportGenerationFailure("Failure")
    state.retryGeneration(isCuratedMode: false, isGenerating: false)
    #expect(state.generationErrorMessage == nil)
    #expect(state.generationAttempt == 1)
    state.finishGeneration(with: generated)
    #expect(state.selectedChapterID == generated.id)
    #expect(state.isShowingLoadingPage == false)
  }

  @Test func retryIsIgnoredForCuratedStoriesOrActiveGeneration() {
    var curated = StoryReaderState(initialChapterID: UUID(), startsAtCover: false)
    curated.reportGenerationFailure("Failure")
    curated.retryGeneration(isCuratedMode: true, isGenerating: false)
    #expect(curated.generationAttempt == 0)
    var active = StoryReaderState(initialChapterID: UUID(), startsAtCover: false)
    active.retryGeneration(isCuratedMode: false, isGenerating: true)
    #expect(active.generationAttempt == 0)
  }

  @Test func openAndInitialChapterSelectionFallBackSafely() {
    let chapters = (1...2).map { StoryFixtures.chapter(number: $0) }
    var state = StoryReaderState(initialChapterID: UUID(), startsAtCover: false)
    state.selectInitialChapter(id: UUID(), chapters: chapters)
    #expect(state.selectedChapterID == chapters[0].id)
    state.openChapter(id: UUID(), chapters: chapters)
    #expect(state.selectedChapterID == chapters[0].id)
    state.selectChapter(chapters[1])
    #expect(state.selectedChapterID == chapters[1].id)
  }

  @Test func initialSelectionRemainsOnCoverUntilOpened() {
    let chapter = StoryFixtures.chapter()
    var state = StoryReaderState(initialChapterID: chapter.id, startsAtCover: true)
    state.selectInitialChapter(id: chapter.id, chapters: [chapter])
    #expect(state.selectedChapterID == nil)
    #expect(state.isShowingCoverPage)
  }
}
