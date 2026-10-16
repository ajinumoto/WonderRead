import Foundation

enum StoryPromptBuilder {
  static func make(
    for request: StoryGenerationRequest,
    language: String,
    includesIllustrationPrompt: Bool,
    recovery: Bool = false
  ) -> String {
    let context = StoryPromptMapper.map(
      request: request,
      language: language,
      includesIllustrationPrompt: includesIllustrationPrompt,
      recovery: recovery
    )
    return StoryPromptTemplate.render(context)
  }
}
