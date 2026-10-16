import Foundation

struct StoryCollection: Identifiable, Codable, Sendable, Hashable {
  var id: UUID
  var slug: String
  var title: String
  var subtitle: String
  var description: String
  var coverImageURL: String
  var badge: String?
  var language: String
  var version: Int
  var chapters: [StoryChapter]

  init(
    id: UUID,
    slug: String,
    title: String,
    subtitle: String,
    description: String,
    coverImageURL: String,
    badge: String? = nil,
    language: String = "en",
    version: Int = 1,
    chapters: [StoryChapter]
  ) {
    self.id = id
    self.slug = slug
    self.title = title
    self.subtitle = subtitle
    self.description = description
    self.coverImageURL = coverImageURL
    self.badge = badge
    self.language = language
    self.version = version
    self.chapters = chapters
  }

  var storyLanguage: StoryLanguage {
    StoryLanguage.from(code: language)
  }
}
