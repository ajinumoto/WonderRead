import SwiftUI

struct ReaderPageBuildContext {
  var chapters: [StoryChapter]
  var coverInfo: ReaderCoverInfo?
  var isGenerating: Bool
  var generationErrorMessage: String?
  var nickname: String
  var textScale: CGFloat
  var spineIntensity: Double
  var colorScheme: ColorScheme
  var includesLoadingPage: Bool
  var onRetryGeneration: () -> Void

  var displayName: String {
    nickname.isEmpty ? String(localized: "friend", comment: "Localized app copy.") : nickname
  }

  var coverImageURL: String? {
    guard let coverInfo else { return nil }
    if let url = coverInfo.coverImageURL, !url.isEmpty { return url }
    return coverInfo.chapter?.illustrationFilename
  }
}
