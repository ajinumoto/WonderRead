import Foundation

struct StoryReaderState {
  private(set) var selectedChapterID: UUID?
  private(set) var isShowingCoverPage: Bool
  private(set) var isShowingLoadingPage = false
  private(set) var loadingPageIndex: Int?
  private(set) var generationAttempt = 0
  private(set) var generationErrorMessage: String?

  init(initialChapterID: UUID, startsAtCover: Bool) {
    selectedChapterID = startsAtCover ? nil : initialChapterID
    isShowingCoverPage = startsAtCover
  }

  func currentChapter(in chapters: [StoryChapter]) -> StoryChapter? {
    guard !isShowingLoadingPage, !isShowingCoverPage else { return nil }
    if let selectedChapterID,
       let selectedChapter = chapters.first(where: { $0.id == selectedChapterID }) {
      return selectedChapter
    }
    return chapters.first
  }

  func nextChapter(in chapters: [StoryChapter]) -> StoryChapter? {
    guard !isShowingLoadingPage else { return nil }
    if isShowingCoverPage { return chapters.first }
    let index = currentChapterIndex(in: chapters)
    guard index + 1 < chapters.count else { return nil }
    return chapters[index + 1]
  }

  func previousChapter(in chapters: [StoryChapter]) -> StoryChapter? {
    if isShowingLoadingPage { return chapters.last }
    if isShowingCoverPage { return nil }
    let index = currentChapterIndex(in: chapters)
    guard index > 0 else { return nil }
    return chapters[index - 1]
  }

  func currentChapterIndex(in chapters: [StoryChapter]) -> Int {
    if isShowingLoadingPage { return loadingPageIndex ?? chapters.count }
    if let selectedChapterID,
       let index = chapters.firstIndex(where: { $0.id == selectedChapterID }) {
      return index
    }
    return 0
  }

  func readerPageIndex(in chapters: [StoryChapter], coverOffset: Int) -> Int {
    if isShowingCoverPage { return 0 }
    if isShowingLoadingPage { return (loadingPageIndex ?? chapters.count) + coverOffset }
    if let selectedChapterID,
       let index = chapters.firstIndex(where: { $0.id == selectedChapterID }) {
      return index + coverOffset
    }
    return 0
  }

  func canGoToPrevious(in chapters: [StoryChapter], coverOffset: Int) -> Bool {
    if isShowingCoverPage { return false }
    if isShowingLoadingPage { return true }
    return readerPageIndex(in: chapters, coverOffset: coverOffset) > 0
  }

  func canGoToNext(in chapters: [StoryChapter], isCuratedMode: Bool) -> Bool {
    if isShowingCoverPage { return !chapters.isEmpty }
    if isCuratedMode { return currentChapterIndex(in: chapters) + 1 < chapters.count }
    return true
  }

  mutating func selectPage(
    _ pageIndex: Int,
    chapters: [StoryChapter],
    coverOffset: Int,
    hasCoverPage: Bool,
    isCuratedMode: Bool
  ) {
    if hasCoverPage && pageIndex == 0 { showCoverPage(); return }
    let chapterIndex = pageIndex - coverOffset
    dismissLoadingPageIfNeeded(before: chapterIndex)
    if chapterIndex >= chapters.count {
      startGenerationIfAllowed(chapterCount: chapters.count, isCuratedMode: isCuratedMode)
      return
    }
    selectChapter(at: chapterIndex, from: chapters)
  }

  private mutating func showCoverPage() {
    isShowingCoverPage = true
    selectedChapterID = nil
    isShowingLoadingPage = false
    loadingPageIndex = nil
    generationErrorMessage = nil
  }

  private mutating func dismissLoadingPageIfNeeded(before chapterIndex: Int) {
    guard isShowingLoadingPage, let loadingPageIndex, chapterIndex < loadingPageIndex else { return }
    generationAttempt += 1
    isShowingLoadingPage = false
    self.loadingPageIndex = nil
    generationErrorMessage = nil
  }

  private mutating func startGenerationIfAllowed(chapterCount: Int, isCuratedMode: Bool) {
    guard !isCuratedMode, !isShowingLoadingPage else { return }
    beginGeneration(chapterCount: chapterCount, isCuratedMode: isCuratedMode)
  }

  private mutating func selectChapter(at index: Int, from chapters: [StoryChapter]) {
    guard chapters.indices.contains(index) else { return }
    displayChapter(chapters[index].id)
  }

  private mutating func displayChapter(_ chapterID: UUID?) {
    isShowingCoverPage = false
    selectedChapterID = chapterID
    isShowingLoadingPage = false
    loadingPageIndex = nil
    generationErrorMessage = nil
  }

  mutating func selectInitialChapter(id: UUID, chapters: [StoryChapter]) {
    if isShowingCoverPage {
      selectedChapterID = nil
      return
    }
    selectedChapterID = chapters.contains(where: { $0.id == id }) ? id : chapters.first?.id
  }

  mutating func openChapter(id: UUID, chapters: [StoryChapter]) {
    let chapterID = chapters.contains(where: { $0.id == id }) ? id : chapters.first?.id
    displayChapter(chapterID)
  }

  mutating func selectChapter(_ chapter: StoryChapter) {
    displayChapter(chapter.id)
  }

  mutating func beginGeneration(chapterCount: Int, isCuratedMode: Bool) {
    guard !isCuratedMode else { return }
    isShowingCoverPage = false
    isShowingLoadingPage = true
    loadingPageIndex = chapterCount
    selectedChapterID = nil
    generationErrorMessage = nil
    generationAttempt += 1
  }

  mutating func retryGeneration(isCuratedMode: Bool, isGenerating: Bool) {
    guard !isCuratedMode, !isGenerating else { return }
    generationErrorMessage = nil
    generationAttempt += 1
  }

  mutating func finishGeneration(with chapter: StoryChapter) {
    displayChapter(chapter.id)
  }

  mutating func reportGenerationFailure(_ message: String) {
    generationErrorMessage = message
  }
}
