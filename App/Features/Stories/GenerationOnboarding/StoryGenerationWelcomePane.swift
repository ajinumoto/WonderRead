import SwiftUI

struct StoryGenerationWelcomeViewPane: View {
  var welcome: StoryGenerationWelcomeView

  var body: some View {
    ScrollView {
      welcome
        .padding(32)
        .frame(maxWidth: 480, alignment: .leading)
        .frame(maxWidth: .infinity)
    }
    .scrollIndicators(.hidden)
  }
}
