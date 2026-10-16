import SwiftUI

struct StoryProfileSettingsContent: View {
  @Environment(StoryPreferencesStore.self) private var preferenceStore

  var body: some View {
    @Bindable var preferences = preferenceStore

    Section(String(localized: "Child profile", comment: "Localized app copy.")) {
      TextField(String(localized: "Nickname", comment: "Localized app copy."), text: $preferences.nickname)

      Picker(String(localized: "Age", comment: "Localized app copy."), selection: $preferences.childAge) {
        ForEach(3...12, id: \.self) { age in
          Text(String(localized: "\(age) years", comment: "Localized app copy.")).tag(age)
        }
      }
      .pickerStyle(.menu)

      TextField(
        String(localized: "Interests", comment: "Localized app copy."),
        text: $preferences.interests,
        prompt: Text(String(localized: "Animals, nature, space…", comment: "Localized app copy."))
      )
    }
  }
}
