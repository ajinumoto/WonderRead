import Foundation

enum StoryDraftValidator {
  static func validate(_ draft: StoryDraft) throws -> StoryDraft {
    let normalized = normalize(draft)
    guard isComplete(normalized) else {
      throw StoryGenerationError.invalidResponse
    }
    return normalized
  }

  private static func normalize(_ draft: StoryDraft) -> StoryDraft {
    let paragraphs = draft.paragraphs
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      .filter { !$0.isEmpty }
    let chapterTitle = draft.chapterTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    let seriesTitle = draft.seriesTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    let finalTitle = !chapterTitle.isEmpty ? chapterTitle : seriesTitle
    let illustrationPrompt = draft.illustrationPrompt.trimmingCharacters(in: .whitespacesAndNewlines)

    return StoryDraft(
      seriesTitle: finalTitle,
      chapterTitle: finalTitle,
      summary: draft.summary.trimmingCharacters(in: .whitespacesAndNewlines),
      paragraphs: paragraphs,
      illustrationPrompt: illustrationPrompt
    )
  }

  private static func isComplete(_ draft: StoryDraft) -> Bool {
    !draft.chapterTitle.isEmpty && draft.paragraphs.count >= 3
      && hasCompleteEnding(draft.paragraphs.last ?? "")
  }

  static func decode(from text: String) -> StoryDraft? {
    let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
    if let data = trimmed.data(using: .utf8),
       let draft = try? JSONDecoder().decode(StoryDraft.self, from: data) {
      return draft
    }

    guard let openingBrace = trimmed.firstIndex(of: "{"),
          let closingBrace = trimmed.lastIndex(of: "}"),
          openingBrace < closingBrace else {
      return nil
    }
    return String(trimmed[openingBrace...closingBrace])
      .data(using: .utf8)
      .flatMap { try? JSONDecoder().decode(StoryDraft.self, from: $0) }
  }

  private static func hasCompleteEnding(_ paragraph: String) -> Bool {
    let terminalCharacters: Set<Character> = [".", "!", "?", "…", "。", "！", "？"]
    let closingQuotes: Set<Character> = ["\"", "'", "”", "’", "»", "」", "』", ")", "]"]
    let ending = paragraph.reversed().drop(while: { closingQuotes.contains($0) }).first
    return ending.map(terminalCharacters.contains) ?? false
  }
}
