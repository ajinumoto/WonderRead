import SwiftUI

struct StoryBookCoverView: View {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion
  @State private var openTrigger = 0
  @State private var feedbackTrigger = 0
  var seriesBadge: String? = nil
  var collectionTitle: String
  var chapter: StoryChapter? = nil
  var coverImageURL: String? = nil
  var onRead: () -> Void = {}

  private var resolvedCoverURL: URL? {
    if let coverImageURL, !coverImageURL.isEmpty { return StoryImageLoader.resolveURL(for: coverImageURL) }
    if let filename = chapter?.illustrationFilename, !filename.isEmpty { return StoryImageLoader.resolveURL(for: filename) }
    return nil
  }

  var body: some View {
    Button(action: openBook) {
      StoryBookCoverArtwork(
        seriesBadge: seriesBadge,
        title: collectionTitle,
        chapter: chapter,
        imageURL: resolvedCoverURL,
        openTrigger: openTrigger
      )
    }
    .buttonStyle(StoryBookCoverButtonStyle())
    .sensoryFeedback(.impact(weight: .light, intensity: 0.7), trigger: feedbackTrigger)
    #if os(iOS)
    .hoverEffect(.lift)
    #endif
    .accessibilityElement(children: .combine)
    .accessibilityLabel(String(localized: "Book cover: \(collectionTitle). Tap to open.", comment: "Localized app copy."))
    .accessibilityHint(String(localized: "Tap to continue reading", comment: "Localized app copy."))
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  private func openBook() {
    feedbackTrigger += 1
    if !reduceMotion { openTrigger += 1 }
    onRead()
  }
}
