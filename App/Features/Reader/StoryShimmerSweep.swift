import SwiftUI

struct StoryShimmerSweep: View {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion
  @Environment(\.colorScheme) private var colorScheme
  @State private var progress: CGFloat = 0

  var bandWidthRatio: CGFloat

  var body: some View {
    GeometryReader { geometry in
      sweep(in: geometry.size)
    }
    .clipped()
    .accessibilityHidden(true)
    .task(id: reduceMotion) {
      await runSweep()
    }
  }

  @ViewBuilder
  private func sweep(in size: CGSize) -> some View {
    if !reduceMotion {
      let bandWidth = StoryShimmerMetrics.bandWidth(in: size.width, ratio: bandWidthRatio)
      LinearGradient(
        colors: [.clear, .white.opacity(highlightOpacity), .clear],
        startPoint: .leading,
        endPoint: .trailing
      )
      .frame(width: bandWidth)
      .offset(x: StoryShimmerMetrics.horizontalOffset(
        viewWidth: size.width,
        bandWidth: bandWidth,
        progress: progress
      ))
    }
  }

  private var highlightOpacity: Double {
    colorScheme == .dark ? 0.09 : 0.30
  }

  private func runSweep() async {
    resetSweep()
    guard !reduceMotion else { return }
    while await runSweepCycle() {}
  }

  private func runSweepCycle() async -> Bool {
    withAnimation(.linear(duration: StoryShimmerMetrics.sweepDuration)) {
      progress = 1
    }
    guard await pause(for: StoryShimmerMetrics.sweepDuration) else { return false }
    resetSweep()
    return await pause(for: StoryShimmerMetrics.restDuration)
  }

  private func pause(for duration: TimeInterval) async -> Bool {
    do { try await Task.sleep(for: .seconds(duration)); return !Task.isCancelled }
    catch { return false }
  }

  private func resetSweep() {
    withTransaction(Transaction(animation: nil)) {
      progress = 0
    }
  }
}

enum StoryShimmerMetrics {
  static let sweepDuration: TimeInterval = 1.4
  static let restDuration: TimeInterval = 1.1

  static func bandWidth(in viewWidth: CGFloat, ratio: CGFloat) -> CGFloat {
    viewWidth * ratio
  }

  static func horizontalOffset(viewWidth: CGFloat, bandWidth: CGFloat, progress: CGFloat) -> CGFloat {
    let travelDistance = viewWidth + bandWidth
    let boundedProgress = min(max(progress, 0), 1)
    return -travelDistance / 2 + travelDistance * boundedProgress
  }
}
