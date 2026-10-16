import SwiftUI

struct CreateFirstStoryCard: View {
  @Environment(\.colorScheme) private var colorScheme
  var isGenerating: Bool
  var onCreate: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 18) {
      Image(systemName: "sparkles")
        .font(.title2)
        .foregroundStyle(StoryPalette.clay)
        .frame(width: 52, height: 52)
        .background(StoryPalette.clay.opacity(0.12), in: Circle())

      Text(String(localized: "Your first story starts here", comment: "Localized app copy."))
        .font(.system(.title, design: .serif))
        .fixedSize(horizontal: false, vertical: true)

      Text(String(localized: "Computational Literature will craft the first chapter and illustration from your preferences.", comment: "Localized app copy."))
        .font(.body)
        .foregroundStyle(.secondary)

      Button(action: onCreate) {
        HStack(spacing: 10) {
          if isGenerating {
            ProgressView().tint(StoryPalette.accent)
            Text(String(localized: "Writing your story…", comment: "Localized app copy."))
          } else {
            Label(String(localized: "Create Computational Literature Story", comment: "Localized app copy."), systemImage: "sparkles")
          }
        }
        .font(.body.weight(.semibold))
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
      }
      .buttonStyle(.borderedProminent)
      #if os(iOS)
      .hoverEffect(.lift)
      #endif
      .disabled(isGenerating)
    }
    .padding(26)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(StoryPalette.surface(for: colorScheme), in: RoundedRectangle(cornerRadius: 26, style: .continuous))
    .overlay {
      RoundedRectangle(cornerRadius: 26, style: .continuous)
        .stroke(StoryPalette.line(for: colorScheme), lineWidth: 1)
    }
  }
}
