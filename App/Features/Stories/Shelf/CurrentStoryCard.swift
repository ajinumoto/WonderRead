import SwiftUI

struct CurrentStoryCard: View {
  @Environment(StoryLibrary.self) private var storyLibrary
  @Environment(\.colorScheme) private var colorScheme
  var chapter: StoryChapter
  var nickname: String
  var showsCover: Bool
  var onRead: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 22) {
      if showsCover && (StoryArchive.illustrationURL(for: chapter.illustrationFilename) != nil
        || storyLibrary.generatingIllustrationIDs.contains(chapter.id)) {
        StoryArtworkThumbnail(chapter: chapter, height: 260)
          .accessibilityHidden(true)
      }

      VStack(alignment: .leading, spacing: 14) {
        Text(chapter.seriesTitle)
          .font(.system(.title, design: .serif))
          .fixedSize(horizontal: false, vertical: true)

        Text(String(localized: "Chapter \(chapter.number) · \(chapter.title)", comment: "Localized app copy."))
          .font(.headline)

        Text(nickname.isEmpty
          ? chapter.summary
          : String(localized: "A story for \(nickname). \(chapter.summary)", comment: "Localized app copy."))
          .font(.body)
          .foregroundStyle(.secondary)
          .fixedSize(horizontal: false, vertical: true)

        Button(action: onRead) {
          Label(String(localized: "Read story", comment: "Localized app copy."), systemImage: "book")
            .font(.body.weight(.semibold))
        }
        .buttonStyle(.borderedProminent)
        #if os(iOS)
        .hoverEffect(.lift)
        #endif
        .padding(.top, 4)
      }
    }
    .padding(.vertical, 6)
  }
}
