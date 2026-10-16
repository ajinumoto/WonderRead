import SwiftUI

struct CuratedCollectionLoadingFooterView: View {
  var isLoading: Bool
  var hasMore: Bool

  var body: some View {
    Group {
      if isLoading {
        loadingIndicator
      }
    }
    .frame(maxWidth: .infinity, alignment: .center)
    .padding(.vertical, 12)
  }

  private var loadingIndicator: some View {
    HStack(spacing: 8) {
      ProgressView()
        .controlSize(.small)
      Text(String(localized: "Loading more stories…", comment: "Localized app copy."))
        .font(.footnote)
        .foregroundStyle(.secondary)
    }
  }
}
