import Foundation
import Testing
@testable import WonderRead

struct ShelfSecondaryPaneSelectionMapperTests {
  @Test func selectsEmptyFeaturedOrResumeContent() {
    if case .empty = ShelfSecondaryPaneSelectionMapper.selection(lastRead: nil, collections: []) { } else {
      Issue.record("An empty library should show the empty pane.")
    }
    let featured = StoryFixtures.collection()
    if case .featured(let selected) = ShelfSecondaryPaneSelectionMapper.selection(lastRead: nil, collections: [featured]) {
      #expect(selected.id == featured.id)
    } else {
      Issue.record("The first collection should be featured when there is no reading record.")
    }
  }

  @Test func resumesMatchingCollectionAndAllowsMissingCollectionFallback() throws {
    let collection = StoryFixtures.collection()
    let record = StoryFixtures.curatedRecord(collectionID: collection.id)
    if case .resume(let savedRecord, let matched) = ShelfSecondaryPaneSelectionMapper.selection(lastRead: record, collections: [collection]) {
      #expect(savedRecord == record)
      #expect(matched?.id == collection.id)
    } else {
      Issue.record("A saved reading record should select the resume pane.")
    }
    let fallback = ShelfSecondaryPaneSelectionMapper.resumeTarget(record: record, collection: nil)
    let chapter = try #require(fallback.chapters.first)
    #expect(fallback.id == record.collectionID)
    #expect(fallback.title == record.collectionTitle)
    #expect(chapter.id == record.chapterID)
    #expect(chapter.source == .curated)
  }
}
