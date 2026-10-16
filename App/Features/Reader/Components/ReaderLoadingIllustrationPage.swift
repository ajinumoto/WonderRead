import SwiftUI

struct ReaderLoadingIllustrationPage: View {
  var context: ReaderPageBuildContext
  var layout: ReaderPairedPageLayout

  var body: some View {
    StoryIllustrationShimmer()
      .overlay(alignment: .trailing) {
        if layout.displaysSpineWhenFlat || context.spineIntensity > 0 {
          BookSpineShadow(edge: .trailing, width: layout.spineWidth, intensity: context.spineIntensity, showsCreaseLine: true)
        }
      }
  }
}
