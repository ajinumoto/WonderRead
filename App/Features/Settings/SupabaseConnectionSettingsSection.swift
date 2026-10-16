import SwiftUI

struct SupabaseConnectionSettingsSection: View {
  @Binding var projectURL: String
  @Binding var anonKey: String
  @Binding var preferredLanguage: String
  var isConfigured: Bool
  var onClearCredentials: () -> Void

  var body: some View {
    Section {
      SupabasePreferredLanguagePicker(selection: $preferredLanguage)
      SupabaseCredentialFields(projectURL: $projectURL, anonKey: $anonKey)
      SupabaseConnectionStatusRow(
        isConfigured: isConfigured,
        hasCredentials: !projectURL.isEmpty || !anonKey.isEmpty,
        onClear: onClearCredentials
      )
    } header: {
      Text(String(localized: "Curated Library Server", comment: "Localized app copy."))
    } footer: {
      Text(SupabaseConnectionSettingsCopy.footer).font(.footnote)
    }
  }
}
