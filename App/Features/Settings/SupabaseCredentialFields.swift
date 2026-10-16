import SwiftUI

struct SupabaseCredentialFields: View {
  @Binding var projectURL: String
  @Binding var anonKey: String

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      urlField
      keyField
    }
    .padding(.vertical, 2)
  }

  private var urlField: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text(String(localized: "Supabase Project URL", comment: "Localized app copy."))
        .font(.subheadline.weight(.medium))
      TextField("https://your-project.supabase.co", text: $projectURL)
        .textFieldStyle(.roundedBorder)
        .autocorrectionDisabled()
        #if os(iOS)
        .textInputAutocapitalization(.never)
        .keyboardType(.URL)
        #endif
    }
  }

  private var keyField: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text(String(localized: "Supabase Anon Key", comment: "Localized app copy."))
        .font(.subheadline.weight(.medium))
      SecureField("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...", text: $anonKey)
        .textFieldStyle(.roundedBorder)
        .autocorrectionDisabled()
        #if os(iOS)
        .textInputAutocapitalization(.never)
        #endif
    }
  }
}
