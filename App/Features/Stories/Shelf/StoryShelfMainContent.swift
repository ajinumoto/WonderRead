import SwiftUI

struct StoryShelfMainContent: View {
  @Environment(\.colorScheme) private var colorScheme
  var context: StoryShelfContentContext
  var actions: StoryShelfContentActions

  private var usesTwoPanes: Bool { StoryLayout.usesTwoPanes(for: context.geometry) }
  private var primaryPane: ShelfPrimaryPane {
    ShelfPrimaryPane(
      nickname: context.nickname,
      refreshID: context.refreshID,
      chapter: context.chapter,
      isGenerating: context.isGenerating,
      collectionsDataSource: context.collectionsDataSource,
      onSelectCollection: actions.onOpenCollection,
      onReadAIStory: actions.onContinueReading,
      onCreateAIStory: actions.onCreateStory
    )
  }

  private var secondaryPane: ShelfSecondaryPane {
    ShelfSecondaryPane(
      refreshID: context.refreshID,
      isTwoPanes: usesTwoPanes,
      portraitHeight: portraitCoverHeight,
      onOpenCollection: actions.onOpenCollection,
      onOpenCuratedChapter: actions.onOpenCuratedChapter
    )
  }

  private var portraitCoverHeight: CGFloat {
    max(280, min(context.geometry.size.height * 0.42, 420))
  }

  var body: some View {
    Group {
      if usesTwoPanes { twoPaneLayout } else { portraitLayout }
    }
    .background(StoryPalette.page(for: colorScheme))
  }

  private var twoPaneLayout: some View {
    ShelfTwoPaneLayout(
      geometry: context.geometry,
      isPortrait: context.geometry.size.height > context.geometry.size.width,
      primary: primaryPane,
      secondary: secondaryPane,
      onRefresh: actions.onRefresh
    )
  }

  private var portraitLayout: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 26) {
        ShelfWelcomeHeader(nickname: context.nickname)
        CuratedCollectionsSection(
          dataSource: context.collectionsDataSource,
          refreshID: context.refreshID,
          onSelectCollection: actions.onOpenCollection
        )
        secondaryPane.frame(maxWidth: .infinity, alignment: .center).padding(.vertical, 4)
        storyEntry
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 26)
      .frame(maxWidth: 640)
      .frame(maxWidth: .infinity)
    }
    .refreshable { await actions.onRefresh() }
    .scrollIndicators(.hidden)
  }

  @ViewBuilder
  private var storyEntry: some View {
    if let chapter = context.chapter {
      CurrentStoryCard(chapter: chapter, nickname: context.nickname, showsCover: true, onRead: actions.onContinueReading)
    } else {
      CreateFirstStoryCard(isGenerating: context.isGenerating, onCreate: actions.onCreateStory)
    }
  }
}
