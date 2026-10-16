import SwiftUI

enum ReaderPairedPageLayout {
  case twoPane
  case duoBook

  var spineWidth: CGFloat { 32 }
  var usesWideTextInsets: Bool { self == .duoBook }
  var displaysSpineWhenFlat: Bool { true }
}
