import SwiftUI

struct StoryLoadingPage: View {
  @Environment(\.colorScheme) private var colorScheme
  var errorMessage: String?
  var onRetry: () -> Void

  var body: some View {
    GeometryReader { geometry in
      ScrollView {
        VStack(spacing: 0) {
          StoryIllustrationShimmer()
            .frame(height: max(250, geometry.size.height * 0.42))

          StoryLoadingCopy(
            isGenerating: errorMessage == nil,
            errorMessage: errorMessage,
            onRetry: onRetry
          )
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(28)
          .safeAreaPadding(.horizontal)
          .safeAreaPadding(.bottom)
        }
      }
      .scrollIndicators(.hidden)
      .background(StoryPalette.surface(for: colorScheme))
    }
  }
}
