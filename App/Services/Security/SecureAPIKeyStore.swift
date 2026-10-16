import Foundation
import Security

enum SecureAPIKeyStore {
  enum Key: Sendable {
    case gemini
    case supabaseAnonKey

    var service: String {
      switch self {
      case .gemini: "app.wonderread.gemini-api-key"
      case .supabaseAnonKey: "app.wonderread.supabase-anon-key"
      }
    }

    var account: String {
      switch self {
      case .gemini: "gemini-api-key"
      case .supabaseAnonKey: "supabase-anon-key"
      }
    }

    var displayName: String {
      switch self {
      case .gemini: "Gemini"
      case .supabaseAnonKey: "Supabase"
      }
    }
  }

  static func read(for key: Key) async throws -> String? {
    try await Task.detached(priority: .userInitiated) {
      try readSynchronously(for: key)
    }.value
  }

  static func save(_ value: String, for key: Key) async throws {
    try await Task.detached(priority: .userInitiated) {
      try saveSynchronously(value, for: key)
    }.value
  }

  static func delete(for key: Key) async throws {
    try await Task.detached(priority: .userInitiated) {
      let status = SecItemDelete(baseQuery(for: key) as CFDictionary)
      guard status == errSecSuccess || status == errSecItemNotFound else {
        throw SecureAPIKeyStoreError(provider: key.displayName, operation: .delete, status: status)
      }
    }.value
  }

  static func readSynchronously(for key: Key) throws -> String? {
    var query = baseQuery(for: key)
    query[kSecReturnData as String] = true
    query[kSecMatchLimit as String] = kSecMatchLimitOne

    var result: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &result)
    guard status != errSecItemNotFound else { return nil }
    guard status == errSecSuccess,
          let data = result as? Data,
          let value = String(data: data, encoding: .utf8) else {
      throw SecureAPIKeyStoreError(provider: key.displayName, operation: .read, status: status == errSecSuccess ? errSecDecode : status)
    }
    return value
  }

  static func saveSynchronously(_ value: String, for key: Key) throws {
    _ = SecItemDelete(baseQuery(for: key) as CFDictionary)
    var addQuery = baseQuery(for: key)
    saveAttributes(for: value).forEach { addQuery[$0.key] = $0.value }
    let addStatus = SecItemAdd(addQuery as CFDictionary, nil)
    guard addStatus == errSecSuccess else {
      throw SecureAPIKeyStoreError(provider: key.displayName, operation: .save, status: addStatus)
    }
  }

  private static func saveAttributes(for value: String) -> [String: Any] {
    [
      kSecValueData as String: Data(value.utf8),
      kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
    ]
  }

  private static func baseQuery(for key: Key) -> [String: Any] {
    var query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: key.service,
      kSecAttrAccount as String: key.account
    ]
    #if os(macOS)
    query[kSecUseDataProtectionKeychain as String] = true
    #endif
    return query
  }
}
