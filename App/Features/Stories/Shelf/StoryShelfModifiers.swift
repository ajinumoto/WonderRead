import SwiftUI

struct StoryShelfSheetsModifier: ViewModifier {
  @Binding var showingParentalGate: Bool
  @Binding var showingSettings: Bool
  @Binding var showingOnboarding: Bool
  @Binding var hasCompletedSetup: Bool
  @Binding var generationRequested: Bool
  let storyLibrary: StoryLibrary

  func body(content: Content) -> some View {
    content
      #if os(iOS)
      .sheet(isPresented: $showingParentalGate) {
        ParentalGateView { showingSettings = true }
      }
      .sheet(isPresented: $showingSettings) {
        StoryPreferencesSettingsView()
          .environment(storyLibrary)
          .presentationDetents([.large])
      }
      #endif
      .sheet(isPresented: $showingOnboarding) {
        generationOnboardingView
      }
  }

  private var generationOnboardingView: some View {
    StoryGenerationOnboardingView {
      hasCompletedSetup = true
      showingOnboarding = false
      generationRequested = true
    }
    #if os(iOS)
    .presentationDetents([.large])
    #endif
  }
}

struct StoryGenerationErrorAlertModifier: ViewModifier {
  @Binding var isPresented: Bool
  let errorMessage: String

  func body(content: Content) -> some View {
    content.alert(
      String(localized: "Couldn't create story", comment: "Generation failure alert title"),
      isPresented: $isPresented
    ) {
      Button(String(localized: "OK", comment: "Dismiss button"), role: .cancel) {}
    } message: {
      Text(errorMessage)
    }
  }
}

extension View {
  func shelfSheets(
    showingParentalGate: Binding<Bool>,
    showingSettings: Binding<Bool>,
    showingOnboarding: Binding<Bool>,
    hasCompletedSetup: Binding<Bool>,
    generationRequested: Binding<Bool>,
    storyLibrary: StoryLibrary
  ) -> some View {
    modifier(StoryShelfSheetsModifier(
      showingParentalGate: showingParentalGate,
      showingSettings: showingSettings,
      showingOnboarding: showingOnboarding,
      hasCompletedSetup: hasCompletedSetup,
      generationRequested: generationRequested,
      storyLibrary: storyLibrary
    ))
  }

  func generationErrorAlert(
    isPresented: Binding<Bool>,
    errorMessage: String
  ) -> some View {
    modifier(StoryGenerationErrorAlertModifier(
      isPresented: isPresented,
      errorMessage: errorMessage
    ))
  }
}
