import Foundation

struct SupabaseRepoPayload: Equatable, Sendable {
  let projectURL: String
  let anonKey: String
  let repoName: String
}

enum SupabaseRepoDeepLinkMapper {
  static func extractQueryValue(from items: [URLQueryItem], for name: String) -> String? {
    items.first(where: { $0.name == name })?.value?.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  static func parse(url: URL) -> SupabaseRepoPayload? {
    guard url.scheme?.lowercased() == "wonderread",
          url.host?.lowercased() == "install-repo",
          let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
      return nil
    }
    let items = components.queryItems ?? []
    guard let projectURL = extractQueryValue(from: items, for: "url"), !projectURL.isEmpty,
          let anonKey = extractQueryValue(from: items, for: "key"), !anonKey.isEmpty else {
      return nil
    }
      let defaultName = String(localized: "New Story Repository", comment: "Fallback name for an imported story collection")
      let repoName = extractQueryValue(from: items, for: "name") ?? defaultName
      return SupabaseRepoPayload(projectURL: projectURL, anonKey: anonKey, repoName: repoName)
    }
}
