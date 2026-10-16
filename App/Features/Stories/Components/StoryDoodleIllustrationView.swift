import SwiftUI

struct StoryDoodleIllustrationView: View {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion
  @State private var isFloating = false
  @State private var isSwaying = false

  var chapter: StoryChapter
  var style: StoryDoodleStyle = .fullPage

  private var theme: StoryDoodleTheme {
    StoryDoodleTheme.select(for: chapter)
  }

  var body: some View {
    illustration
      .onAppear(perform: startAnimations)
      .onChange(of: reduceMotion) { _, _ in updateAnimations() }
  }

  @ViewBuilder
  private var illustration: some View {
    switch style {
    case .fullPage:
      StoryDoodleFullPageView(
        chapter: chapter,
        theme: theme,
        isFloating: isFloating,
        isSwaying: isSwaying
      )
    case .thumbnail:
      StoryDoodleThumbnailView(
        theme: theme,
        isFloating: isFloating,
        isSwaying: isSwaying
      )
    }
  }

  private func startAnimations() {
    guard supportsAmbientMotion, !reduceMotion else { return }
    withAnimation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true)) {
      isFloating = true
    }
    withAnimation(.easeInOut(duration: 3.6).repeatForever(autoreverses: true)) {
      isSwaying = true
    }
  }

  private var supportsAmbientMotion: Bool {
    if case .fullPage = style { return true }
    return false
  }

  private func updateAnimations() {
    if reduceMotion { stopAnimations() }
    else { startAnimations() }
  }

  private func stopAnimations() {
    var transaction = Transaction(animation: nil)
    transaction.disablesAnimations = true
    withTransaction(transaction) {
      isFloating = false
      isSwaying = false
    }
  }
}
