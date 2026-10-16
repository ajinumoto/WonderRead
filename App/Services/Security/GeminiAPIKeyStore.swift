import Foundation

enum GeminiAPIKeyStore {
  static func read() async throws -> String? {
    try await SecureAPIKeyStore.read(for: .gemini)
  }

  static func save(_ value: String) async throws {
    try await SecureAPIKeyStore.save(value, for: .gemini)
  }

  static func delete() async throws {
    try await SecureAPIKeyStore.delete(for: .gemini)
  }
}

typealias GeminiAPIKeyStoreError = SecureAPIKeyStoreError
