import SwiftUI

enum DuoReaderPose: String {
  case innerBook
  case innerTable
  case outerLandscape
  case outerPortrait
}

enum DuoReaderPoseMapper {
  static func resolve(in geometry: GeometryProxy) -> DuoReaderPose {
    resolve(
      size: geometry.size,
      hasActiveDivision: StoryLayout.hasActiveDivision(in: geometry),
      hingeOrientation: StoryLayout.hingeOrientation(in: geometry)
    )
  }

  static func resolve(size: CGSize, hasActiveDivision: Bool, hingeOrientation: HingeOrientation) -> DuoReaderPose {
    let isInner = hasActiveDivision || (size.width >= 550 && size.height >= 550)
    guard isInner else { return size.width > size.height ? .outerLandscape : .outerPortrait }
    return hingeOrientation == .horizontal ? .innerTable : .innerBook
  }
}
