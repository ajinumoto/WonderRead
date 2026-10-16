import SwiftUI

struct StoryLoadingCopy: View {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  var isGenerating: Bool
  var errorMessage: String?
  var onRetry: () -> Void

  private let phrases = [
    String(localized: "Writing the next story…", comment: "Localized app copy."),
    String(localized: "Finding the next adventure…", comment: "Localized app copy."),
    String(localized: "Putting the words together…", comment: "Localized app copy."),
    String(localized: "Preparing a new world…", comment: "Localized app copy."),
    String(localized: "Your story is almost here…", comment: "Localized app copy.")
  ]

  var body: some View {
    VStack(alignment: .leading, spacing: 22) {
      Text(String(localized: "Next page", comment: "Localized app copy."))
        .font(.system(.title2, design: .serif))
        .foregroundStyle(StoryPalette.forest)

      if let errorMessage {
        Label(errorMessage, systemImage: "exclamationmark.triangle")
          .font(.body)
          .foregroundStyle(.secondary)
          .fixedSize(horizontal: false, vertical: true)

        Button(action: onRetry) {
          Label(String(localized: "Try again", comment: "Localized app copy."), systemImage: "arrow.clockwise")
        }
        .buttonStyle(.bordered)
        .disabled(isGenerating)
      } else {
        HStack(spacing: 12) {
          TimelineView(.periodic(from: .now, by: 1.8)) { timeline in
            let index = Int(timeline.date.timeIntervalSince1970 / 1.8) % phrases.count
            Text(phrases[index])
              .font(.system(.title3, design: .serif))
              .foregroundStyle(.secondary)
              .id(index)
              .transition(.opacity)
              .animation(reduceMotion ? nil : .smooth(duration: 0.35), value: index)
          }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(String(localized: "Computational Literature is writing your story", comment: "Localized app copy."))

        StoryTextShimmer()
      }
    }
    .frame(maxWidth: 520, alignment: .leading)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
  }
}
