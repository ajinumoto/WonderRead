import SwiftUI

struct AppOnboardingContent: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 22) {
      AppOnboardingArtwork()
      welcomeSection
      curatedFeatureRow
      AppOnboardingStoryLanguagePicker()
      privacySection
    }
  }

  private var welcomeSection: some View {
    AppOnboardingWelcomeSection(
      headline: AppOnboardingDataMapper.welcomeHeadline(),
      subheadline: AppOnboardingDataMapper.welcomeSubheadline()
    )
  }

  private var curatedFeatureRow: some View {
    AppOnboardingFeatureRow(
      symbol: "books.vertical.fill",
      title: AppOnboardingDataMapper.curatedStoriesFeatureTitle(),
      detail: AppOnboardingDataMapper.curatedStoriesFeatureDetail()
    )
  }

  private var privacySection: some View {
    AppOnboardingPrivacyCard(
      items: AppOnboardingDataMapper.privacyItems()
    )
  }
}
