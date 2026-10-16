import Foundation
import Testing
@testable import WonderRead

struct StoryDraftValidatorTests {
  @Test func trimsFieldsAndFallsBackToSeriesTitle() throws {
    let draft = StoryDraft(seriesTitle: "  Series  ", chapterTitle: " ", summary: " Summary ", paragraphs: [" One ", " ", " Two ", " End! "], illustrationPrompt: " Scene ")
    let result = try StoryDraftValidator.validate(draft)
    #expect(result.chapterTitle == "Series")
    #expect(result.seriesTitle == "Series")
    #expect(result.paragraphs == ["One", "Two", "End!"])
    #expect(result.illustrationPrompt == "Scene")
  }

  @Test(arguments: ["Finished.", "Finished!", "Finished?", "Finished…", "完了。", "Done!\u{201D}"])
  func acceptsCompleteLocalizedEndings(_ ending: String) throws {
    let draft = StoryDraft(chapterTitle: "Title", paragraphs: ["One", "Two", ending])
    #expect(try StoryDraftValidator.validate(draft).paragraphs.last == ending)
  }

  @Test func rejectsIncompleteDrafts() {
    let tooShort = StoryDraft(chapterTitle: "Title", paragraphs: ["One.", "Two."])
    let dangling = StoryDraft(chapterTitle: "Title", paragraphs: ["One.", "Two.", "And then"])
    expectInvalidResponse(tooShort)
    expectInvalidResponse(dangling)
  }

  @Test func decodesPlainJSONAndJSONWrappedInProse() throws {
    let json = #"{"chapterTitle":"Star","paragraphs":["A","B","C."]}"#
    let plain = try #require(StoryDraftValidator.decode(from: json))
    let wrapped = try #require(StoryDraftValidator.decode(from: "Here is the story: \(json) Thank you."))
    #expect(plain.chapterTitle == "Star")
    #expect(wrapped.paragraphs == plain.paragraphs)
  }

  @Test func returnsNilForMalformedOrMissingJSON() {
    #expect(StoryDraftValidator.decode(from: "no JSON") == nil)
    #expect(StoryDraftValidator.decode(from: "{not valid}") == nil)
  }
}

private func expectInvalidResponse(_ draft: StoryDraft) {
  do {
    _ = try StoryDraftValidator.validate(draft)
    Issue.record("Expected an incomplete draft to be rejected.")
  } catch StoryGenerationError.invalidResponse {
  } catch {
    Issue.record("Unexpected error: \(error)")
  }
}
