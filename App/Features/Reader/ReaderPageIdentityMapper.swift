import Foundation

enum ReaderPageIdentityMapper {
  static func make(chapterIDs: [UUID], hasCoverPage: Bool, isCuratedMode: Bool) -> [AnyHashable] {
    [AnyHashable(chapterIDs), AnyHashable(hasCoverPage), AnyHashable(isCuratedMode)]
  }
}
