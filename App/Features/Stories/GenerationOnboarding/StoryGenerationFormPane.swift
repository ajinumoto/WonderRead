import SwiftUI

struct StoryGenerationFormPane: View {
  var form: StoryGenerationFormPanel

  var body: some View {
    ScrollView {
      form
        .padding(28)
        .frame(maxWidth: 540)
        .frame(maxWidth: .infinity)
    }
    .scrollIndicators(.hidden)
  }
}
