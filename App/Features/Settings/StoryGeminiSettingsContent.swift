import SwiftUI

struct StoryGeminiSettingsContent: View {
  @AppStorage("ai.gemini.storyLanguage") private var storyLanguage = StoryGeminiLanguages.defaultLanguage
  @AppStorage("ai.gemini.storyModel") private var modelID = StoryGeminiModel.defaultModelID
  @AppStorage("ai.gemini.storyModelOutputLimit") private var outputTokenLimit = 65536

  var body: some View {
    Group {
      Section(String(localized: "Model & Language", comment: "Localized app copy.")) {
        Picker(String(localized: "Story language", comment: "Localized app copy."), selection: $storyLanguage) {
          ForEach(StoryGeminiLanguages.allLanguages(), id: \.self) { language in
            Text(language).tag(language)
          }
        }
        Picker(String(localized: "Gemini model", comment: "Localized app copy."), selection: $modelID) {
          ForEach(StoryGeminiModel.availableModels) { model in
            Text(model.title).tag(model.modelID)
          }
        }

        LabeledContent(
          String(localized: "Illustration model", comment: "Localized app copy."),
          value: "Nano Banana 2"
        )
      }

      Section(String(localized: "API key", comment: "Localized app copy.")) {
        StoryGeminiAPIKeyControl()
      }

      Section(String(localized: "Privacy and usage", comment: "Localized app copy.")) {
        Text(String(localized: "When Gemini is selected, the nickname, age, interests, preferences, and story idea are sent to Google to create story text and illustrations.", comment: "Localized app copy."))
        .fixedSize(horizontal: false, vertical: true)

        Text(String(localized: "Image generation note: The Gemini API free tier does not support image generation. Generating illustrations requires a Google AI account with active billing (Pay-as-you-go). Text stories can still be generated for free.", comment: "Localized app copy."))
        .font(.footnote)
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)

        Text(String(localized: "Gemini usage follows your Google account's quota or billing.", comment: "Localized app copy."))
        .foregroundStyle(.secondary)
      }
    }
    .onAppear {
      normalizeModelIfNeeded()
    }
    .onChange(of: modelID) { _, newModelID in
      outputTokenLimit = StoryGeminiModel.availableModels.first(where: { $0.modelID == newModelID })?.outputTokenLimit ?? 65536
    }
  }

  private func normalizeModelIfNeeded() {
    if !StoryGeminiModel.availableModels.contains(where: { $0.modelID == modelID }) {
      modelID = StoryGeminiModel.defaultModelID
      outputTokenLimit = 65536
    }
  }
}
