import SwiftUI

struct ReaderReducedMotionView: View {
  var context: StoryReaderLayoutContext
  var actions: StoryReaderLayoutActions
  var isWide: Bool
  var isSideBySide: Bool = false
  var onSwipe: (Int) -> Void

  var body: some View {
    ReaderReducedMotionContent(context: context, actions: actions, isWide: isWide, isSideBySide: isSideBySide)
      .simultaneousGesture(swipeGesture)
  }

  private var swipeGesture: some Gesture {
    DragGesture(minimumDistance: 48, coordinateSpace: .local)
      .onEnded { value in
        guard let delta = ReaderSwipeDirectionMapper.direction(for: value.translation, minimumDistance: 76, dominance: 1.25) else { return }
        onSwipe(delta)
      }
  }
}
