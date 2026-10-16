import SwiftUI

// MARK: - Reusable Reader Background

struct ReaderBackgroundView: View {
  @Environment(\.colorScheme) private var colorScheme

  var body: some View {
    #if os(iOS)
    if #available(iOS 27.1, *) {
      StoryPalette.page(for: colorScheme)
        .backgroundExtensionEffect()
    } else {
      StoryPalette.page(for: colorScheme)
    }
    #else
    StoryPalette.page(for: colorScheme)
    #endif
  }
}
