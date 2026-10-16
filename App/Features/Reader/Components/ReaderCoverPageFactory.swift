import SwiftUI

enum ReaderCoverPageFactory {
  static func paired(context: ReaderPageBuildContext, prefix: String) -> [ReaderPageView] {
    guard let info = context.coverInfo else { return [] }
    let endpaper = ReaderPageView(kind: .blankEndpaper(id: "\(prefix)-cover-left", spineIntensity: context.spineIntensity))
    let cover = ReaderPageView(kind: .cover(
      id: "\(prefix)-cover-right",
      info: info,
      coverImageURL: context.coverImageURL,
      spineIntensity: context.spineIntensity,
      showsSpineShadow: true
    ))
    return [endpaper, cover]
  }

  static func single(context: ReaderPageBuildContext, id: String) -> [ReaderPageView] {
    guard let info = context.coverInfo else { return [] }
    let cover = ReaderPageView(kind: .cover(
      id: id,
      info: info,
      coverImageURL: context.coverImageURL,
      spineIntensity: 0,
      showsSpineShadow: false
    ))
    return [cover]
  }
}
