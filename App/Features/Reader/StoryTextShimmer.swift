import SwiftUI

struct StoryTextShimmer: View {
  var body: some View {
    ZStack(alignment: .leading) {
      skeletonLines
      StoryShimmerSweep(bandWidthRatio: 0.30)
    }
    .frame(minHeight: 420)
    .clipped()
    .accessibilityLabel(String(localized: "Preparing story text", comment: "Localized app copy."))
  }

  private var skeletonLines: some View {
    VStack(alignment: .leading, spacing: 24) {
      VStack(alignment: .leading, spacing: 12) {
        shimmerLine(height: 12, width: 0.40)
        shimmerLine(height: 28, width: 0.84)
        shimmerLine(height: 16, width: 0.48)
      }
      .padding(.bottom, 6)

      ForEach(0..<4, id: \.self) { paragraph in
        VStack(alignment: .leading, spacing: 10) {
          shimmerLine(height: 14, width: paragraph.isMultiple(of: 2) ? 0.96 : 0.90)
          shimmerLine(height: 14, width: 0.99)
          shimmerLine(height: 14, width: paragraph.isMultiple(of: 2) ? 0.88 : 0.76)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  private func shimmerLine(height: CGFloat, width: CGFloat) -> some View {
    GeometryReader { geometry in
      Capsule()
        .fill(Color.primary.opacity(0.10))
        .frame(width: geometry.size.width * width, height: height)
    }
    .frame(height: height)
  }
}
