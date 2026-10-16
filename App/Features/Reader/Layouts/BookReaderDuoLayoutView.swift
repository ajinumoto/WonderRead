import SwiftUI

#if os(iOS)
struct BookReaderDuoLayoutView: View, ReaderLayoutContextProviding {
  var context: StoryReaderLayoutContext
  var actions: StoryReaderLayoutActions

  private var pose: DuoReaderPose { DuoReaderPoseMapper.resolve(in: geometry) }

  var body: some View {
    Group {
      switch pose {
      case .innerBook: DuoInnerBookReaderView(context: context, actions: actions)
      case .innerTable: DuoInnerTableReaderView(context: context, actions: actions)
      case .outerLandscape: DuoOuterLandscapeReaderView(context: context, actions: actions)
      case .outerPortrait: DuoOuterPortraitReaderView(context: context, actions: actions)
      }
    }
    .id(pose.rawValue)
    .transition(.opacity)
    .animation(reduceMotion ? nil : .smooth(duration: 0.35), value: pose.rawValue)
    .modifier(DuoHingeObserver(spineIntensity: actions.spineIntensity, isEnabled: !reduceMotion))
  }
}
#endif
