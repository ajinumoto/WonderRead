import SwiftUI

// MARK: - Main Doodle Illustration View

struct StoryDoodleIllustrationView: View {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion
  @State private var isFloating = false
  @State private var isSwaying = false

  var chapter: StoryChapter
  var style: StoryDoodleStyle = .fullPage

  private var theme: StoryDoodleTheme {
    StoryDoodleTheme.select(for: chapter)
  }

  var body: some View {
    illustration
      .onAppear(perform: startAnimations)
      .onChange(of: reduceMotion) { _, _ in updateAnimations() }
  }

  @ViewBuilder
  private var illustration: some View {
    switch style {
    case .fullPage:
      StoryDoodleFullPageView(
        chapter: chapter,
        theme: theme,
        isFloating: isFloating,
        isSwaying: isSwaying
      )
    case .thumbnail:
      StoryDoodleThumbnailView(
        theme: theme,
        isFloating: isFloating,
        isSwaying: isSwaying
      )
    }
  }

  private func startAnimations() {
    guard supportsAmbientMotion, !reduceMotion else { return }
    withAnimation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true)) {
      isFloating = true
    }
    withAnimation(.easeInOut(duration: 3.6).repeatForever(autoreverses: true)) {
      isSwaying = true
    }
  }

  private var supportsAmbientMotion: Bool {
    if case .fullPage = style { return true }
    return false
  }

  private func updateAnimations() {
    if reduceMotion { stopAnimations() }
    else { startAnimations() }
  }

  private func stopAnimations() {
    var transaction = Transaction(animation: nil)
    transaction.disablesAnimations = true
    withTransaction(transaction) {
      isFloating = false
      isSwaying = false
    }
  }
}

// MARK: - Full Page Spread View

private struct StoryDoodleFullPageView: View {
  @Environment(\.colorScheme) private var colorScheme
  var chapter: StoryChapter
  var theme: StoryDoodleTheme
  var isFloating: Bool
  var isSwaying: Bool

  var body: some View {
    GeometryReader { geometry in
      let metrics = StoryDoodleMetrics.fullPage(for: geometry.size)
      ZStack {
        StoryDoodleBackdropView(theme: theme, colorScheme: colorScheme, minDimension: metrics.minDimension, isFloating: isFloating)
        VStack(spacing: 20) {
          Spacer(minLength: 0)
          StoryDoodleHeroArtworkView(theme: theme, colorScheme: colorScheme, metrics: metrics, isFloating: isFloating, isSwaying: isSwaying)
          StoryDoodleCaptionView(chapter: chapter, theme: theme, colorScheme: colorScheme)
          Spacer(minLength: 0)
        }
      }
      .frame(width: geometry.size.width, height: geometry.size.height)
    }
  }
}

// MARK: - Thumbnail View

private struct StoryDoodleThumbnailView: View {
  @Environment(\.colorScheme) private var colorScheme
  var theme: StoryDoodleTheme
  var isFloating: Bool
  var isSwaying: Bool

  var body: some View {
    GeometryReader { geometry in
      let metrics = StoryDoodleMetrics.thumbnail(for: geometry.size)
      ZStack {
        StoryDoodleThumbnailBackdropView(theme: theme, colorScheme: colorScheme, metrics: metrics, isFloating: isFloating)
        StoryDoodleThumbnailArtworkView(theme: theme, colorScheme: colorScheme, metrics: metrics, isFloating: isFloating, isSwaying: isSwaying)
      }
      .frame(width: geometry.size.width, height: geometry.size.height)
    }
  }
}

// MARK: - Full Page Backdrop

private struct StoryDoodleBackdropView: View {
  var theme: StoryDoodleTheme
  var colorScheme: ColorScheme
  var minDimension: CGFloat
  var isFloating: Bool

  var body: some View {
    ZStack {
      StoryPalette.surface(for: colorScheme).ignoresSafeArea()
      aura
      RoundedRectangle(cornerRadius: 24, style: .continuous)
        .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [8, 8]))
        .foregroundStyle(theme.primaryColor(for: colorScheme).opacity(0.20))
        .padding(20)
    }
  }

  private var aura: some View {
    Circle()
      .fill(RadialGradient(
        colors: [
          theme.primaryColor(for: colorScheme).opacity(colorScheme == .dark ? 0.22 : 0.14),
          theme.secondaryColor(for: colorScheme).opacity(colorScheme == .dark ? 0.08 : 0.05),
          .clear
        ],
        center: .center,
        startRadius: 20,
        endRadius: minDimension * 0.45
      ))
      .frame(width: minDimension * 0.9, height: minDimension * 0.9)
      .scaleEffect(isFloating ? 1.05 : 0.96)
  }
}

// MARK: - Hero Artwork

private struct StoryDoodleHeroArtworkView: View {
  var theme: StoryDoodleTheme
  var colorScheme: ColorScheme
  var metrics: StoryDoodleMetrics
  var isFloating: Bool
  var isSwaying: Bool

  var body: some View {
    ZStack {
      satellite(at: 0)
      satellite(at: 1)
      satellite(at: 2)
      hero
    }
    .frame(width: metrics.minDimension * 0.75, height: metrics.minDimension * 0.55)
  }

  private func satellite(at index: Int) -> some View {
    let offsets = satelliteOffsets
    let rotations = satelliteRotations
    return StoryDoodleOrbitingSymbol(
      symbol: theme.satelliteSymbols[index],
      size: metrics.satelliteSize * (index == 0 ? 1 : index == 1 ? 0.9 : 0.85),
      primary: index < 2 ? theme.secondaryColor(for: colorScheme) : theme.primaryColor(for: colorScheme),
      secondary: index < 2 ? theme.primaryColor(for: colorScheme) : theme.secondaryColor(for: colorScheme),
      renderingMode: index == 1 ? .hierarchical : .palette,
      effect: index == 1 ? .variableColor : .pulse,
      offset: offsets[index],
      rotation: rotations[index]
    )
  }

