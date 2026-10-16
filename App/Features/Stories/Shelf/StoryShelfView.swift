import SwiftUI

struct StoryShelfView: View {
  @Environment(StoryLibrary.self) private var storyLibrary
  @Environment(StoryPreferencesStore.self) private var preferenceStore
  #if os(macOS)
  @Environment(\.openSettings) private var openSettings
  #endif
  @AppStorage("ai.provider") private var providerRaw = StoryAIProvider.local.rawValue
  @AppStorage("ai.gemini.storyModel") private var geminiModelRaw = StoryGeminiModel.defaultModelID
  @AppStorage("ai.gemini.storyModelOutputLimit") private var geminiOutputLimit = 8192
  @AppStorage("ai.gemini.storyLanguage") private var geminiStoryLanguage = StoryGeminiLanguages.defaultLanguage
  @AppStorage("setup.completed") private var hasCompletedSetup = false
  @AppStorage("supabase.preferredLanguage") private var selectedLanguage = "en"
  @State private var collectionsDataSource = StoryCollectionsDataSource()
  @State private var refreshID = UUID()
  @State private var showingSettings = false
  @State private var showingParentalGate = false
  @State private var showingOnboarding = false
  @State private var generationRequested = false
  @State private var showingGenerationError = false
  @State private var generationErrorMessage = ""

  var onContinueReading: () -> Void
  var onOpenHistory: () -> Void
  var onOpenCollection: (StoryCollection) -> Void = { _ in }
  var onOpenCuratedChapter: (StoryCollection, UUID) -> Void = { _, _ in }

  var body: some View {
    shelfRoot
      .toolbar { shelfToolbar }
      .shelfSheets(
        showingParentalGate: $showingParentalGate,
        showingSettings: $showingSettings,
        showingOnboarding: $showingOnboarding,
        hasCompletedSetup: $hasCompletedSetup,
        generationRequested: $generationRequested,
        storyLibrary: storyLibrary
      )
      .task(id: generationRequested) { await handleGenerationRequest() }
      .generationErrorAlert(
        isPresented: $showingGenerationError,
        errorMessage: generationErrorMessage
      )
  }


  private var shelfRoot: some View {
    GeometryReader { geometry in
      StoryShelfMainContent(
        context: StoryShelfContentContext(
          geometry: geometry,
          nickname: preferenceStore.nickname,
          chapter: storyLibrary.latestChapter,
          isGenerating: storyLibrary.isGenerating,
          refreshID: refreshID,
          collectionsDataSource: collectionsDataSource
        ),
        actions: StoryShelfContentActions(
          onContinueReading: onContinueReading,
          onOpenCollection: onOpenCollection,
          onOpenCuratedChapter: onOpenCuratedChapter,
          onCreateStory: handleCreateAIStory,
          onRefresh: handleRefresh
        )
      )
    }
  }

  private func handleRefresh() async {
    await collectionsDataSource.refresh(language: selectedLanguage)
    refreshID = UUID()
  }

  @ToolbarContentBuilder
  private var shelfToolbar: some ToolbarContent {
      ToolbarItem(placement: .automatic) {
        Button(String(localized: "History"), systemImage: "clock.arrow.circlepath", action: onOpenHistory)
      }
      ToolbarItem(placement: .automatic) {
        Button(String(localized: "Settings"), systemImage: "gearshape") {
          #if os(macOS)
          openSettings()
          #else
          showingParentalGate = true
          #endif
        }
      }
  }

  private func handleGenerationRequest() async {
    guard generationRequested else { return }
    do {
      try await createRequestedStory()
      generationRequested = false
      onContinueReading()
    } catch is CancellationError {
      generationRequested = false
    } catch {
      showGenerationError(error)
    }
  }

  private func createRequestedStory() async throws {
    let provider = StoryGenerationOptionsMapper.provider(from: providerRaw)
    let apiKey = try await generationAPIKey(for: provider)
    try await storyLibrary.generateNextChapter(
      preferences: preferenceStore.storyPreferences,
      options: generationOptions(provider: provider, apiKey: apiKey)
    )
  }

  private func generationAPIKey(for provider: StoryAIProvider) async throws -> String? {
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

  private func showGenerationError(_ error: any Error) {
    generationErrorMessage = error.localizedDescription
    showingGenerationError = true
    generationRequested = false
  }

  private func handleCreateAIStory() {
    if !hasCompletedSetup {
      showingOnboarding = true
    } else {
      generationRequested = true
    }
  }

}
