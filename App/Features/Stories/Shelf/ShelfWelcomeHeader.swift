import SwiftUI

struct ShelfWelcomeHeader: View {
  var nickname: String

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(nickname.isEmpty
        ? String(localized: "Welcome", comment: "Localized app copy.")
        : String(localized: "Welcome, \(nickname)", comment: "Localized app copy."))
        .font(.system(.largeTitle, design: .serif))
        .fixedSize(horizontal: false, vertical: true)

      Text(String(localized: "A new chapter is waiting tonight.", comment: "Localized app copy."))
        .font(.title3)
        .foregroundStyle(.secondary)
    }
    .padding(.top, 8)
  }
}
