import SwiftUI

struct StoryGenerationPreferencesFields: View {
  @Binding var storyStyle: String
  @Binding var storyTheme: String
  @Binding var storyMoral: String

  var body: some View {
    VStack(alignment: .leading, spacing: 14) {
      Text(String(localized: "Story preferences (optional)", comment: "Generated story preference section."))
        .font(.caption.weight(.semibold))
        .tracking(1.1)
        .foregroundStyle(.secondary)

      StoryChoiceRow(
        title: String(localized: "Writing style", comment: "Localized app copy."),
        selection: $storyStyle,
        choices: ["Hangat", "Penuh imajinasi", "Lucu"]
      )

      StoryChoiceRow(
        title: String(localized: "Theme", comment: "Localized app copy."),
        selection: $storyTheme,
        choices: ["Petualangan", "Fantasi", "Kehidupan sehari-hari"]
      )

      StoryChoiceRow(
        title: String(localized: "Moral", comment: "Localized app copy."),
        selection: $storyMoral,
        choices: ["Berani mencoba", "Saling menolong", "Rasa ingin tahu"]
      )
    }
  }
}
