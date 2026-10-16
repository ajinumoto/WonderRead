import SwiftUI

struct ShelfPrimaryPane: View {
  var nickname: String
  var refreshID: UUID = UUID()
  var chapter: StoryChapter?
  var isGenerating: Bool
  var collectionsDataSource: StoryCollectionsDataSource? = nil
  var onSelectCollection: (StoryCollection) -> Void
  var onReadAIStory: () -> Void
  var onCreateAIStory: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 30) {
      ShelfWelcomeHeader(nickname: nickname)
      CuratedCollectionsSection(dataSource: collectionsDataSource, refreshID: refreshID, onSelectCollection: onSelectCollection)

      if let chapter {
        CurrentStoryCard(chapter: chapter, nickname: nickname, showsCover: true, onRead: onReadAIStory)
      } else {
        CreateFirstStoryCard(isGenerating: isGenerating, onCreate: onCreateAIStory)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
