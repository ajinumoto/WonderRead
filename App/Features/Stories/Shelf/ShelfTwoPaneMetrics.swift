import SwiftUI

struct ShelfTwoPaneMetrics {
  var contentExtent: CGFloat
  var hingeGap: CGFloat
}

enum ShelfTwoPaneMetricsMapper {
  static func portrait(in geometry: GeometryProxy) -> ShelfTwoPaneMetrics {
    let frames = divisionFrames(in: geometry)
    return portrait(size: geometry.size, divisionFrame: frames.inactive, activeDivisionFrame: frames.active)
  }

  static func landscape(in geometry: GeometryProxy) -> ShelfTwoPaneMetrics {
    let frames = divisionFrames(in: geometry)
    return landscape(size: geometry.size, divisionFrame: frames.inactive, activeDivisionFrame: frames.active)
  }

  static func portrait(size: CGSize, divisionFrame: CGRect?, activeDivisionFrame: CGRect?) -> ShelfTwoPaneMetrics {
    ShelfTwoPaneMetrics(contentExtent: divisionFrame?.minY ?? size.height * 0.48, hingeGap: activeDivisionFrame?.height ?? 0)
  }

  static func landscape(size: CGSize, divisionFrame: CGRect?, activeDivisionFrame: CGRect?) -> ShelfTwoPaneMetrics {
    ShelfTwoPaneMetrics(contentExtent: divisionFrame?.minX ?? size.width * 0.5, hingeGap: activeDivisionFrame?.width ?? 0)
  }

  private static func divisionFrames(in geometry: GeometryProxy) -> (inactive: CGRect?, active: CGRect?) {
    #if os(iOS)
    if #available(iOS 27.1, *) {
      return (divisionFrame(in: geometry, includeInactive: true), divisionFrame(in: geometry, includeInactive: false))
    }
    #endif
    return (nil, nil)
  }

  #if os(iOS)
  @available(iOS 27.1, *)
  private static func divisionFrame(in geometry: GeometryProxy, includeInactive: Bool) -> CGRect? {
    if includeInactive {
      return geometry.reservedRegions(kind: .division, options: .includeInactive).first?.frame
    }
    return geometry.reservedRegions(kind: .division).first(where: \.isActive)?.frame
  }
  #else
  private static func divisionFrame(in geometry: GeometryProxy, includeInactive: Bool) -> CGRect? { nil }
  #endif
}
