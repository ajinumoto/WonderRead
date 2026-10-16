import Foundation

enum SupabaseConnectionSettingsCopy {
  static let footer = String(localized: "Curated story collections are retrieved from the curated library server. Story illustrations are loaded via high-speed CDN.", comment: "Localized app copy.")

  static let cacheFooter = String(localized: "Story collections are cached locally based on version numbers in Supabase. Clearing cache will force the app to re-fetch latest story versions when the shelf is reopened.", comment: "Localized app copy.")
}
