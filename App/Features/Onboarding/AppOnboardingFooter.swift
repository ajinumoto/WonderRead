import SwiftUI

struct AppOnboardingFooter: View {
  var action: AppOnboardingAction
  var onFinish: () -> Void

  var body: some View {
    Button(action: onFinish) {
      HStack {
        Text(action.title)
        Spacer(minLength: 12)
        Image(systemName: "arrow.right")
          .accessibilityHidden(true)
      }
      .frame(maxWidth: .infinity)
      .contentShape(Rectangle())
    }
    .buttonStyle(.borderedProminent)
    .controlSize(.large)
    .accessibilityHint(action.accessibilityHint)
    .padding(.horizontal, 24)
    .padding(.top, 12)
    .padding(.bottom, 16)
  }
}
