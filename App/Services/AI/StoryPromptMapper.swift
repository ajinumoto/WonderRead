import Foundation

enum StoryPromptMapper {
  static func map(request: StoryGenerationRequest, language: String, includesIllustrationPrompt: Bool, recovery: Bool) -> StoryPromptContext {
    let preferences = request.preferences
    let idea = request.customIdea?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    return StoryPromptContext(
      targetLanguage: language.isEmpty ? "English" : language,
      childName: fallback(request.preferences.nickname, String(localized: "main character")),
      childInterests: fallback(preferences.interests, String(localized: "adventure and exploration")),
      age: preferences.age,
      style: preferences.style,
      theme: preferences.theme,
      moral: preferences.moral,
      factorsDescription: request.selectedFactors.promptDescription,
      ideaText: idea.isEmpty ? "" : "Ide tambahan: \(sanitizeUserIdea(idea)).",
      includesIllustrationPrompt: includesIllustrationPrompt,
      recovery: recovery
    )
  }

  static func sanitizeUserIdea(_ idea: String) -> String {
    let forbiddenPatterns = ["ignore previous", "system prompt", "system override", "abaikan instruksi"]
    var cleaned = idea.trimmingCharacters(in: .whitespacesAndNewlines)
    for pattern in forbiddenPatterns {
      cleaned = cleaned.replacingOccurrences(of: pattern, with: "", options: .caseInsensitive)
    }
    return cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  private static func fallback(_ value: String, _ fallbackValue: String) -> String {
    let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines)
    return normalized.isEmpty ? fallbackValue : normalized
  }
}
