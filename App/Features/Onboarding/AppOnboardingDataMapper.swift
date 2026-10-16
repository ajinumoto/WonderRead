import Foundation

struct AppOnboardingPrivacyItem: Identifiable, Sendable, Equatable {
  let id: String
  let icon: String
  let title: String
  let detail: String
}

enum AppOnboardingDataMapper {
  static func privacyItems() -> [AppOnboardingPrivacyItem] {
    [
      onDeviceStorageItem(),
      noTrackingItem(),
      familySafeItem()
    ]
  }

  static func welcomeHeadline() -> String {
    String(
      localized: "Welcome to WonderRead",
      comment: "Headline for the main app onboarding."
    )
  }

  static func welcomeSubheadline() -> String {
    String(
      localized: "Immerse in timeless folklore, fables, and cultural tales curated for mindful reading.",
      comment: "Subheadline describing the curated story reading experience in app onboarding."
    )
  }

  static func curatedStoriesFeatureTitle() -> String {
    String(
      localized: "Curated collections",
      comment: "App introduction feature."
    )
  }

  static func curatedStoriesFeatureDetail() -> String {
    String(
      localized: "Folklore and fables, ready to explore.",
      comment: "App introduction feature description."
    )
  }

  private static func onDeviceStorageItem() -> AppOnboardingPrivacyItem {
    AppOnboardingPrivacyItem(
      id: "on-device-storage",
      icon: "internaldrive",
      title: String(
        localized: "Stored on Your Device",
        comment: "Privacy commitment: reading progress and preferences remain local."
      ),
      detail: String(
        localized: "Your story preferences, bookmarks, and reading history are saved securely on this device.",
        comment: "Privacy commitment detail for on-device storage."
      )
    )
  }

  private static func noTrackingItem() -> AppOnboardingPrivacyItem {
    AppOnboardingPrivacyItem(
      id: "no-tracking",
      icon: "hand.raised.fill",
      title: String(
        localized: "Zero Tracking & No Ads",
        comment: "Privacy commitment: no third-party tracking or advertising."
      ),
      detail: String(
        localized: "We do not track your reading habits, sell your data, or serve third-party advertisements.",
        comment: "Privacy commitment detail for no tracking."
      )
    )
  }

  private static func familySafeItem() -> AppOnboardingPrivacyItem {
    AppOnboardingPrivacyItem(
      id: "family-safe",
      icon: "shield.lefthalf.filled",
      title: String(
        localized: "Family-Safe & Private",
        comment: "Privacy commitment: safe reading environment."
      ),
      detail: String(
        localized: "Curated stories are wholesome and created to provide a calm, protected literary sanctuary.",
        comment: "Privacy commitment detail for family safety."
      )
    )
  }
}
