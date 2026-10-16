import SwiftUI

struct ReaderFullscreenToggleButton: View {
  var isFullscreen: Bool
  var action: () -> Void

  var body: some View {
    Button(action: action) {
      Image(systemName: iconName)
        .font(.system(size: 15, weight: .semibold))
        .foregroundStyle(.primary)
        .frame(width: 40, height: 40)
        .background(.ultraThinMaterial, in: Circle())
        .overlay(Circle().stroke(Color.primary.opacity(0.12), lineWidth: 1))
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
    }
    .buttonStyle(.plain)
    .accessibilityLabel(accessibilityTitle)
  }

  private var iconName: String {
    isFullscreen
      ? "arrow.down.right.and.arrow.up.left"
      : "arrow.up.left.and.arrow.down.right"
  }

  private var accessibilityTitle: String {
    isFullscreen
      ? String(localized: "Show navigation bar", comment: "Localized app copy.")
      : String(localized: "Hide navigation bar", comment: "Localized app copy.")
  }
}
