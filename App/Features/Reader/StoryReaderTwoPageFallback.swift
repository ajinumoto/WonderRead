import SwiftUI

struct StoryReaderTwoPageFallback: View {
  @Environment(\.colorScheme) private var colorScheme
  var illustrationPage: StoryIllustrationPage
  var storyPage: StoryTextPage

  var body: some View {
    HStack(spacing: 0) {
      illustrationPage
        .frame(maxHeight: .infinity)
        .overlay(alignment: .trailing) {
          BookSpineShadow(edge: .trailing)
        }
      storyPage
        .frame(maxHeight: .infinity)
    }
    .frame(maxWidth: 1400)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(StoryPalette.surface(for: colorScheme))
  }
}
