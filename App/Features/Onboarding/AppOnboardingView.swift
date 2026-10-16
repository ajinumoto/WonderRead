import SwiftUI

struct AppOnboardingView: View {
  var action: AppOnboardingAction = .exploreCuratedStories
  var onFinish: () -> Void

  var body: some View {
    VStack(spacing: 0) {
      AppOnboardingHeader(onSkip: onFinish)
      onboardingContent
      AppOnboardingFooter(action: action, onFinish: onFinish)
    }
    .background(StoryPalette.page(for: colorScheme).ignoresSafeArea())
  }

  @Environment(\.colorScheme) private var colorScheme

  private var onboardingContent: some View {
    ScrollView {
      AppOnboardingContent()
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .frame(maxWidth: 520)
        .frame(maxWidth: .infinity)
    }
    .scrollIndicators(.hidden)
  }
}
