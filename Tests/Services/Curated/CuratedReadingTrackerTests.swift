import Foundation
import SwiftData
import Testing
@testable import WonderRead

struct LastReadCuratedRecordTests {
  @Test func identifiesItselfByChapterAndCodableRoundTrips() throws {
    let record = StoryFixtures.curatedRecord()
    let decoded = try JSONDecoder().decode(LastReadCuratedRecord.self, from: JSONEncoder().encode(record))
    #expect(record.id == record.chapterID)
    #expect(decoded == record)
  }
}

@MainActor
struct CuratedReadingTrackerTests {
  @Test func recordsReloadsAndClearsReadingProgress() throws {
    let container = try StoryDatabaseContainer.makeInMemory()
    let collection = StoryFixtures.collection()
    let chapter = StoryFixtures.chapter(number: 3, source: .curated)
    let tracker = CuratedReadingTracker(modelContainer: container)
    tracker.recordReading(collection: collection, chapter: chapter)
    #expect(tracker.lastRead?.chapterID == chapter.id)

    let restored = CuratedReadingTracker(modelContainer: container)
    #expect(restored.lastRead?.collectionTitle == collection.title)
    tracker.clear()
    #expect(tracker.lastRead == nil)
    let clearedRestored = CuratedReadingTracker(modelContainer: container)
    #expect(clearedRestored.lastRead == nil)
  }
}
