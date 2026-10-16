import SwiftUI

struct ReaderLoadingStoryPage: View {
  var context: ReaderPageBuildContext
  var layout: ReaderPairedPageLayout

  var body: some View {
    content
  }

  private var content: some View {
    StoryLoadingCopy(
      isGenerating: context.isGenerating,
      errorMessage: context.generationErrorMessage,
      onRetry: context.onRetryGeneration
    )
    .frame(maxWidth: layout.usesWideTextInsets ? 600 : .infinity, alignment: .leading)
    .padding(36)
    .padding(.trailing, layout.usesWideTextInsets ? 48 : 0)
    .background(StoryPalette.surface(for: context.colorScheme))
    .overlay(alignment: .leading) {
      if layout.displaysSpineWhenFlat || context.spineIntensity > 0 {
        BookSpineShadow(edge: .leading, width: layout.spineWidth, intensity: context.spineIntensity, showsCreaseLine: true)
      }
    }
  }
}
