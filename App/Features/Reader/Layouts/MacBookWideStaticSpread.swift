import SwiftUI

struct MacBookWideStaticSpread: View {
  var chapter: StoryChapter
  var nickname: String
  var textScale: CGFloat
  var spineIntensity: Double

  var body: some View {
    HStack(spacing: 0) {
      StoryIllustrationPage(chapter: chapter)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .trailing) { BookSpineShadow(edge: .trailing, intensity: spineIntensity) }
      StoryTextPage(chapter: chapter, nickname: nickname, textScale: textScale)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .leading) { BookSpineShadow(edge: .leading, intensity: spineIntensity) }
    }
  }
}
