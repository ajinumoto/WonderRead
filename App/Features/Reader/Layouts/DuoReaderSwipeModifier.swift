import SwiftUI

#if os(iOS)
struct DuoReaderSwipeModifier: ViewModifier {
  var chapterIndex: Int
  var minimumDistance: CGFloat
  var completionDistance: CGFloat
  var verticalDominance: CGFloat
  var onChapterChanged: (Int) -> Void

  func body(content: Content) -> some View {
    content.simultaneousGesture(
      DragGesture(minimumDistance: minimumDistance, coordinateSpace: .local)
        .onEnded(handleSwipe)
    )
  }

  private func handleSwipe(_ value: DragGesture.Value) {
    guard let delta = ReaderSwipeDirectionMapper.direction(
      for: value.translation,
      minimumDistance: completionDistance,
      dominance: verticalDominance
    ) else { return }
    onChapterChanged(chapterIndex + delta)
  }
}
#endif
