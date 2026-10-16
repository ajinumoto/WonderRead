import SwiftUI

struct StoryPreferencesSettingsView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.accessibilityReduceMotion) private var reduceMotion
  @Environment(StoryLibrary.self) private var storyLibrary

  @AppStorage("settings.selectedPane") private var selectedPane = StorySettingsTab.curatedLibrary.rawValue
  @State private var showingResetAlert = false
  @State private var showingAppIntroduction = false

  private var currentTab: StorySettingsTab {
    StorySettingsTab(rawValue: selectedPane) ?? .curatedLibrary
  }

  var body: some View {
    settingsContainer
      .background(StoryPalette.page(for: colorScheme).ignoresSafeArea())
      .presentationBackground(StoryPalette.page(for: colorScheme))
      .appIntroductionSheet(isPresented: $showingAppIntroduction)
      .resetStoriesAlert(isPresented: $showingResetAlert, onReset: handleResetStories)
  }

  @ViewBuilder
  private var settingsContainer: some View {
    #if os(macOS)
    macSettings
    #else
    mobileSettings
    #endif
  }

  #if os(macOS)
  private var macSettings: some View {
    TabView(selection: $selectedPane) {
      ForEach(StorySettingsTab.allCases) { tab in
        macTabContent(for: tab)
          .tag(tab.rawValue)
      }
    }
    .tabViewStyle(.automatic)
    .frame(minWidth: 700, idealWidth: 760, minHeight: 520, idealHeight: 600)
  }

  private func macTabContent(for tab: StorySettingsTab) -> some View {
    Form { tabFormContent(for: tab) }
      .formStyle(.grouped)
      .modifier(StorySettingsFormAppearance())
      .navigationTitle(tab.title)
      .tabItem { Label(tab.title, systemImage: tab.icon) }
  }
  #endif

  private var mobileSettings: some View {
    NavigationStack {
      VStack(spacing: 0) {
        segmentedSectionPicker
        mobileFormContent
      }
      .navigationTitle(String(localized: "Settings", comment: "Localized app copy."))
      #if os(iOS)
      .navigationBarTitleDisplayMode(.inline)
      #endif
      .toolbar { doneToolbarItem }
      .background(StoryPalette.page(for: colorScheme).ignoresSafeArea())
    }
  }

  private var segmentedSectionPicker: some View {
    Picker(String(localized: "Settings Section", comment: "Localized app copy."), selection: $selectedPane) {
      ForEach(StorySettingsTab.allCases) { tab in
        Label(tab.title, systemImage: tab.icon)
          .tag(tab.rawValue)
      }
    }
    .pickerStyle(.segmented)
    .padding(.horizontal, 16)
    .padding(.top, 8)
    .padding(.bottom, 12)
  }

  private var mobileFormContent: some View {
    Form { tabFormContent(for: currentTab) }
      .modifier(StorySettingsFormAppearance())
  }

  @ToolbarContentBuilder
  private var doneToolbarItem: some ToolbarContent {
    ToolbarItem(placement: .confirmationAction) {
      Button(String(localized: "Done", comment: "Localized app copy.")) {
        dismiss()
      }
    }
  }

  @ViewBuilder
  private func tabFormContent(for tab: StorySettingsTab) -> some View {
    switch tab {
    case .computationalLiterature:
      StoryProfileSettingsContent()
      StoryNarrativeSettingsContent()
      StoryAISettingsContent()
      resetSection
    case .curatedLibrary:
      StorySupabaseSettingsContent()
      appIntroductionSection
    }
  }

  @ViewBuilder
  private var appIntroductionSection: some View {
    Section(String(localized: "Learn WonderRead", comment: "Settings section for app introduction.")) {
      Button(String(localized: "View app introduction", comment: "Reopens the optional app introduction."), systemImage: "book.closed.fill") {
        showingAppIntroduction = true
      }
      .accessibilityHint(String(localized: "Opens the WonderRead introduction again.", comment: "Settings action hint."))
    }
  }

  @ViewBuilder
  private var resetSection: some View {
    Section(String(localized: "Manage Stories", comment: "Localized app copy.")) {
      Button(role: .destructive) {
        showingResetAlert = true
      } label: {
        Label(
          String(localized: "Reset All Stories", comment: "Localized app copy."),
          systemImage: "trash"
        )
      }
      .disabled(storyLibrary.chapters.isEmpty)
    }
  }

  private func handleResetStories() {
    withAnimation(reduceMotion ? nil : .smooth) {
      storyLibrary.resetAllChapters()
    }
  }
}

private struct AppIntroductionSheetModifier: ViewModifier {
  @Binding var isPresented: Bool

  func body(content: Content) -> some View {
    content.sheet(isPresented: $isPresented) {
      AppOnboardingView(action: .done) { isPresented = false }
      #if os(iOS)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
      #else
        .frame(minWidth: 520, minHeight: 600)
      #endif
    }
  }
}

private struct ResetStoriesAlertModifier: ViewModifier {
  @Binding var isPresented: Bool
  let onReset: () -> Void

  func body(content: Content) -> some View {
    content.alert(
      String(localized: "Reset All Stories?", comment: "Localized app copy."),
      isPresented: $isPresented
    ) {
      Button(String(localized: "Reset All Stories", comment: "Localized app copy."), role: .destructive, action: onReset)
      Button(String(localized: "Cancel", comment: "Localized app copy."), role: .cancel) {}
    } message: {
      Text(String(localized: "All saved stories and illustrations will be deleted. The bookshelf will start fresh like new.", comment: "Localized app copy."))
    }
  }
}

private extension View {
  func appIntroductionSheet(isPresented: Binding<Bool>) -> some View {
    modifier(AppIntroductionSheetModifier(isPresented: isPresented))
  }

  func resetStoriesAlert(isPresented: Binding<Bool>, onReset: @escaping () -> Void) -> some View {
    modifier(ResetStoriesAlertModifier(isPresented: isPresented, onReset: onReset))
  }
}
