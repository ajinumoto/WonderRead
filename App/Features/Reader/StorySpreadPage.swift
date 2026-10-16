import SwiftUI

struct StorySpreadPage<Illustration: View, Story: View>: View {
  @Environment(\.colorScheme) private var colorScheme
  var illustrationPage: Illustration
  var storyPage: Story
  var spineIntensity: Double = 1.0

  var body: some View {
    #if os(iOS)
    foldAwareLayout
    #else
    fallback
    #endif
  }

  #if os(iOS)
  @ViewBuilder
  private var foldAwareLayout: some View {
    if #available(iOS 27.1, *) {
      GeometryReader { geometry in
        if StoryLayout.hasDivision(in: geometry) {
          let orientation = StoryLayout.hingeOrientation(in: geometry)
          let isHorizontal = orientation == .horizontal
          let primaryEdge: BookSpineEdge = isHorizontal ? .bottom : .trailing
          let secondaryEdge: BookSpineEdge = isHorizontal ? .top : .leading
          let primaryAlignment: Alignment = isHorizontal ? .bottom : .trailing
          let secondaryAlignment: Alignment = isHorizontal ? .top : .leading
          let effectiveSpineIntensity = isHorizontal ? 0.0 : spineIntensity

          if isHorizontal {
            let topHeight = geometry.reservedRegions(kind: .division, options: .includeInactive).first?.frame.minY ?? (geometry.size.height * 0.5)
            let hingeGap = (geometry.reservedRegions(kind: .division).first?.isActive == true)
              ? (geometry.reservedRegions(kind: .division).first?.frame.height ?? 0)
              : 0

            VStack(spacing: 0) {
              illustrationPage
                .frame(maxWidth: .infinity)
                .frame(height: topHeight)
                .clipped()
                .overlay(alignment: primaryAlignment) {
                  if effectiveSpineIntensity > 0 {
                    BookSpineShadow(edge: primaryEdge, width: 32, intensity: effectiveSpineIntensity, showsCreaseLine: true)
                  }
                }

              if hingeGap > 0 {
                Color.clear
                  .frame(height: hingeGap)
              }

              storyPage
                .safeAreaPadding(.horizontal)
                .safeAreaPadding(.bottom)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(alignment: secondaryAlignment) {
                  if effectiveSpineIntensity > 0 {
                    BookSpineShadow(edge: secondaryEdge, width: 32, intensity: effectiveSpineIntensity, showsCreaseLine: true)
                  }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(StoryPalette.surface(for: colorScheme))
          } else {
            let leftWidth = geometry.reservedRegions(kind: .division, options: .includeInactive).first?.frame.minX ?? (geometry.size.width * 0.5)
            let hingeGap = (geometry.reservedRegions(kind: .division).first?.isActive == true)
              ? (geometry.reservedRegions(kind: .division).first?.frame.width ?? 0)
              : 0

            HStack(spacing: 0) {
              illustrationPage
                .frame(width: leftWidth, height: geometry.size.height)
                .clipped()
                .overlay(alignment: primaryAlignment) {
                  if effectiveSpineIntensity > 0 {
                    BookSpineShadow(edge: primaryEdge, width: 32, intensity: effectiveSpineIntensity, showsCreaseLine: true)
                  }
                }

              if hingeGap > 0 {
                Color.clear
                  .frame(width: hingeGap)
              }

              storyPage
                .safeAreaPadding(.horizontal)
                .safeAreaPadding(.bottom)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(alignment: secondaryAlignment) {
                  if effectiveSpineIntensity > 0 {
                    BookSpineShadow(edge: secondaryEdge, width: 32, intensity: effectiveSpineIntensity, showsCreaseLine: true)
                  }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(StoryPalette.surface(for: colorScheme))
          }
        } else {
          fallback
        }
      }
    } else {
      fallback
    }
  }
  #endif

  private var fallback: some View {
    GeometryReader { geometry in
      let isPortrait = geometry.size.height > geometry.size.width
      if isPortrait {
        VStack(spacing: 0) {
          illustrationPage
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()

          storyPage
            .safeAreaPadding(.horizontal)
            .safeAreaPadding(.bottom)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      } else {
        HStack(spacing: 0) {
          illustrationPage
            .frame(maxHeight: .infinity)
            .overlay(alignment: .trailing) {
              BookSpineShadow(edge: .trailing, width: 32, intensity: spineIntensity, showsCreaseLine: true)
            }
          storyPage
            .safeAreaPadding(.horizontal)
            .safeAreaPadding(.bottom)
            .frame(maxHeight: .infinity)
            .overlay(alignment: .leading) {
              BookSpineShadow(edge: .leading, width: 32, intensity: spineIntensity, showsCreaseLine: true)
            }
        }
      }
    }
    .frame(maxWidth: 1400)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(StoryPalette.surface(for: colorScheme))
    .overlay {
      Rectangle()
        .stroke(StoryPalette.line(for: colorScheme), lineWidth: 0.5)
        .allowsHitTesting(false)
    }
  }
}
