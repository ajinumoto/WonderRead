import SwiftUI

struct AppOnboardingStoryLanguagePicker: View {
  @AppStorage("supabase.preferredLanguage") private var selectedLanguage = "en"
  @AppStorage("ai.gemini.storyLanguage") private var geminiStoryLanguage = StoryGeminiLanguages.defaultLanguage
  @Environment(\.colorScheme) private var colorScheme

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      headerRow
      pickerControl
    }
    .padding(16)
    .background(StoryPalette.surface(for: colorScheme), in: RoundedRectangle(cornerRadius: 16))
    .overlay {
      RoundedRectangle(cornerRadius: 16)
        .stroke(StoryPalette.line(for: colorScheme), lineWidth: 1)
    }
    .onChange(of: selectedLanguage) { _, newValue in
      syncGeminiLanguage(with: newValue)
    }
  }

  private var headerRow: some View {
    HStack(alignment: .top, spacing: 14) {
      globeIcon
      titleColumn
    }
  }

  private var globeIcon: some View {
    Image(systemName: "globe")
      .font(.headline)
      .foregroundStyle(StoryPalette.accent)
      .frame(width: 40, height: 40)
      .background(StoryPalette.page(for: colorScheme), in: RoundedRectangle(cornerRadius: 12))
      .symbolEffect(.bounce, value: selectedLanguage)
      .accessibilityHidden(true)
  }

  private var titleColumn: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(String(localized: "Curated Story Language", comment: "App introduction story language section title."))
        .font(.headline)

      Text(String(localized: "Choose your preferred language for reading curated stories.", comment: "App introduction story language description."))
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
    }
  }

  private var pickerControl: some View {
    Picker(
      String(localized: "Curated Story Language", comment: "App introduction story language section title."),
      selection: $selectedLanguage
    ) {
      Text("English 🇬🇧").tag("en")
      Text("Bahasa Indonesia 🇮🇩").tag("id")
    }
    .pickerStyle(.segmented)
  }

  private func syncGeminiLanguage(with languageCode: String) {
    if languageCode == "id" {
      geminiStoryLanguage = StoryGeminiLanguages.allLanguages().first(where: {
        $0.localizedCaseInsensitiveContains("indonesia")
      }) ?? "Indonesian"
    } else {
      geminiStoryLanguage = StoryGeminiLanguages.defaultLanguage
    }
  }
}
