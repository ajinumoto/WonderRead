import SwiftUI

struct StoryLoadingSpread: View {
  @Environment(\.colorScheme) private var colorScheme
  var isGenerating: Bool
  var errorMessage: String?
  var spineIntensity: Double = 1.0
  var onRetry: () -> Void

  var body: some View {
    StorySpreadPage(
      illustrationPage: StoryIllustrationShimmer(),
      storyPage: StoryLoadingCopy(
        isGenerating: isGenerating,
        errorMessage: errorMessage,
        onRetry: onRetry
      )
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .padding(36)
      .background(StoryPalette.surface(for: colorScheme)),
      spineIntensity: spineIntensity
    )
  }
}
