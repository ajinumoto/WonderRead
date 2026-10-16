import SwiftUI

struct StoryGeminiAPIKeyControl: View {
  var onKeySaved: ((String) -> Void)? = nil
  var onKeyDeleted: (() -> Void)? = nil

  @State private var keyInput = ""
  @State private var isShowingKey = false
  @State private var hasSavedKey = false
  @State private var isEditing = false
  @State private var isWorking = false
  @State private var errorMessage: String?

  var body: some View {
    Group {
      if hasSavedKey && !isEditing {
        savedView
      } else {
        editorView
      }
    }
    .task {
      await loadSavedKeyStatus()
    }
  }

  // MARK: - Setelah API Key Di-set (Simple & Clean)
  private var savedView: some View {
    HStack(spacing: 12) {
      Label(
        String(localized: "API Key Active", comment: "Localized app copy."),
        systemImage: "checkmark.circle.fill"
      )
      .foregroundStyle(.green)
      .font(.subheadline.weight(.medium))

      Spacer(minLength: 8)

      Button(String(localized: "Change", comment: "Localized app copy.")) {
        keyInput = ""
        isEditing = true
        errorMessage = nil
      }
      .buttonStyle(.bordered)
      .controlSize(.small)

      Button(role: .destructive) {
        deleteKey()
      } label: {
        Image(systemName: "trash")
      }
      .buttonStyle(.bordered)
      .controlSize(.small)
      .tint(.red)
      .accessibilityLabel(String(localized: "Delete API Key", comment: "Localized app copy."))
    }
  }

  // MARK: - Sebelum API Key Di-set / Sedang Ganti (Simple & Clean)
  private var editorView: some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack(spacing: 8) {
        Group {
          if isShowingKey {
            TextField(String(localized: "Paste Gemini API key", comment: "Localized app copy."), text: $keyInput)
          } else {
            SecureField(String(localized: "Paste Gemini API key", comment: "Localized app copy."), text: $keyInput)
          }
        }
        .textContentType(.password)
        .autocorrectionDisabled()

        Button {
          isShowingKey.toggle()
        } label: {
          Image(systemName: isShowingKey ? "eye.slash" : "eye")
            .foregroundStyle(.secondary)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isShowingKey ? String(localized: "Hide", comment: "Localized app copy.") : String(localized: "Show", comment: "Localized app copy."))

        Button(String(localized: "Save", comment: "Localized app copy.")) {
          saveKey()
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.small)
        .disabled(keyInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isWorking)

        if isEditing {
          Button(String(localized: "Cancel", comment: "Localized app copy.")) {
            keyInput = ""
            isShowingKey = false
            isEditing = false
            errorMessage = nil
          }
          .buttonStyle(.bordered)
          .controlSize(.small)
          .disabled(isWorking)
        }

        if isWorking {
          ProgressView()
            .controlSize(.small)
        }
      }

      if let errorMessage {
        Text(errorMessage)
          .font(.caption)
          .foregroundStyle(.red)
      }
    }
  }

  // MARK: - Actions
  @MainActor
  private func loadSavedKeyStatus() async {
    do {
      hasSavedKey = try await GeminiAPIKeyStore.read() != nil
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  private func saveKey() {
    let value = keyInput.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !value.isEmpty else { return }
    isWorking = true
    errorMessage = nil

    Task {
      defer { isWorking = false }
      do {
        try await GeminiAPIKeyStore.save(value)
        hasSavedKey = true
        keyInput = ""
        isShowingKey = false
        isEditing = false
        onKeySaved?(value)
      } catch {
        errorMessage = error.localizedDescription
      }
    }
  }

  private func deleteKey() {
    isWorking = true
    errorMessage = nil

    Task {
      defer { isWorking = false }
      do {
        try await GeminiAPIKeyStore.delete()
        hasSavedKey = false
        isEditing = false
        keyInput = ""
        onKeyDeleted?()
      } catch {
        errorMessage = error.localizedDescription
      }
    }
  }
}