  private var hero: some View {
    StoryDoodleOrbitingSymbol(
      symbol: theme.heroSymbol,
      size: metrics.heroSize,
      primary: theme.primaryColor(for: colorScheme),
      secondary: theme.secondaryColor(for: colorScheme),
      renderingMode: .palette,
      effect: .breathe,
      offset: CGSize(width: 0, height: isFloating ? -8 : 8),
      rotation: isSwaying ? 3 : -3,
      isDark: colorScheme == .dark,
      showsHeroShadow: true
    )
  }

  private var satelliteOffsets: [CGSize] {
    [
      CGSize(width: -metrics.heroSize * 0.9, height: -metrics.heroSize * 0.75 + (isFloating ? -8 : 6)),
      CGSize(width: metrics.heroSize * 0.95, height: -metrics.heroSize * 0.65 + (isFloating ? 6 : -8)),
      CGSize(width: metrics.heroSize * 0.85, height: metrics.heroSize * 0.75 + (isFloating ? -6 : 7))
    ]
  }

  private var satelliteRotations: [Double] {
    [isSwaying ? -8 : 6, isSwaying ? 8 : -6, isSwaying ? -6 : 8]
  }
}

// MARK: - Caption

private struct StoryDoodleCaptionView: View {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion
  var chapter: StoryChapter
  var theme: StoryDoodleTheme
  var colorScheme: ColorScheme

  var body: some View {
    VStack(spacing: 6) {
      Text(chapter.title.isEmpty ? String(localized: "Chapter \(chapter.number)") : chapter.title)
        .font(.headline)
        .foregroundStyle(.primary)
        .multilineTextAlignment(.center)
        .lineLimit(2)
        .padding(.horizontal, 32)
      themeLabel
    }
  }

  private var themeLabel: some View {
    HStack(spacing: 6) {
      sparkle
      Text(theme.title)
      sparkle
    }
    .font(.caption.weight(.medium))
    .foregroundStyle(theme.primaryColor(for: colorScheme))
  }

  @ViewBuilder
  private var sparkle: some View {
    if reduceMotion {
      Image(systemName: "sparkles")
    } else {
      Image(systemName: "sparkles")
        .symbolEffect(.pulse, options: .repeat(2))
    }
  }
}

// MARK: - Orbiting Symbol

private struct StoryDoodleOrbitingSymbol: View {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  enum Effect { case pulse, variableColor, breathe }

  var symbol: String
  var size: CGFloat
  var primary: Color
  var secondary: Color
  var renderingMode: SymbolRenderingMode
  var effect: Effect
  var offset: CGSize
  var rotation: Double
  var isDark = false
  var showsHeroShadow = false

  var body: some View {
    animatedSymbol
      .offset(offset)
      .rotationEffect(.degrees(rotation))
  }

  @ViewBuilder
  private var animatedSymbol: some View {
    if reduceMotion {
      styledSymbol
    } else {
      switch effect {
      case .pulse:
        styledSymbol.symbolEffect(.pulse, options: .repeating)
      case .variableColor:
        styledSymbol.symbolEffect(.variableColor.iterative.reversing, options: .repeating)
      case .breathe:
        breathingSymbol
      }
    }
  }

  @ViewBuilder
  private var breathingSymbol: some View {
    if showsHeroShadow {
      styledSymbol
        .symbolEffect(.breathe, options: .repeating)
        .shadow(color: primary.opacity(isDark ? 0.35 : 0.20), radius: 16, y: 8)
    } else {
      styledSymbol.symbolEffect(.breathe, options: .repeating)
    }
  }

  private var styledSymbol: some View {
    Image(systemName: symbol)
      .font(.system(size: size, weight: .medium))
      .symbolRenderingMode(renderingMode)
      .foregroundStyle(primary, secondary)
  }
}

// MARK: - Thumbnail Backdrop

private struct StoryDoodleThumbnailBackdropView: View {
  var theme: StoryDoodleTheme
  var colorScheme: ColorScheme
  var metrics: StoryDoodleMetrics
  var isFloating: Bool

  var body: some View {
    ZStack {
      StoryPalette.surface(for: colorScheme)
      Circle()
        .fill(RadialGradient(
          colors: [theme.primaryColor(for: colorScheme).opacity(0.18), .clear],
          center: .center,
          startRadius: 10,
          endRadius: metrics.minDimension * 0.5
        ))
        .scaleEffect(isFloating ? 1.08 : 0.94)
    }
  }
}

// MARK: - Thumbnail Artwork

private struct StoryDoodleThumbnailArtworkView: View {
  var theme: StoryDoodleTheme
  var colorScheme: ColorScheme
  var metrics: StoryDoodleMetrics
  var isFloating: Bool
  var isSwaying: Bool

  var body: some View {
    ZStack {
      Image(systemName: "sparkle")
        .font(.system(size: metrics.satelliteSize, weight: .semibold))
        .foregroundStyle(theme.secondaryColor(for: colorScheme))
        .offset(x: metrics.heroSize * 0.7, y: -metrics.heroSize * 0.6 + (isFloating ? 3 : -3))
      StoryDoodleOrbitingSymbol(
        symbol: theme.heroSymbol,
        size: metrics.heroSize,
        primary: theme.primaryColor(for: colorScheme),
        secondary: theme.secondaryColor(for: colorScheme),
        renderingMode: .palette,
        effect: .breathe,
        offset: CGSize(width: 0, height: isFloating ? -4 : 4),
        rotation: isSwaying ? 2.5 : -2.5
      )
    }
  }
}
