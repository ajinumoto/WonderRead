import SwiftUI

struct StoryReaderView: View {
  @Environment(StoryLibrary.self) private var storyLibrary
  @Environment(StoryPreferencesStore.self) private var preferenceStore
  @Environment(CuratedReadingTracker.self) private var curatedReadingTracker
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.accessibilityReduceMotion) private var reduceMotion
  @Environment(\.verticalSizeClass) private var verticalSizeClass
  @AppStorage("ai.provider") private var providerRaw = StoryAIProvider.local.rawValue
  @AppStorage("ai.gemini.storyModel") private var geminiModelRaw = StoryGeminiModel.defaultModelID
  @AppStorage("ai.gemini.storyModelOutputLimit") private var geminiOutputLimit = 8192
  @AppStorage("ai.gemini.storyLanguage") private var geminiStoryLanguage = StoryGeminiLanguages.defaultLanguage
  @AppStorage("reader.textSize") private var readerTextSize = 2

  var initialChapterID: UUID
  var source: StoryReaderSource
  var onHome: () -> Void

  @State private var readerState: StoryReaderState
  @State private var hydratedCuratedChapters: [StoryChapter]?
  @State private var spineIntensity = 1.0
  @State private var macProgrammaticAction: MacPageTurnAction?
  @State private var previousActionCount = 0
  @State private var nextActionCount = 0
  @State private var isChromeVisible = true

  init(initialChapterID: UUID, source: StoryReaderSource = .library, onHome: @escaping () -> Void = {}) {
    self.initialChapterID = initialChapterID
    self.source = source
    self.onHome = onHome
    _readerState = State(initialValue: StoryReaderState(initialChapterID: initialChapterID, startsAtCover: false))
  }

  init(collection: StoryCollection, initialChapterID: UUID? = nil, onHome: @escaping () -> Void = {}) {
    let targetID = initialChapterID ?? collection.chapters.first?.id ?? UUID()
    self.initialChapterID = targetID
    self.source = .collection(collection)
    self.onHome = onHome
    let shouldStartAtCover = (initialChapterID == nil)
    _readerState = State(initialValue: StoryReaderState(initialChapterID: targetID, startsAtCover: shouldStartAtCover))
  }

  private var isCuratedMode: Bool {
    if case .collection = source {
      return true
    }
    return false
  }

  private var isShowingCoverPage: Bool { readerState.isShowingCoverPage }
  private var isShowingLoadingPage: Bool { readerState.isShowingLoadingPage }
  private var generationErrorMessage: String? { readerState.generationErrorMessage }

  private var isCompactHeight: Bool {
    #if os(iOS)
    return verticalSizeClass == .compact
    #else
    return false
    #endif
  }

  private var ignoredSafeAreaEdges: Edge.Set {
    isChromeVisible ? [] : .all
  }

  private var chapters: [StoryChapter] {
    switch source {
    case .library:
      return storyLibrary.chapters
    case .collection(let collection):
      if let hydratedCuratedChapters, !hydratedCuratedChapters.isEmpty {
        return hydratedCuratedChapters
      }
      return collection.chapters
    }
  }

  private var currentCoverInfo: ReaderCoverInfo? {
    StoryReaderCoverInfoMapper.make(source: effectiveSource, libraryChapters: storyLibrary.chapters)
  }

  private var effectiveSource: StoryReaderSource {
    guard case .collection(var collection) = source,
          let hydratedCuratedChapters, !hydratedCuratedChapters.isEmpty else {
      return source
    }
    collection.chapters = hydratedCuratedChapters
    return .collection(collection)
  }

  private var hasCoverPage: Bool {
    currentCoverInfo != nil
  }

  private var coverOffset: Int {
    hasCoverPage ? 1 : 0
  }

  private var currentChapter: StoryChapter? {
    readerState.currentChapter(in: chapters)
  }

  private var nextChapter: StoryChapter? {
    readerState.nextChapter(in: chapters)
  }

  private var prevChapter: StoryChapter? {
    readerState.previousChapter(in: chapters)
  }

  var body: some View {
    GeometryReader { geometry in
      let deviceCategory = ReaderDeviceCategory.resolve(geometry: geometry)
      ZStack(alignment: .bottomLeading) {
        StoryReaderSurface(
          isEmpty: chapters.isEmpty,
          context: layoutContextFactory.make(
            geometry: geometry,
            category: deviceCategory,
            isWide: StoryLayout.usesTwoPanes(for: geometry)
          ),
          actions: layoutActions,
          reduceMotion: reduceMotion,
          isFullscreen: !isChromeVisible
        )

        ReaderFullscreenToggleButton(
          isFullscreen: !isChromeVisible,
          action: toggleFullscreen
        )
        .padding(.leading, 12)
        .padding(.bottom, 12)
      }
    }
    .ignoresSafeArea(.all, edges: ignoredSafeAreaEdges)
    .background(ReaderBackgroundView().ignoresSafeArea())
    .navigationTitle("")
    #if os(iOS)
    .navigationBarTitleDisplayMode(.inline)
    .toolbarVisibility(isChromeVisible ? .visible : .hidden, for: .navigationBar)
    .toolbarVisibility(isChromeVisible ? .visible : .hidden, for: .bottomBar)
    #endif
    .toolbar {
      StoryReaderToolbar(
        isVisible: isChromeVisible,
        readerTextSize: readerTextSize,
        canGoToPrevious: canGoToPrevious,
        canGoToNext: canGoToNext,
        isCompactHeight: isCompactHeight,
        reduceMotion: reduceMotion,
        previousActionCount: previousActionCount,
        nextActionCount: nextActionCount,
        onPrevious: navigatePrevious,
        onNext: navigateNext,
        onDecreaseText: { adjustReaderTextSize(by: -1) },
        onIncreaseText: { adjustReaderTextSize(by: 1) }
      )
    }
    .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.7), trigger: currentReaderPageIndex)
    .sensoryFeedback(.selection, trigger: readerTextSize)
    .task {
      await hydrateCuratedChaptersIfNeeded()
      readerState.selectInitialChapter(id: initialChapterID, chapters: chapters)
      recordCuratedProgressIfNeeded()
    }
    .onChange(of: initialChapterID) { _, newID in
      readerState.openChapter(id: newID, chapters: chapters)
      recordCuratedProgressIfNeeded()
    }
    .onChange(of: readerState.selectedChapterID) { _, _ in
      recordCuratedProgressIfNeeded()
    }
    .task(id: readerState.generationAttempt) {
      await generatePendingChapter()
    }
  }

  private var layoutActions: StoryReaderLayoutActions {
    StoryReaderLayoutActions(
      spineIntensity: $spineIntensity,
      programmaticAction: $macProgrammaticAction,
      onChapterChanged: selectReaderPage,
      onRetryGeneration: retryGeneration,
      onTurnToChapter: { readerState.selectChapter($0) },
      onTurnToPreviousChapter: { readerState.selectChapter($0) },
      onTurnToLoading: beginGeneration,
      onTurnBackFromLoading: { readerState.selectChapter($0) }
    )
  }

  private var pageSources: ReaderLayoutPageSources {
    ReaderLayoutPageSourcesFactory.make(context: pageBuildContext)
  }

  private var layoutContextFactory: StoryReaderLayoutContextFactory {
    StoryReaderLayoutContextFactory(
      pages: pageSources,
      chapterIndex: currentReaderPageIndex,
      reduceMotion: reduceMotion,
      contentIdentity: contentIdentity,
      isShowingCover: isShowingCoverPage,
      coverInfo: currentCoverInfo,
      isShowingLoadingPage: isShowingLoadingPage,
      isGenerating: storyLibrary.isGenerating,
      generationErrorMessage: generationErrorMessage,
      currentChapter: currentChapter,
      nextChapter: nextChapter,
      previousChapter: prevChapter,
      nickname: displayName,
      textScale: readerTextScale,
      isFullscreen: !isChromeVisible
    )
  }

  private var displayName: String {
    preferenceStore.nickname.isEmpty ? String(localized: "friend", comment: "Localized app copy.") : preferenceStore.nickname
  }

  private var contentIdentity: [AnyHashable] {
    ReaderPageIdentityMapper.make(
      chapterIDs: chapters.map(\.id),
      hasCoverPage: hasCoverPage,
      isCuratedMode: isCuratedMode
    )
  }

  private var pageBuildContext: ReaderPageBuildContext {
    ReaderPageBuildContext(
      chapters: chapters,
      coverInfo: currentCoverInfo,
      isGenerating: isCuratedMode ? false : storyLibrary.isGenerating,
      generationErrorMessage: isCuratedMode ? nil : generationErrorMessage,
      nickname: preferenceStore.nickname,
      textScale: readerTextScale,
      spineIntensity: spineIntensity,
      colorScheme: colorScheme,
      includesLoadingPage: !isCuratedMode,
      onRetryGeneration: retryGeneration
    )
  }

  private func toggleFullscreen() {
    withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.25)) {
      isChromeVisible.toggle()
    }
  }

  private func selectReaderPage(_ pageIndex: Int) {
    readerState.selectPage(
      pageIndex,
      chapters: chapters,
      coverOffset: coverOffset,
      hasCoverPage: hasCoverPage,
      isCuratedMode: isCuratedMode
    )
  }

  private var currentReaderPageIndex: Int {
    readerState.readerPageIndex(in: chapters, coverOffset: coverOffset)
  }

  private var canGoToPrevious: Bool {
    readerState.canGoToPrevious(in: chapters, coverOffset: coverOffset)
  }

  private var canGoToNext: Bool {
    readerState.canGoToNext(in: chapters, isCuratedMode: isCuratedMode)
  }

  private func navigatePrevious() {
    guard canGoToPrevious else { return }
    previousActionCount += 1
    #if os(iOS)
    selectReaderPage(max(currentReaderPageIndex - 1, 0))
    #else
    macProgrammaticAction = .backward
    #endif
  }

  private func navigateNext() {
    guard canGoToNext else { return }
    nextActionCount += 1
    if isShowingCoverPage {
      #if os(iOS)
      selectReaderPage(coverOffset)
      #else
      macProgrammaticAction = .forward
      #endif
      return
    }
    #if os(iOS)
    selectReaderPage(currentReaderPageIndex + 1)
    #else
    macProgrammaticAction = .forward
    #endif
  }

  private func beginGeneration() {
    readerState.beginGeneration(chapterCount: chapters.count, isCuratedMode: isCuratedMode)
  }

  private func retryGeneration() {
    readerState.retryGeneration(isCuratedMode: isCuratedMode, isGenerating: storyLibrary.isGenerating)
  }

  private var readerTextScale: CGFloat {
    ReaderTextScaleMapper.scale(for: readerTextSize)
  }

  private func adjustReaderTextSize(by amount: Int) {
    readerTextSize = min(max(readerTextSize + amount, 0), 4)
  }

  private func recordCuratedProgressIfNeeded() {
    guard case .collection(let collection) = effectiveSource, let chapter = currentChapter else { return }
    curatedReadingTracker.recordReading(collection: collection, chapter: chapter)
  }

  private func hydrateCuratedChaptersIfNeeded() async {
    guard case .collection(let collection) = source, collection.chapters.isEmpty else { return }
    let hydrated = await SupabaseStoryService.hydrateChaptersIfNeeded(for: collection)
    guard !hydrated.chapters.isEmpty else { return }
    hydratedCuratedChapters = hydrated.chapters
  }

  private func generatePendingChapter() async {
    guard shouldGeneratePendingChapter else { return }
    do {
      let provider = selectedProvider
      let apiKey = try await apiKey(for: provider)
      let chapter = try await storyLibrary.generateNextChapter(
        preferences: preferenceStore.storyPreferences,
        options: generationOptions(provider: provider, apiKey: apiKey)
      )
      try Task.checkCancellation()
      readerState.finishGeneration(with: chapter)
    } catch is CancellationError {
      return
    } catch {
      readerState.reportGenerationFailure(error.localizedDescription)
    }
  }

  private var shouldGeneratePendingChapter: Bool {
    !isCuratedMode && readerState.generationAttempt > 0
      && isShowingLoadingPage && generationErrorMessage == nil
  }

  private var selectedProvider: StoryAIProvider {
    StoryGenerationOptionsMapper.provider(from: providerRaw)
  }

  private func apiKey(for provider: StoryAIProvider) async throws -> String? {
    provider == .gemini ? try await GeminiAPIKeyStore.read() : nil
  }

  private func generationOptions(provider: StoryAIProvider, apiKey: String?) -> StoryGenerationOptions {
    StoryGenerationOptionsMapper.make(
      provider: provider,
      apiKey: apiKey,
      model: geminiModelRaw,
      outputTokenLimit: geminiOutputLimit,
      language: geminiStoryLanguage
    )
  }

}
