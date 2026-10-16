import SwiftUI

enum BookSpineEdge: Equatable {
  case leading
  case trailing
  case top
  case bottom

  var isHorizontal: Bool {
    switch self {
    case .leading, .trailing: true
    case .top, .bottom: false
    }
  }

  var isForward: Bool {
    self == .trailing || self == .bottom
  }
}
