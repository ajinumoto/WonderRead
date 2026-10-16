import SwiftUI

struct StoryGenerationFormPanel: View {
  @Environment(\.colorScheme) private var colorScheme
  @Binding var nickname: String
  @Binding var childAge: Int
  @Binding var interests: String
  @Binding var storyStyle: String
  @Binding var storyTheme: String
  @Binding var storyMoral: String
  var onFinish: () -> Void
  var onSkip: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 22) {
      VStack(alignment: .leading, spacing: 6) {
        Text(String(localized: "Personalize a generated story", comment: "Generated story onboarding headline."))
          .font(.system(.title2, design: .serif))

        Text(String(localized: "Add a few details if you like. Every field is optional.", comment: "Generated story onboarding description."))
          .font(.subheadline)
          .foregroundStyle(.secondary)
      }

      StoryGenerationProfileFields(nickname: $nickname, childAge: $childAge, interests: $interests)

      Divider()

      StoryGenerationPreferencesFields(
        storyStyle: $storyStyle,
        storyTheme: $storyTheme,
        storyMoral: $storyMoral
      )

      Text(String(localized: "These preferences stay on this device and can be changed in Settings.", comment: "Generated story onboarding privacy description."))
        .font(.footnote)
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)

      Button(action: onFinish) {
        HStack(spacing: 10) {
          Text(String(localized: "Create story", comment: "Starts generating a story from the selected preferences."))
          Image(systemName: "arrow.right")
        }
        .font(.body.weight(.semibold))
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
      }
      .buttonStyle(.borderedProminent)
      .accessibilityHint(String(localized: "Saves your preferences and starts story generation.", comment: "Generated story onboarding action hint."))

      Button(String(localized: "Skip personalization", comment: "Skips optional generated story preferences."), action: onSkip)
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }
    .padding(24)
    .background(StoryPalette.surface(for: colorScheme), in: RoundedRectangle(cornerRadius: 26, style: .continuous))
    .overlay {
      RoundedRectangle(cornerRadius: 26, style: .continuous)
        .stroke(StoryPalette.line(for: colorScheme), lineWidth: 1)
    }
  }
}
