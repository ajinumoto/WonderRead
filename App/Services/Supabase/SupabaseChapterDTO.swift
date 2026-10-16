import Foundation

struct SupabaseChapterDTO: Codable {
  var id: UUID
  var collection_id: UUID?
  var number: Int
  var series_title: String
  var title: String
  var summary: String
  var paragraphs: [String]
  var illustration_prompt: String?
  var illustration_url: String
  var created_at: String?
}
