import SwiftUI

struct StoryGenerationLayoutView: View {
  @Environment(\.colorScheme) private var colorScheme

  var geometry: GeometryProxy
  var welcome: StoryGenerationWelcomeView
  var form: StoryGenerationFormPanel

  private var hasDivision: Bool { StoryLayout.hasDivision(in: geometry) }
  private var isWideLandscape: Bool { geometry.size.width >= 960 && geometry.size.width > geometry.size.height }

  var body: some View {
    Group {
      #if os(iOS)
      if #available(iOS 27.1, *), hasDivision {
        dividedLayout
      } else {
        standardLayout
      }
      #else
      standardLayout
      #endif
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(StoryPalette.page(for: colorScheme))
  }

  @ViewBuilder
  private var standardLayout: some View {
    if isWideLandscape {
      StoryGenerationSideBySide(welcome: welcome, form: form)
    } else {
      StoryGenerationSingleColumn(welcome: welcome, form: form, width: geometry.size.width)
    }
  }

  #if os(iOS)
  @available(iOS 27.1, *)
  private var dividedLayout: some View {
    ArrangementView {
      StoryGenerationWelcomeViewPane(welcome: welcome)
    } secondary: {
      StoryGenerationFormPane(form: form)
    }
    .arrangementViewStyle(.split)
    .background(StoryPalette.page(for: colorScheme))
  }
  #endif
}
