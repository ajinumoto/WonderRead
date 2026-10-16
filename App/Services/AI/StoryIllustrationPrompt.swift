import Foundation

enum StoryIllustrationPrompt {
  static let aspectRatio = "4:3"
  static let imageSize = "1K"

  static func make(for draft: StoryDraft) -> String {
"""
Create one original, hand-painted children's picture-book illustration for the key moment in chapter “\(draft.chapterTitle)”: \(draft.illustrationPrompt).
Style guide for every chapter in this series: soft watercolor and gouache on warm textured paper; completely borderless, edge-to-edge full-bleed artwork with no frames, borders, margins, or outlines. The environmental background, scenery, and soft watercolor washes must flow seamlessly to every edge of the canvas.
Composition & Safe-Zone Framing: Medium-wide establishing shot. Keep all primary characters, faces, bodies, and vital story interactions strictly centered within the inner 50% safe zone with a generous 25% safety buffer on all four sides (top, bottom, left, right). The outer perimeter must only consist of continuous background elements (sky, meadow, room ambiance) so that cropping in any aspect ratio (portrait, landscape, tabletop, square) never cuts off characters' heads, limbs, or actions. Never place subjects near canvas edges. Warm child-friendly expressions, cohesive warm palette, and absolutely no borders, picture frames, text, lettering, or captions.
"""
  }
}
