import Foundation

struct SupabaseCollectionDTO: Codable {
  var id: UUID
  var slug: String
  var title: String
  var subtitle: String?
  var description: String
  var cover_image_url: String
  var badge: String?
  var language: String?
  var version: Int?
  var story_chapters: [SupabaseChapterDTO]?
}
