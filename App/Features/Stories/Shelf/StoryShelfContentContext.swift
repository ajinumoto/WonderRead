import SwiftUI

struct StoryShelfContentContext {
  var geometry: GeometryProxy
  var nickname: String
  var chapter: StoryChapter?
  var isGenerating: Bool
  var refreshID: UUID
  var collectionsDataSource: StoryCollectionsDataSource? = nil
}
