import SwiftUI

struct StorySettingsFormAppearance: ViewModifier {
  @Environment(\.colorScheme) private var colorScheme

  func body(content: Content) -> some View {
    content
      .scrollContentBackground(.hidden)
      .background(StoryPalette.page(for: colorScheme))
      .listRowBackground(StoryPalette.surface(for: colorScheme))
      .tint(StoryPalette.accent)
  }
}
