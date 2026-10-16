import SwiftUI

struct StorySupabaseSettingsContent: View {
  @AppStorage(SupabaseConfiguration.urlDefaultsKey) private var projectURL = ""
  @AppStorage("supabase.preferredLanguage") private var preferredLanguage = "en"
  @State private var anonKey = SupabaseConfiguration.anonKey

  var body: some View {
    Group {
      SupabaseConnectionSettingsSection(
        projectURL: $projectURL,
        anonKey: Binding(
          get: { anonKey },
          set: {
            anonKey = $0
            SupabaseConfiguration.anonKey = $0
          }
        ),
        preferredLanguage: $preferredLanguage,
        isConfigured: SupabaseConfiguration.isConfigured,
        onClearCredentials: clearCredentials
      )
      SupabaseCacheSettingsSection()
    }
    .onAppear {
      anonKey = SupabaseConfiguration.anonKey
    }
  }

  private func clearCredentials() {
    projectURL = ""
    anonKey = ""
    SupabaseConfiguration.anonKey = ""
    Task { await SupabaseStoryCache.shared.clear() }
  }
}
