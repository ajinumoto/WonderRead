import Foundation
import SwiftData

@Model
final class StoryChapterEntity {
  #Index<StoryChapterEntity>([\.sourceRawValue], [\.generatedAt], [\.number])

  @Attribute(.unique) var id: UUID
  var number: Int
  var seriesTitle: String
  var title: String
  var summary: String
  var paragraphs: [String]
  var illustrationPrompt: String
  var illustrationFilename: String
  var generatedAt: Date
  var sourceRawValue: String
  var isFinalInCollection: Bool?
  var collection: StoryCollectionEntity?

  init(
    id: UUID,
    number: Int,
    seriesTitle: String,
    title: String,
    summary: String,
    paragraphs: [String],
    illustrationPrompt: String,
    illustrationFilename: String,
    generatedAt: Date,
    sourceRawValue: String,
    isFinalInCollection: Bool? = nil,
    collection: StoryCollectionEntity? = nil
  ) {
    self.id = id
    self.number = number
    self.seriesTitle = seriesTitle
    self.title = title
    self.summary = summary
    self.paragraphs = paragraphs
    self.illustrationPrompt = illustrationPrompt
    self.illustrationFilename = illustrationFilename
    self.generatedAt = generatedAt
    self.sourceRawValue = sourceRawValue
    self.isFinalInCollection = isFinalInCollection
    self.collection = collection
  }
}
