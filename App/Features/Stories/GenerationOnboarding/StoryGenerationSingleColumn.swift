import SwiftUI

struct StoryGenerationSingleColumn: View {
  var welcome: StoryGenerationWelcomeView
  var form: StoryGenerationFormPanel
  var width: CGFloat

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 32) {
        welcome
        form
      }
      .padding(.horizontal, horizontalInset(for: width))
      .padding(.vertical, 32)
      .frame(maxWidth: 600)
      .frame(maxWidth: .infinity)
    }
    .scrollIndicators(.hidden)
  }

  private func horizontalInset(for width: CGFloat) -> CGFloat {
    max(20, min(36, (width - 600) / 2))
  }
}
