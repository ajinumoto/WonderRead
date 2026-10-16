import Foundation

struct StoryDraft: Codable, Sendable {
  var seriesTitle: String
  var chapterTitle: String
  var summary: String
  var paragraphs: [String]
  var illustrationPrompt: String

  enum CodingKeys: String, CodingKey {
    case seriesTitle
    case chapterTitle
    case summary
    case paragraphs
    case illustrationPrompt
  }

  init(
    seriesTitle: String = "",
    chapterTitle: String = "",
    summary: String = "",
    paragraphs: [String] = [],
    illustrationPrompt: String = ""
  ) {
    self.seriesTitle = seriesTitle
    self.chapterTitle = chapterTitle
    self.summary = summary
    self.paragraphs = paragraphs
    self.illustrationPrompt = illustrationPrompt
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let chapter = try container.decodeIfPresent(String.self, forKey: .chapterTitle) ?? ""
    let series = try container.decodeIfPresent(String.self, forKey: .seriesTitle) ?? ""
    self.chapterTitle = chapter.isEmpty ? series : chapter
    self.seriesTitle = series.isEmpty ? self.chapterTitle : series
    self.summary = try container.decodeIfPresent(String.self, forKey: .summary) ?? ""
    self.paragraphs = try container.decodeIfPresent([String].self, forKey: .paragraphs) ?? []
    self.illustrationPrompt = try container.decodeIfPresent(String.self, forKey: .illustrationPrompt) ?? ""
  }
}
