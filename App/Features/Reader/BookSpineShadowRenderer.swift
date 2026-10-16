import SwiftUI

struct BookSpineShadowRenderer: View {
  var edge: BookSpineEdge
  var width: CGFloat
  var shadowColor: Color
  var creaseColor: Color
  var showsCreaseLine: Bool

  var body: some View {
    if edge.isHorizontal { horizontalLayout } else { verticalLayout }
  }

  private var horizontalLayout: some View {
    HStack(spacing: 0) {
      if edge == .leading && showsCreaseLine { creaseLine }
      if edge == .trailing { Spacer(minLength: 0) }
      gradient
      if edge == .trailing && showsCreaseLine { creaseLine }
      if edge == .leading { Spacer(minLength: 0) }
    }
  }

  private var verticalLayout: some View {
    VStack(spacing: 0) {
      if edge == .top && showsCreaseLine { creaseLine }
      if edge == .bottom { Spacer(minLength: 0) }
      gradient
      if edge == .bottom && showsCreaseLine { creaseLine }
      if edge == .top { Spacer(minLength: 0) }
    }
  }

  private var gradient: some View {
    let colors = edge.isForward ? stops.reversed() : stops
    return LinearGradient(colors: colors, startPoint: startPoint, endPoint: endPoint)
      .frame(width: edge.isHorizontal ? width : nil, height: edge.isHorizontal ? nil : width)
  }

  private var stops: [Color] {
    [
      shadowColor,
      shadowColor.opacity(0.65),
      shadowColor.opacity(0.25),
      .clear
    ]
  }

  private var creaseLine: some View {
    Rectangle()
      .fill(creaseColor)
      .frame(width: edge.isHorizontal ? 1.5 : nil, height: edge.isHorizontal ? nil : 1.5)
  }

  private var startPoint: UnitPoint { edge.isHorizontal ? .leading : .top }
  private var endPoint: UnitPoint { edge.isHorizontal ? .trailing : .bottom }
}
