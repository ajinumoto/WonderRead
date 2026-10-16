import SwiftUI

/// Halaman sampul pembuka satu lembar penuh (full-bleed) di dalam mode baca (StoryReaderView).
/// Mengisi seluruh halaman dengan gambar ilustrasi penuh, menampilkan nama seri dan judul secara elegan,
/// tanpa tombol atau interaksi tap (murni lembaran kertas buku fisik).
struct StoryReaderCoverPage: View {
  var seriesBadge: String? = nil
  var collectionTitle: String
  var chapter: StoryChapter? = nil
  var coverImageURL: String? = nil
  var spineIntensity: Double = 1.0
  var showsSpineShadow: Bool = true

  private var resolvedCoverURL: URL? {
    if let coverImageURL, !coverImageURL.isEmpty {
      return StoryImageLoader.resolveURL(for: coverImageURL)
    }
    if let filename = chapter?.illustrationFilename, !filename.isEmpty {
      return StoryImageLoader.resolveURL(for: filename)
    }
    return nil
  }

  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .bottom) {
        StoryReaderCoverArtworkView(
          url: resolvedCoverURL,
          chapter: chapter,
          collectionTitle: collectionTitle
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        StoryReaderCoverScrim().ignoresSafeArea()
        StoryReaderCoverBottomContent(seriesBadge: seriesBadge, collectionTitle: collectionTitle)
        .padding(.bottom, max(geometry.safeAreaInsets.bottom, 48))
        .padding(.horizontal, 20)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .clipped()
      .overlay(alignment: .leading) {
        if showsSpineShadow && spineIntensity > 0 {
          BookSpineShadow(
            edge: .leading,
            width: 32,
            intensity: spineIntensity,
            showsCreaseLine: true
          )
        }
      }
      .accessibilityElement(children: .combine)
      .accessibilityLabel(
        String(localized: "Book cover: \(collectionTitle). Swipe to open.", comment: "Localized app copy.")
      )
    }
  }
}
