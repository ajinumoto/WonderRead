import SwiftUI

enum StoryLayout {
  static func usesTwoPanes(for geometry: GeometryProxy) -> Bool {
    usesTwoPanes(size: geometry.size, hasDivision: hasDivision(in: geometry))
  }

  static func usesTwoPanes(size: CGSize, hasDivision: Bool) -> Bool {
    hasDivision || (size.width > size.height && size.width >= 700)
  }

  static func hasDivision(in geometry: GeometryProxy) -> Bool {
    #if os(iOS)
    if #available(iOS 27.1, *) {
      return !geometry.reservedRegions(kind: .division, options: .includeInactive).isEmpty
    }
    #endif
    return false
  }

  static func hasActiveDivision(in geometry: GeometryProxy) -> Bool {
    #if os(iOS)
    if #available(iOS 27.1, *) {
      return !geometry.reservedRegions(kind: .division).isEmpty
    }
    #endif
    return false
  }

  static func spineShadowIntensity(for normalizedHingeProgress: Double) -> Double {
    let clamped = max(0.0, min(normalizedHingeProgress, 1.0))
    let ratio = 1.0 - clamped
    return 1.0 + (ratio * 1.5)
  }

  static func hingeOrientation(in geometry: GeometryProxy) -> HingeOrientation {
    #if os(iOS)
    if #available(iOS 27.1, *) {
      if let division = geometry.reservedRegions(kind: .division).first {
        return hingeOrientation(size: geometry.size, divisionFrame: division.frame)
      }
    }
    #endif
    return hingeOrientation(size: geometry.size, divisionFrame: nil)
  }

  static func hingeOrientation(size: CGSize, divisionFrame: CGRect?) -> HingeOrientation {
    if let divisionFrame {
      return divisionFrame.width > divisionFrame.height ? .horizontal : .vertical
    }
    return size.height > size.width ? .horizontal : .vertical
  }
}
