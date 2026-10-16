import SwiftUI

struct MacBookCurlReaderView: View {
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  var isWide: Bool
  var isShowingCover: Bool
  var coverInfo: ReaderCoverInfo?
  var currentChapter: StoryChapter?
  var nextChapter: StoryChapter?
  var prevChapter: StoryChapter?
  var isShowingLoadingPage: Bool
  var isGenerating: Bool
  var generationErrorMessage: String?
  var nickname: String
  var textScale: CGFloat
  var spineIntensity: Double

  var onRetryGeneration: () -> Void
  var onTurnToChapter: (StoryChapter) -> Void
  var onTurnToPrevChapter: (StoryChapter) -> Void
  var onTurnToCover: () -> Void
  var onTurnToLoading: () -> Void
  var onTurnBackFromLoading: (StoryChapter) -> Void

  @Binding var programmaticAction: MacPageTurnAction?

  @State private var dragProgress: CGFloat = 0.0
  @State private var turnDirection: MacPageTurnAction?
  @State private var isAnimatingCompletion = false

  private var canTurnForward: Bool {
    if isShowingLoadingPage { return false }
    if isShowingCover { return nextChapter != nil }
    if nextChapter != nil { return true }
    return currentChapter != nil && !isCuratedMode
  }

  private var isCuratedMode: Bool {
    currentChapter?.isCurated ?? coverInfo?.chapter?.isCurated ?? false
  }

  private var canTurnBackward: Bool {
    if isShowingLoadingPage {
      return prevChapter != nil || currentChapter != nil
    }
    return prevChapter != nil || (coverInfo != nil && !isShowingCover)
  }

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        if isWide {
          MacBookWideLayoutView(
            geometry: geometry,
            turnDirection: turnDirection,
            dragProgress: dragProgress,
            isShowingCover: isShowingCover,
            coverInfo: coverInfo,
            currentChapter: currentChapter,
            nextChapter: nextChapter,
            previousChapter: prevChapter,
            isShowingLoadingPage: isShowingLoadingPage,
            isGenerating: isGenerating,
            generationErrorMessage: generationErrorMessage,
            nickname: nickname,
            textScale: textScale,
            spineIntensity: spineIntensity,
            reduceMotion: reduceMotion,
            onRetryGeneration: onRetryGeneration
          )
        } else {
          MacBookCompactLayoutView(
            size: geometry.size,
            turnDirection: turnDirection,
            dragProgress: dragProgress,
            isShowingCover: isShowingCover,
            coverInfo: coverInfo,
            currentChapter: currentChapter,
            nextChapter: nextChapter,
            previousChapter: prevChapter,
            isShowingLoadingPage: isShowingLoadingPage,
            generationErrorMessage: generationErrorMessage,
            nickname: nickname,
            textScale: textScale,
            reduceMotion: reduceMotion,
            onRetryGeneration: onRetryGeneration
          )
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .contentShape(Rectangle())
      .gesture(makeDragGesture(in: geometry))
      .onChange(of: programmaticAction) { _, action in
        if let action {
          triggerProgrammaticTurn(action)
          programmaticAction = nil
        }
      }
    }
    .background(StoryPalette.surface(for: colorScheme))
  }

  // MARK: - Gestures & Transitions

  private func makeDragGesture(in geometry: GeometryProxy) -> some Gesture {
    DragGesture(minimumDistance: 10, coordinateSpace: .local)
      .onChanged { handleDragChanged($0, geometry: geometry) }
      .onEnded(handleDragEnded)
  }

  private func handleDragChanged(_ value: DragGesture.Value, geometry: GeometryProxy) {
    guard !isAnimatingCompletion else { return }
    updateTurnDirection(for: value.translation.width)
    guard let direction = turnDirection else { return }
    dragProgress = progress(for: value.translation.width, direction: direction, width: geometry.size.width)
  }

  private func updateTurnDirection(for horizontal: CGFloat) {
    guard turnDirection == nil else { return }
    if horizontal < -12 && canTurnForward { turnDirection = .forward }
    if horizontal > 12 && canTurnBackward { turnDirection = .backward }
  }

  private func progress(for horizontal: CGFloat, direction: MacPageTurnAction, width: CGFloat) -> CGFloat {
    let distance = max(width * (isWide ? 0.45 : 0.80), 120)
    let rawValue = direction == .forward ? -horizontal / distance : horizontal / distance
    return min(max(rawValue, 0), 1)
  }

  private func handleDragEnded(_ value: DragGesture.Value) {
    guard !isAnimatingCompletion, let direction = turnDirection else { return }
    if shouldCompleteTurn(value, direction: direction) {
      completeTurn(direction: direction)
    } else {
      cancelTurn()
    }
  }

  private func shouldCompleteTurn(_ value: DragGesture.Value, direction: MacPageTurnAction) -> Bool {
    let horizontal = value.translation.width
    let velocity = value.predictedEndTranslation.width - horizontal
    if direction == .forward { return dragProgress > 0.32 || velocity < -100 || horizontal < -80 }
    return dragProgress > 0.32 || velocity > 100 || horizontal > 80
  }

  private func triggerProgrammaticTurn(_ action: MacPageTurnAction) {
    guard !isAnimatingCompletion, turnDirection == nil else { return }
    switch action {
    case .forward:
      guard canTurnForward else { return }
      turnDirection = .forward
      completeTurn(direction: .forward)
    case .backward:
      guard canTurnBackward else { return }
      turnDirection = .backward
      completeTurn(direction: .backward)
    }
  }

  private func completeTurn(direction: MacPageTurnAction) {
    isAnimatingCompletion = true
    if reduceMotion {
      commitPageChange(direction: direction)
      dragProgress = 0.0
      turnDirection = nil
      isAnimatingCompletion = false
      return
    }

    withAnimation(.spring(response: 0.38, dampingFraction: 0.82), completionCriteria: .removed) {
      dragProgress = 1.0
    } completion: {
      commitPageChange(direction: direction)
      dragProgress = 0.0
      turnDirection = nil
      isAnimatingCompletion = false
    }
  }

  private func cancelTurn() {
    isAnimatingCompletion = true
    withAnimation(.spring(response: 0.30, dampingFraction: 0.78), completionCriteria: .removed) {
      dragProgress = 0.0
    } completion: {
      turnDirection = nil
      isAnimatingCompletion = false
    }
  }

  private func commitPageChange(direction: MacPageTurnAction) {
    if direction == .forward {
      if let nextChapter {
        onTurnToChapter(nextChapter)
      } else {
        onTurnToLoading()
      }
    } else {
      if isShowingLoadingPage {
        if let prevChapter {
          onTurnBackFromLoading(prevChapter)
        }
      } else if let prevChapter {
        onTurnToPrevChapter(prevChapter)
      } else if coverInfo != nil {
        onTurnToCover()
      }
    }
  }
}
