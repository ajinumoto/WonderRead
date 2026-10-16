import Foundation

struct SupabaseCollectionQuery: Sendable, Equatable {
  var cacheKey: String
  var language: String?
  var limit: Int
  var offset: Int

  init(language: String?, limit: Int = 10, offset: Int = 0) {
    let usesAllLanguages = language == nil || language == "all"
    cacheKey = usesAllLanguages ? "all" : (language ?? "all")
    self.language = usesAllLanguages ? nil : language
    self.limit = max(1, limit)
    self.offset = max(0, offset)
  }
}
