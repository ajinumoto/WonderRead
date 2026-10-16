import SwiftUI

struct StoryNarrativeSettingsContent: View {
  @Environment(StoryPreferencesStore.self) private var preferenceStore

  var body: some View {
    @Bindable var preferences = preferenceStore

    Section(String(localized: "Story preferences", comment: "Localized app copy.")) {
      StoryChoiceRow(
        title: String(localized: "Writing style", comment: "Localized app copy."),
        selection: $preferences.storyStyle,
        choices: ["Hangat", "Penuh imajinasi", "Lucu"]
      )

      StoryChoiceRow(
        title: String(localized: "Theme", comment: "Localized app copy."),
        selection: $preferences.storyTheme,
        choices: ["Petualangan", "Fantasi", "Kehidupan sehari-hari"]
      )

      StoryChoiceRow(
        title: String(localized: "Moral", comment: "Localized app copy."),
        selection: $preferences.storyMoral,
        choices: ["Berani mencoba", "Saling menolong", "Rasa ingin tahu"]
      )
    }
  }
}
