import SwiftUI

struct StoryGenerationOnboardingView: View {
  @Environment(StoryPreferencesStore.self) private var preferenceStore
  @State private var showingSettings = false

  var onFinish: () -> Void

  var body: some View {
    @Bindable var preferences = preferenceStore

    GeometryReader { geometry in
      StoryGenerationLayoutView(
        geometry: geometry,
        welcome: StoryGenerationWelcomeView(compact: !isWideLandscape(geometry)),
        form: storyGenerationForm(preferences: $preferences)
      )
    }
    .background(StoryPalette.page(for: colorScheme))
    #if os(iOS)
    .toolbar { settingsToolbar }
    .sheet(isPresented: $showingSettings) { StoryPreferencesSettingsView().presentationDetents([.large]) }
    #endif
  }

  @Environment(\.colorScheme) private var colorScheme

  private func storyGenerationForm(preferences: Bindable<StoryPreferencesStore>) -> StoryGenerationFormPanel {
    StoryGenerationFormPanel(
      nickname: preferences.nickname,
      childAge: preferences.childAge,
      interests: preferences.interests,
      storyStyle: preferences.storyStyle,
      storyTheme: preferences.storyTheme,
      storyMoral: preferences.storyMoral,
      onFinish: onFinish,
      onSkip: onFinish
    )
  }

  private func isWideLandscape(_ geometry: GeometryProxy) -> Bool {
    geometry.size.width >= 960 && geometry.size.width > geometry.size.height
  }

  #if os(iOS)
  @ToolbarContentBuilder
  private var settingsToolbar: some ToolbarContent {
    ToolbarItem(placement: .topBarTrailing) {
      Button(String(localized: "Settings", comment: "Localized app copy."), systemImage: "gearshape") {
        showingSettings = true
      }
      .accessibilityLabel(String(localized: "Settings", comment: "Localized app copy."))
    }
  }
  #endif
}
