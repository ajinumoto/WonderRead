import SwiftUI

/// Halaman pembuka sisi kiri yang kosong transparan tanpa bayangan.
struct StoryBlankEndpaperPage: View {
  var spineIntensity: Double = 0.0

  var body: some View {
    Color.clear
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .accessibilityHidden(true)
  }
}
