import SwiftUI

struct SupabasePreferredLanguagePicker: View {
  @Binding var selection: String

  var body: some View {
    Picker(String(localized: "Default Story Language", comment: "Localized app copy."), selection: $selection) {
      Text("English 🇬🇧").tag("en")
      Text("Bahasa Indonesia 🇮🇩").tag("id")
      Text(String(localized: "All Languages", comment: "Localized app copy.")).tag("all")
    }
    .pickerStyle(.menu)
  }
}
