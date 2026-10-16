import SwiftUI

struct SupabaseConnectionStatusRow: View {
  var isConfigured: Bool
  var hasCredentials: Bool
  var onClear: () -> Void

  var body: some View {
    HStack {
      statusLabel
      Spacer()
      if hasCredentials {
        Button(String(localized: "Clear", comment: "Localized app copy."), action: onClear).font(.caption)
      }
    }
  }

  private var statusLabel: some View {
    Label(
      isConfigured
        ? String(localized: "Connected to Supabase", comment: "Localized app copy.")
        : String(localized: "Using Local Seed (Offline)", comment: "Localized app copy."),
      systemImage: isConfigured ? "checkmark.circle.fill" : "info.circle"
    )
    .font(.caption)
    .foregroundStyle(isConfigured ? .green : .secondary)
  }
}
