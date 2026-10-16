import SwiftUI

struct StoryLocalAISettingsContent: View {
  var status: StoryLocalAIStatus

  var body: some View {
    Section(String(localized: "Apple Intelligence", comment: "Localized app copy.")) {
      Label(status.message, systemImage: "sparkles")
        .fixedSize(horizontal: false, vertical: true)

      Text(String(localized: "Apple's on-device AI creates story text only. It doesn't generate illustrations with this method. Model availability and safety checks follow Apple's built-in support; the app can't enable or bypass device, region, language, or system-service requirements.", comment: "Localized app copy."))
      .foregroundStyle(.secondary)
      .fixedSize(horizontal: false, vertical: true)

      Text(String(localized: "To enable Apple Intelligence, open System Settings > Apple Intelligence & Siri, turn it on, and wait for the model to download. Connect to Wi-Fi and power. Apple must support the device, region, and device and Siri languages.", comment: "Localized app copy."))
      .foregroundStyle(.secondary)
      .fixedSize(horizontal: false, vertical: true)
    }
  }
}
