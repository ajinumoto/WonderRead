import SwiftUI

struct AppOnboardingHeader: View {
  var onSkip: () -> Void

  var body: some View {
    HStack {
      Label("WonderRead", systemImage: "book.closed.fill")
        .font(.system(.headline, design: .serif))
        .foregroundStyle(StoryPalette.accent)

      Spacer()

      Button(String(localized: "Skip", comment: "Skips the optional app introduction."), action: onSkip)
        .buttonStyle(.plain)
    }
    .padding(.horizontal, 24)
    .padding(.top, 16)
    .padding(.bottom, 8)
  }
}
