import SwiftUI

struct CuratedCollectionsHeader: View {
  var isLoading: Bool

  var body: some View {
    HStack {
      Label(String(localized: "Curated Story Collections", comment: "Localized app copy."), systemImage: "books.vertical")
        .font(.system(.title2, design: .serif).weight(.medium))
        .foregroundStyle(.primary)
      Spacer()
      if isLoading { ProgressView().controlSize(.small) }
    }
  }
}
