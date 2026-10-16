import SwiftUI

struct AppOnboardingWelcomeSection: View {
  let headline: String
  let subheadline: String

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(headline)
        .font(.system(.largeTitle, design: .serif))
        .fontWeight(.semibold)
        .fixedSize(horizontal: false, vertical: true)

      Text(subheadline)
        .font(.body)
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
