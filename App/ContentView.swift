import SwiftUI

struct ContentView: View {
  @Environment(StoryLibrary.self) private var storyLibrary
  @AppStorage("onboarding.app.completed") private var hasCompletedAppOnboarding = false
  @State private var navigationPath: [StoryAppRoute] = []
  @State private var showingAppOnboarding = false
  @State private var showingSwitchConfirmation = false
  @State private var showingSwitchedSuccess = false
  @State private var pendingRepoPayload: SupabaseRepoPayload?
  @State private var installedRepoName = ""

  var body: some View {
    NavigationStack(path: $navigationPath) {
      shelfView
        .navigationDestination(for: StoryAppRoute.self, destination: destinationView)
        .tint(StoryPalette.accent)
    }
    .appOnboardingSheet(isPresented: $showingAppOnboarding, onDismiss: markAppOnboardingComplete)
    .confirmRepoSwitchAlert(
      isPresented: $showingSwitchConfirmation,
      payload: pendingRepoPayload,
      onConfirm: confirmRepositorySwitch,
      onCancel: cancelRepositorySwitch
    )
    .repoSwitchedAlert(isPresented: $showingSwitchedSuccess, repoName: installedRepoName)
    .onAppear(perform: showAppOnboardingIfNeeded)
    .onOpenURL(perform: handleIncomingURL)
  }

  private var shelfView: some View {
    StoryShelfView(
      onContinueReading: openLatestStory,
      onOpenHistory: { navigationPath.append(.history) },
      onOpenCollection: { collection in
        navigationPath.append(.collectionReader(collection, initialChapterID: nil))
      },
      onOpenCuratedChapter: { collection, chapterID in
        navigationPath.append(.collectionReader(collection, initialChapterID: chapterID))
      }
    )
  }

  @ViewBuilder
  private func destinationView(for route: StoryAppRoute) -> some View {
    switch route {
    case .history:
      StoryHistoryListView { navigationPath.append(.reader($0)) }
    case .reader(let chapterID):
      StoryReaderView(initialChapterID: chapterID) { navigationPath.removeAll() }
    case .collectionReader(let collection, let initialChapterID):
      StoryReaderView(collection: collection, initialChapterID: initialChapterID) {
        navigationPath.removeAll()
      }
    }
  }

  private func showAppOnboardingIfNeeded() {
    guard !hasCompletedAppOnboarding else { return }
    showingAppOnboarding = true
  }

  private func markAppOnboardingComplete() {
    hasCompletedAppOnboarding = true
  }

  private func openLatestStory() {
    guard let chapter = storyLibrary.latestChapter else { return }
    navigationPath.append(.reader(chapter.id))
  }

  private func handleIncomingURL(_ url: URL) {
    guard let payload = SupabaseRepoDeepLinkMapper.parse(url: url) else { return }
    guard SupabaseConfiguration.isConfigured(projectURL: payload.projectURL, anonKey: payload.anonKey) else {
      return
    }
    pendingRepoPayload = payload
    showingSwitchConfirmation = true
  }

  private func confirmRepositorySwitch(_ payload: SupabaseRepoPayload) {
    SupabaseConfiguration.projectURL = payload.projectURL
    SupabaseConfiguration.anonKey = payload.anonKey
    pendingRepoPayload = nil
    showingSwitchConfirmation = false
    Task {
      await SupabaseStoryCache.shared.clear()
      installedRepoName = payload.repoName
      showingSwitchedSuccess = true
    }
  }

  private func cancelRepositorySwitch() {
    pendingRepoPayload = nil
    showingSwitchConfirmation = false
  }
}
