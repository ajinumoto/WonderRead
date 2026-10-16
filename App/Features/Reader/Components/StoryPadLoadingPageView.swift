import SwiftUI

struct StoryPadLoadingPageView: View {
  @Environment(\.colorScheme) private var colorScheme
  var isGenerating: Bool
  var errorMessage: String?
  var onRetry: () -> Void

  var body: some View {
    GeometryReader { geometry in
      HStack(spacing: 0) {
        StoryIllustrationShimmer()
          .frame(width: max(geometry.size.width * 0.33, 200))
          .frame(maxHeight: .infinity)
          .clipped()

        StoryLoadingCopy(
          isGenerating: isGenerating,
          errorMessage: errorMessage,
          onRetry: onRetry
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(36)
        .background(StoryPalette.surface(for: colorScheme))
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(StoryPalette.surface(for: colorScheme))
    }
  }
}
