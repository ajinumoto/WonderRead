import SwiftUI

struct ReaderPageView: View {
  enum Kind {
    case blankEndpaper(id: String, spineIntensity: Double)
    case cover(id: String, info: ReaderCoverInfo, coverImageURL: String?, spineIntensity: Double, showsSpineShadow: Bool)
    case pairedIllustration(chapter: StoryChapter, context: ReaderPageBuildContext, layout: ReaderPairedPageLayout)
    case pairedText(chapter: StoryChapter, context: ReaderPageBuildContext, layout: ReaderPairedPageLayout)
    case pairedLoadingIllustration(context: ReaderPageBuildContext, layout: ReaderPairedPageLayout)
    case pairedLoadingStory(context: ReaderPageBuildContext, layout: ReaderPairedPageLayout)
    case compactChapter(chapter: StoryChapter, nickname: String, textScale: CGFloat)
    case compactLoading(errorMessage: String?, onRetry: () -> Void)
    case padChapter(chapter: StoryChapter, nickname: String, textScale: CGFloat)
    case padLoading(isGenerating: Bool, errorMessage: String?, onRetry: () -> Void)
    case duoSpreadChapter(chapter: StoryChapter, nickname: String, textScale: CGFloat, spineIntensity: Double)
    case duoSpreadLoading(isGenerating: Bool, errorMessage: String?, spineIntensity: Double, onRetry: () -> Void)
  }

  var kind: Kind

  var body: some View {
    switch kind {
    case .blankEndpaper(let id, let spineIntensity):
      StoryBlankEndpaperPage(spineIntensity: spineIntensity)
        .id(id)
    case .cover(let id, let info, let coverImageURL, let spineIntensity, let showsSpineShadow):
      StoryReaderCoverPage(
        seriesBadge: info.seriesBadge,
        collectionTitle: info.collectionTitle,
        chapter: info.chapter,
        coverImageURL: coverImageURL,
        spineIntensity: spineIntensity,
        showsSpineShadow: showsSpineShadow
      )
      .id(id)
    case .pairedIllustration(let chapter, let context, let layout):
      StoryIllustrationPage(chapter: chapter)
        .overlay(alignment: .trailing) {
          if layout.displaysSpineWhenFlat || context.spineIntensity > 0 {
            BookSpineShadow(edge: .trailing, width: layout.spineWidth, intensity: context.spineIntensity, showsCreaseLine: true)
          }
        }
        .id("\(chapter.id)-left")
    case .pairedText(let chapter, let context, let layout):
      StoryTextPage(
        chapter: chapter,
        nickname: context.displayName,
        textScale: context.textScale,
        additionalTrailingPadding: layout.usesWideTextInsets ? 48 : 0,
        maxContentWidth: layout.usesWideTextInsets ? 600 : nil
      )
      .overlay(alignment: .leading) {
        if layout.displaysSpineWhenFlat || context.spineIntensity > 0 {
          BookSpineShadow(edge: .leading, width: layout.spineWidth, intensity: context.spineIntensity, showsCreaseLine: true)
        }
      }
      .id("\(chapter.id)-right")
    case .pairedLoadingIllustration(let context, let layout):
      ReaderLoadingIllustrationPage(context: context, layout: layout)
    case .pairedLoadingStory(let context, let layout):
      ReaderLoadingStoryPage(context: context, layout: layout)
    case .compactChapter(let chapter, let nickname, let textScale):
      StoryCompactPage(chapter: chapter, nickname: nickname, textScale: textScale)
        .id(chapter.id)
    case .compactLoading(let errorMessage, let onRetry):
      StoryLoadingPage(errorMessage: errorMessage, onRetry: onRetry)
    case .padChapter(let chapter, let nickname, let textScale):
      StoryPadSinglePageView(chapter: chapter, nickname: nickname, textScale: textScale)
        .id(chapter.id)
    case .padLoading(let isGenerating, let errorMessage, let onRetry):
      StoryPadLoadingPageView(isGenerating: isGenerating, errorMessage: errorMessage, onRetry: onRetry)
    case .duoSpreadChapter(let chapter, let nickname, let textScale, let spineIntensity):
      StorySpreadPage(
        illustrationPage: StoryIllustrationPage(chapter: chapter),
        storyPage: StoryTextPage(chapter: chapter, nickname: nickname, textScale: textScale),
        spineIntensity: spineIntensity
      )
      .id(chapter.id)
    case .duoSpreadLoading(let isGenerating, let errorMessage, let spineIntensity, let onRetry):
      StoryLoadingSpread(
        isGenerating: isGenerating,
        errorMessage: errorMessage,
        spineIntensity: spineIntensity,
        onRetry: onRetry
      )
    }
  }
}

struct ReaderLayoutPageSources {
  var compact: () -> [ReaderPageView]
  var duoBook: () -> [ReaderPageView]
  var duoSpread: () -> [ReaderPageView]
  var twoPane: () -> [ReaderPageView]
  var padSpread: () -> [ReaderPageView]
}
