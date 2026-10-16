import SwiftUI

struct StoryReaderToolbar: ToolbarContent {
  var isVisible = true
  var readerTextSize: Int
  var canGoToPrevious: Bool
  var canGoToNext: Bool = true
  var isCompactHeight = false
  var reduceMotion = false
  var previousActionCount = 0
  var nextActionCount = 0
  var onPrevious: () -> Void
  var onNext: () -> Void
  var onDecreaseText: () -> Void
  var onIncreaseText: () -> Void

  var body: some ToolbarContent {
    if isVisible {
      #if os(iOS)
      leadingNavigationItems
      bottomTextSizeItems
      #else
      macToolbarItems
      #endif
    }
  }

  #if os(iOS)
  @ToolbarContentBuilder
  private var leadingNavigationItems: some ToolbarContent {
    if #available(iOS 27.0, *) {
      ToolbarItemGroup(placement: .topBarLeading) {
        previousButton
        nextButton
      }
      .visibilityPriority(.high)
    } else {
      ToolbarItemGroup(placement: .topBarLeading) {
        previousButton
        nextButton
      }
    }
  }

  @ToolbarContentBuilder
  private var bottomTextSizeItems: some ToolbarContent {
    if !isCompactHeight {
      if #available(iOS 27.0, *) {
        ToolbarItemGroup(placement: .bottomBar) {
          decreaseTextButton
          increaseTextButton
        }
        .visibilityPriority(.low)
      } else {
        ToolbarItemGroup(placement: .bottomBar) {
          decreaseTextButton
          increaseTextButton
        }
      }
    }
  }
  #else
  @ToolbarContentBuilder
  private var macToolbarItems: some ToolbarContent {
    ToolbarItemGroup(placement: .automatic) {
      previousButton
      nextButton
      decreaseTextButton
      increaseTextButton
    }
  }
  #endif

  private var previousButton: some View {
    Button(action: onPrevious) {
      Label {
        Text(String(localized: "Previous page", comment: "Localized app copy."))
      } icon: {
        animatedToolbarSymbol("arrow.left", trigger: previousActionCount)
      }
    }
    .disabled(!canGoToPrevious)
    .keyboardShortcut(.leftArrow, modifiers: [])
  }

  private var nextButton: some View {
    Button(action: onNext) {
      Label {
        Text(String(localized: "Next page", comment: "Localized app copy."))
      } icon: {
        animatedToolbarSymbol("arrow.right", trigger: nextActionCount)
      }
    }
    .disabled(!canGoToNext)
    .keyboardShortcut(.rightArrow, modifiers: [])
  }

  private var decreaseTextButton: some View {
    Button(action: onDecreaseText) {
      Label {
        Text(String(localized: "Decrease story text size", comment: "Localized app copy."))
      } icon: {
        animatedToolbarSymbol("textformat.size.smaller", trigger: readerTextSize)
      }
    }
    .disabled(readerTextSize == 0)
    .keyboardShortcut("-", modifiers: .command)
  }

  private var increaseTextButton: some View {
    Button(action: onIncreaseText) {
      Label {
        Text(String(localized: "Increase story text size", comment: "Localized app copy."))
      } icon: {
        animatedToolbarSymbol("textformat.size.larger", trigger: readerTextSize)
      }
    }
    .disabled(readerTextSize == 4)
    .keyboardShortcut("=", modifiers: .command)
  }

  @ViewBuilder
  private func animatedToolbarSymbol(_ name: String, trigger: Int) -> some View {
    if reduceMotion {
      Image(systemName: name)
    } else {
      Image(systemName: name)
        .symbolEffect(.bounce, value: trigger)
    }
  }
}
