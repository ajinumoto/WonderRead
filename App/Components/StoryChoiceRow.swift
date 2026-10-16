import SwiftUI

struct StoryChoiceRow: View {
  var title: String
  @Binding var selection: String
  var choices: [String]

  var body: some View {
    HStack {
      Text(title)
        .font(.body)

      Spacer(minLength: 12)

      Picker(title, selection: $selection) {
        ForEach(choices, id: \.self) { choice in
          Text(StoryPreferenceLabel.localized(choice)).tag(choice)
        }
      }
      .labelsHidden()
      .pickerStyle(.menu)
      .accessibilityLabel(title)
    }
  }
}
