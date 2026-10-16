import Foundation
import SwiftData

@Model
final class StoryCollectionEntity {
  #Index<StoryCollectionEntity>([\.language], [\.slug])

  @Attribute(.unique) var id: UUID
  var slug: String
  var title: String
  var subtitle: String
  var summaryText: String
  var coverImageURL: String
  var badge: String?
  var language: String
  var version: Int
  var orderIndex: Int = 0
  @Relationship(deleteRule: .cascade, inverse: \StoryChapterEntity.collection)
  var chapters: [StoryChapterEntity] = []

  init(
    id: UUID,
    slug: String,
    title: String,
    subtitle: String,
    summaryText: String,
    coverImageURL: String,
    badge: String? = nil,
    language: String = "en",
    version: Int = 1,
    orderIndex: Int = 0,
    chapters: [StoryChapterEntity] = []
  ) {
    self.id = id
    self.slug = slug
    self.title = title
    self.subtitle = subtitle
    self.summaryText = summaryText
    self.coverImageURL = coverImageURL
    self.badge = badge
    self.language = language
    self.version = version
    self.orderIndex = orderIndex
    self.chapters = chapters
  }
}
