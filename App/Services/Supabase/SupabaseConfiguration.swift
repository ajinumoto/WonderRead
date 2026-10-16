import Foundation

enum SupabaseConfiguration {
  static let urlDefaultsKey = "supabase.url"
  static let anonKeyDefaultsKey = "supabase.anonKey"

  private static let projectURLInfoKey = "SUPABASE_PROJECT_URL"
  private static let anonKeyInfoKey = "SUPABASE_ANON_KEY"

  private static var configuredProjectURL: String {
    Bundle.main.object(forInfoDictionaryKey: projectURLInfoKey) as? String ?? ""
  }

  private static var configuredAnonKey: String {
    Bundle.main.object(forInfoDictionaryKey: anonKeyInfoKey) as? String ?? ""
  }

  static var projectURL: String {
    get {
      let saved = UserDefaults.standard.string(forKey: urlDefaultsKey)?
        .trimmingCharacters(in: .whitespacesAndNewlines)
      if let saved, !saved.isEmpty {
        return saved
      }
      return configuredProjectURL
    }
    set {
      UserDefaults.standard.set(newValue.trimmingCharacters(in: .whitespacesAndNewlines), forKey: urlDefaultsKey)
    }
  }

  static var anonKey: String {
    get {
      if let keychainKey = try? SecureAPIKeyStore.readSynchronously(for: .supabaseAnonKey),
         !keychainKey.isEmpty {
        return keychainKey
      }
      let saved = UserDefaults.standard.string(forKey: anonKeyDefaultsKey)?
        .trimmingCharacters(in: .whitespacesAndNewlines)
      if let saved, !saved.isEmpty {
        try? SecureAPIKeyStore.saveSynchronously(saved, for: .supabaseAnonKey)
        UserDefaults.standard.removeObject(forKey: anonKeyDefaultsKey)
        return saved
      }
      return configuredAnonKey
    }
    set {
      let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
      if trimmed.isEmpty {
        try? SecureAPIKeyStore.saveSynchronously("", for: .supabaseAnonKey)
      } else {
        try? SecureAPIKeyStore.saveSynchronously(trimmed, for: .supabaseAnonKey)
      }
      UserDefaults.standard.removeObject(forKey: anonKeyDefaultsKey)
    }
  }

  static var isConfigured: Bool {
    isConfigured(projectURL: projectURL, anonKey: anonKey)
  }

  static func isConfigured(projectURL: String, anonKey: String) -> Bool {
    let normalizedURL = projectURL.trimmingCharacters(in: .whitespacesAndNewlines)
    let normalizedKey = anonKey.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !isServiceRoleKey(normalizedKey) else { return false }
    guard let components = URLComponents(string: normalizedURL),
          let scheme = components.scheme?.lowercased(),
          let host = components.host?.lowercased(),
          !normalizedKey.isEmpty else {
      return false
    }
    if scheme == "http" {
      return isLocalHost(host)
    }
    return scheme == "https"
  }

  static func isServiceRoleKey(_ key: String) -> Bool {
    let parts = key.split(separator: ".")
    guard parts.count == 3 else { return false }
    var base64 = String(parts[1])
      .replacingOccurrences(of: "-", with: "+")
      .replacingOccurrences(of: "_", with: "/")
    while base64.count % 4 != 0 {
      base64.append("=")
    }
    guard let data = Data(base64Encoded: base64),
          let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
          let role = json["role"] as? String else {
      return false
    }
    return role == "service_role"
  }

  private static func isLocalHost(_ host: String) -> Bool {
    host == "localhost" || host == "127.0.0.1" || host == "::1"
  }
}
