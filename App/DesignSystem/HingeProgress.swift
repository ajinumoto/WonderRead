import Observation
import SwiftUI

#if os(iOS)
@available(iOS 27.1, *)
@Observable
final class HingeProgress {
  var value: Double = 1
  var isPartial = false
  private var maxSeen: Double = .pi

  func update(_ hinge: DeviceHinge?) {
    let snapshot = HingeProgressMapper.snapshot(for: hinge, maximumSeen: maxSeen)
    value = snapshot.value
    isPartial = snapshot.isPartial
    maxSeen = snapshot.maximumSeen
  }
}

@available(iOS 27.1, *)
private struct HingeProgressSnapshot {
  var value: Double
  var isPartial: Bool
  var maximumSeen: Double
}

@available(iOS 27.1, *)
private enum HingeProgressMapper {
  static func snapshot(for hinge: DeviceHinge?, maximumSeen: Double) -> HingeProgressSnapshot {
    guard let hinge else { return HingeProgressSnapshot(value: 1, isPartial: false, maximumSeen: maximumSeen) }
    return snapshot(for: hinge, maximumSeen: maximumSeen)
  }

  private static func snapshot(for hinge: DeviceHinge, maximumSeen: Double) -> HingeProgressSnapshot {
    switch hinge.status {
    case .closed:
      return HingeProgressSnapshot(value: 0, isPartial: false, maximumSeen: maximumSeen)
    case .fullyOpen:
      let maximum = max(maximumSeen, hinge.angle.radians)
      return HingeProgressSnapshot(value: 1, isPartial: false, maximumSeen: maximum)
    default:
      let progress = min(max(hinge.angle.radians / maximumSeen, 0), 1)
      return HingeProgressSnapshot(value: progress, isPartial: true, maximumSeen: maximumSeen)
    }
  }
}
#endif
