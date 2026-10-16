import SwiftUI

struct StoryGenerationProfileFields: View {
  @Binding var nickname: String
  @Binding var childAge: Int
  @Binding var interests: String

  var body: some View {
    VStack(alignment: .leading, spacing: 14) {
      Text(String(localized: "Reader details (optional)", comment: "Generated story preference section."))
        .font(.caption.weight(.semibold))
        .tracking(1.1)
        .foregroundStyle(.secondary)

      TextField(String(localized: "Nickname (optional)", comment: "Generated story preference field."), text: $nickname)
        .textFieldStyle(.roundedBorder)
        .accessibilityHint(String(localized: "Use a nickname rather than a full name", comment: "Localized app copy."))

      HStack {
        Text(String(localized: "Age", comment: "Localized app copy."))
        Spacer()
        Picker(String(localized: "Age", comment: "Localized app copy."), selection: $childAge) {
          ForEach(3...12, id: \.self) { age in
            Text(String(localized: "\(age) years", comment: "Localized app copy.")).tag(age)
          }
        }
        .labelsHidden()
        .pickerStyle(.menu)
      }

      TextField(String(localized: "Interests, like animals or nature (optional)", comment: "Generated story preference field."), text: $interests)
        .textFieldStyle(.roundedBorder)

    }
  }
}
