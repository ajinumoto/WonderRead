import SwiftUI

enum ReaderDeviceCategory: String, CaseIterable, Identifiable, Sendable {
  case iphone
  case iphoneDuo
  case ipad
  case mac

  var id: String { rawValue }

  var displayName: String {
    switch self {
    case .iphone: return "iPhone"
    case .iphoneDuo: return "iPhone Duo"
    case .ipad: return "iPad"
    case .mac: return "Mac"
    }
  }

  static func resolve(geometry: GeometryProxy) -> ReaderDeviceCategory {
    #if os(macOS)
    resolve(isMac: true, isPad: false, hasDivision: false)
    #else
    let isMac = ProcessInfo.processInfo.isiOSAppOnMac || ProcessInfo.processInfo.isMacCatalystApp
    let isPad = UIDevice.current.userInterfaceIdiom == .pad
    return resolve(isMac: isMac, isPad: isPad, hasDivision: StoryLayout.hasDivision(in: geometry))
    #endif
  }

  static func resolve(isMac: Bool, isPad: Bool, hasDivision: Bool) -> ReaderDeviceCategory {
    if isMac { return .mac }
    if isPad { return .ipad }
    return hasDivision ? .iphoneDuo : .iphone
  }
}
