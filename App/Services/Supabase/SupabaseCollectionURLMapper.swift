import Foundation

enum SupabaseCollectionURLMapper {
  private static let basePath = "/rest/v1/story_collections?select=*,story_chapters(*)&order=order_index.asc&story_chapters.order=number.asc"

  static func collectionsURL(baseURL: String, query: SupabaseCollectionQuery) -> URL? {
    let languageFilter = query.language.map { "&language=eq.\($0)" } ?? ""
    let paginationParams = "&limit=\(query.limit)&offset=\(query.offset)"
    return URL(string: "\(baseURL)\(basePath)\(languageFilter)\(paginationParams)")
  }

  static func fallbackURL(baseURL: String, limit: Int, offset: Int) -> URL? {
    let paginationParams = "&limit=\(limit)&offset=\(offset)"
    return URL(string: "\(baseURL)\(basePath)\(paginationParams)")
  }
}
