import SwiftUI

struct StoryGenerationSideBySide: View {
  @Environment(\.colorScheme) private var colorScheme
  var welcome: StoryGenerationWelcomeView
  var form: StoryGenerationFormPanel

  var body: some View {
    HStack(alignment: .center, spacing: 36) {
      ScrollView {
        welcome
          .padding(36)
          .frame(maxWidth: 430, alignment: .leading)
          .frame(maxWidth: .infinity)
      }
      .scrollIndicators(.hidden)

      ScrollView {
        form
          .padding(28)
          .frame(maxWidth: 560)
          .frame(maxWidth: .infinity)
      }
      .scrollIndicators(.hidden)
    }
    .frame(maxWidth: 1080)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(StoryPalette.page(for: colorScheme))
  }
}
