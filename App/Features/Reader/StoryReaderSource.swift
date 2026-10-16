import SwiftUI

enum StoryReaderSource: Hashable, Sendable {
  case library
  case collection(StoryCollection)
}
