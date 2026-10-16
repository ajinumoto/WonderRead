import SwiftUI

struct StoryAISettingsContent: View {
  @AppStorage("ai.provider") private var providerRaw = StoryAIProvider.local.rawValue
  @Environment(\.scenePhase) private var scenePhase
  @State private var localAIStatus = StoryLocalAIStatus.current

  var body: some View {
    Group {
      Section(String(localized: "Computational Literature Engine", comment: "Localized app copy.")) {
        Picker(String(localized: "Create stories with", comment: "Localized app copy."), selection: $providerRaw) {
          Text(String(localized: "On-device", comment: "Localized app copy."))
            .tag(StoryAIProvider.local.rawValue)
          Text("Gemini")
            .tag(StoryAIProvider.gemini.rawValue)
        }
        .pickerStyle(.segmented)
      }

      if providerRaw == StoryAIProvider.local.rawValue {
        StoryLocalAISettingsContent(status: localAIStatus)
      } else {
        StoryGeminiSettingsContent()
      }
    }
    .task {
      localAIStatus = StoryLocalAIStatus.current
    }
    .onChange(of: scenePhase) { _, phase in
      if phase == .active {
        localAIStatus = StoryLocalAIStatus.current
      }
    }
  }
}
