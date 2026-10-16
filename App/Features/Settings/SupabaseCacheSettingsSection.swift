import SwiftUI

struct SupabaseCacheSettingsSection: View {
  var body: some View {
    Section {
      Button(role: .destructive, action: clearCache) {
        Label(String(localized: "Clear Curated Library Cache", comment: "Localized app copy."), systemImage: "trash")
      }
    } header: {
      Text(String(localized: "Cache Management", comment: "Localized app copy."))
    } footer: {
      Text(SupabaseConnectionSettingsCopy.cacheFooter).font(.footnote)
    }
  }

  private func clearCache() {
    Task { await SupabaseStoryCache.shared.clear() }
  }
}
