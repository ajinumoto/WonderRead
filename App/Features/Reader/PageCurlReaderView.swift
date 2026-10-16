import SwiftUI

#if os(iOS)
import UIKit

struct PageCurlReaderView: UIViewControllerRepresentable {
  typealias Coordinator = PageCurlReaderCoordinator

  var isFullscreen: Bool = false
  var usesTwoPanes: Bool
  var ignoresPageSafeArea: Bool = false
  var pages: [ReaderPageView]
  var chapterIndex: Int
  var onChapterChanged: (Int) -> Void
  var contentIdentity: AnyHashable

  func makeCoordinator() -> Coordinator { Coordinator(self) }

  func makeUIViewController(context: Context) -> UIPageViewController {
    let controller = makePageController()
    controller.isDoubleSided = usesTwoPanes
    configure(controller, coordinator: context.coordinator)
    context.coordinator.updateFullscreen(isFullscreen, in: controller)
    context.coordinator.replacePages(
      pages,
      identity: contentIdentity,
      chapterIndex: chapterIndex,
      usesTwoPanes: usesTwoPanes,
      in: controller,
      animated: false
    )
    return controller
  }

  func updateUIViewController(_ pageController: UIPageViewController, context: Context) {
    context.coordinator.parent = self
    configureLayout(pageController)
    context.coordinator.updateFullscreen(isFullscreen, in: pageController)
    context.coordinator.update(
      pages,
      identity: contentIdentity,
      chapterIndex: chapterIndex,
      usesTwoPanes: usesTwoPanes,
      in: pageController
    )
  }

  private func makePageController() -> UIPageViewController {
    let spine: UIPageViewController.SpineLocation = usesTwoPanes ? .mid : .min
    let options: [UIPageViewController.OptionsKey: Any] = [.spineLocation: NSNumber(value: spine.rawValue)]
    return UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: options)
  }

  private func configure(_ controller: UIPageViewController, coordinator: Coordinator) {
    controller.view.backgroundColor = .clear
    configureLayout(controller)
    controller.delegate = coordinator
    controller.dataSource = coordinator
  }

  private func configureLayout(_ controller: UIPageViewController) {
    controller.edgesForExtendedLayout = isFullscreen ? .all : []
    controller.extendedLayoutIncludesOpaqueBars = isFullscreen
  }
}
#endif
