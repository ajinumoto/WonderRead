import Foundation

struct CollectionVersionDTO: Codable, Sendable, Identifiable {
  var id: UUID
  var version: Int?
  var language: String?

  var effectiveVersion: Int {
    version ?? 1
  }
}
