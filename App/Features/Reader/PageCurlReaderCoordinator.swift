import SwiftUI

#if os(iOS)
import UIKit

final class PageCurlReaderCoordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  private struct PendingPageUpdate {
    var pages: [ReaderPageView]
    var identity: AnyHashable
    var chapterIndex: Int
    var usesTwoPanes: Bool
  }

  var parent: PageCurlReaderView
  private(set) var pages: [ReaderPageView] = []
  private var hostingControllerCache: [Int: UIHostingController<ReaderPageView>] = [:]
  private var cachedUsesTwoPanes = false
  private var contentIdentity: AnyHashable?
  private var isTransitioning = false
  private var pendingPageUpdate: PendingPageUpdate?

  var cachedControllerCount: Int {
    hostingControllerCache.count
  }

  init(_ parent: PageCurlReaderView) { self.parent = parent }

  func update(
    _ pages: [ReaderPageView], identity: AnyHashable, chapterIndex: Int, usesTwoPanes: Bool,
    in pageController: UIPageViewController
  ) {
    if isTransitioning {
      pendingPageUpdate = PendingPageUpdate(pages: pages, identity: identity, chapterIndex: chapterIndex, usesTwoPanes: usesTwoPanes)
      return
    }
    guard !replacePagesIfNeeded(pages, identity: identity, chapterIndex: chapterIndex, usesTwoPanes: usesTwoPanes, in: pageController) else { return }
    updateRootViews(pages, usesTwoPanes: usesTwoPanes)
    guard !pages.isEmpty else { return }
    syncToChapter(chapterIndex, usesTwoPanes: usesTwoPanes, in: pageController)
  }

  private func replacePagesIfNeeded(
    _ pages: [ReaderPageView], identity: AnyHashable, chapterIndex: Int, usesTwoPanes: Bool,
    in controller: UIPageViewController
  ) -> Bool {
    guard needsReplacement(for: pages, identity: identity, usesTwoPanes: usesTwoPanes) else { return false }
    replacePages(pages, identity: identity, chapterIndex: chapterIndex, usesTwoPanes: usesTwoPanes, in: controller, animated: false)
    return true
  }

  private func needsReplacement(for pages: [ReaderPageView], identity: AnyHashable, usesTwoPanes: Bool) -> Bool {
    contentIdentity != identity || self.pages.count != pages.count || cachedUsesTwoPanes != usesTwoPanes
  }

  private func updateRootViews(_ pages: [ReaderPageView], usesTwoPanes: Bool) {
    self.pages = pages
    cachedUsesTwoPanes = usesTwoPanes
    for (index, controller) in hostingControllerCache where pages.indices.contains(index) {
      controller.rootView = pages[index]
    }
  }

  private func syncToChapter(_ chapterIndex: Int, usesTwoPanes: Bool, in pageController: UIPageViewController) {
    guard !pages.isEmpty else { return }
    syncVisibleControllers(visibleIndices(chapterIndex: chapterIndex, usesTwoPanes: usesTwoPanes), in: pageController)
  }

  private func visibleIndices(chapterIndex: Int, usesTwoPanes: Bool) -> [Int] {
    guard !pages.isEmpty else { return [] }
    let first = usesTwoPanes ? min(max(chapterIndex * 2, 0), max(pages.count - 2, 0))
      : min(max(chapterIndex, 0), pages.count - 1)
    guard usesTwoPanes else { return [first] }
    guard first + 1 < pages.count else { return [] }
    return [first, first + 1]
  }

  private func syncVisibleControllers(_ indices: [Int], in controller: UIPageViewController) {
    guard !indices.isEmpty, currentVisibleIndices(in: controller) != indices else { return }
    let controllers = indices.compactMap { self.controller(at: $0) }
    guard controllers.count == indices.count else { return }
    controller.setViewControllers(controllers, direction: .forward, animated: false)
    pruneControllerCache(keepingAround: indices, activeIn: controller)
  }

  private func currentVisibleIndices(in controller: UIPageViewController) -> [Int] {
    (controller.viewControllers ?? []).compactMap { index(of: $0) }
  }

  func replacePages(
    _ pages: [ReaderPageView], identity: AnyHashable, chapterIndex: Int, usesTwoPanes: Bool,
    in pageController: UIPageViewController, animated: Bool
  ) {
    contentIdentity = identity
    self.pages = pages
    cachedUsesTwoPanes = usesTwoPanes
    hostingControllerCache.removeAll()
    guard !pages.isEmpty else { return }
    pageController.isDoubleSided = usesTwoPanes
    let indices = visibleIndices(chapterIndex: chapterIndex, usesTwoPanes: usesTwoPanes)
    let controllers = indices.compactMap { controller(at: $0) }
    guard controllers.count == indices.count, !controllers.isEmpty else { return }
    pageController.setViewControllers(controllers, direction: .forward, animated: animated)
    pruneControllerCache(keepingAround: indices, activeIn: pageController)
  }

  func controller(at index: Int) -> UIHostingController<ReaderPageView>? {
    guard pages.indices.contains(index) else { return nil }
    if let cached = hostingControllerCache[index] {
      cached.rootView = pages[index]
      applySafeArea(to: cached)
      return cached
    }
    let hosting = UIHostingController(rootView: pages[index])
    hosting.view.backgroundColor = .clear
    applySafeArea(to: hosting)
    hostingControllerCache[index] = hosting
    return hosting
  }

  func updateFullscreen(_ isFullscreen: Bool, in pageController: UIPageViewController) {
    guard #available(iOS 16.4, *) else { return }
    let targetRegions: SafeAreaRegions = (isFullscreen || parent.ignoresPageSafeArea) ? [] : .all
    for controller in hostingControllerCache.values where controller.safeAreaRegions != targetRegions {
      controller.safeAreaRegions = targetRegions
    }
  }

  private func applySafeArea(to hosting: UIHostingController<ReaderPageView>) {
    if #available(iOS 16.4, *) {
      hosting.safeAreaRegions = (parent.isFullscreen || parent.ignoresPageSafeArea) ? [] : .all
    }
  }

  private func index(of viewController: UIViewController) -> Int? {
    hostingControllerCache.first(where: { $0.value === viewController })?.key
  }

  private func pruneControllerCache(keepingAround indices: [Int], activeIn pageController: UIPageViewController) {
    guard let minIndex = indices.min(), let maxIndex = indices.max() else { return }
    let window = (minIndex - 2)...(maxIndex + 2)
    let activeControllers = Set((pageController.viewControllers ?? []).map(ObjectIdentifier.init))
    hostingControllerCache = hostingControllerCache.filter { index, controller in
      window.contains(index) || activeControllers.contains(ObjectIdentifier(controller))
    }
  }

  func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    isTransitioning = true
  }

  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerBefore viewController: UIViewController
  ) -> UIViewController? {
    guard let index = index(of: viewController), index > 0 else { return nil }
    return controller(at: index - 1)
  }

  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerAfter viewController: UIViewController
  ) -> UIViewController? {
    guard let index = index(of: viewController), index + 1 < pages.count else { return nil }
    return controller(at: index + 1)
  }

  func pageViewController(
    _ pageViewController: UIPageViewController,
    didFinishAnimating finished: Bool,
    previousViewControllers: [UIViewController],
    transitionCompleted completed: Bool
  ) {
    isTransitioning = false
    finishTransition(completed: completed, in: pageViewController)
  }

  private func finishTransition(completed: Bool, in controller: UIPageViewController) {
    let visibleIndex = visibleReaderPageIndex(in: controller, usesTwoPanes: parent.usesTwoPanes) ?? parent.chapterIndex
    guard let update = takePendingPageUpdate() else {
      if completed {
        let kept = visibleIndices(chapterIndex: visibleIndex, usesTwoPanes: parent.usesTwoPanes)
        pruneControllerCache(keepingAround: kept, activeIn: controller)
        parent.onChapterChanged(visibleIndex)
      }
      return
    }
    apply(update, at: completed ? visibleIndex : update.chapterIndex, in: controller)
  }

  private func takePendingPageUpdate() -> PendingPageUpdate? {
    defer { pendingPageUpdate = nil }
    return pendingPageUpdate
  }

  private func apply(_ update: PendingPageUpdate, at chapterIndex: Int, in controller: UIPageViewController) {
    if needsReplacement(for: update.pages, identity: update.identity, usesTwoPanes: update.usesTwoPanes) {
      replacePages(update.pages, identity: update.identity, chapterIndex: chapterIndex, usesTwoPanes: update.usesTwoPanes, in: controller, animated: false)
    } else {
      updateRootViews(update.pages, usesTwoPanes: update.usesTwoPanes)
      syncToChapter(chapterIndex, usesTwoPanes: update.usesTwoPanes, in: controller)
    }
    parent.onChapterChanged(chapterIndex)
  }

  private func visibleReaderPageIndex(in controller: UIPageViewController, usesTwoPanes: Bool) -> Int? {
    guard let visible = controller.viewControllers?.first,
          let index = index(of: visible) else { return nil }
    return usesTwoPanes ? index / 2 : index
  }

  func pageViewController(
    _ pageViewController: UIPageViewController,
    spineLocationFor orientation: UIInterfaceOrientation
  ) -> UIPageViewController.SpineLocation {
    let usesTwoPanes = parent.usesTwoPanes
    cachedUsesTwoPanes = usesTwoPanes
    pageViewController.isDoubleSided = usesTwoPanes
    let indices = visibleIndices(chapterIndex: parent.chapterIndex, usesTwoPanes: usesTwoPanes)
    let controllers = indices.compactMap { controller(at: $0) }
    if !isTransitioning, controllers.count == indices.count, !controllers.isEmpty {
      pageViewController.setViewControllers(controllers, direction: .forward, animated: false)
    }
    return usesTwoPanes ? .mid : .min
  }
}
#endif
