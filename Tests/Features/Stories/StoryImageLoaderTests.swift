import Foundation
import Testing
@testable import WonderRead

struct StoryImageLoaderTests {
  @Test func resolvesRemoteAndRejectsEmptyOrMissingLocalImages() {
    #expect(StoryImageLoader.resolveURL(for: " https://example.test/a.png ")?.absoluteString == "https://example.test/a.png")
    #expect(StoryImageLoader.resolveURL(for: " ") == nil)
    #expect(StoryImageLoader.resolveURL(for: "missing.png", storiesDirectory: temporaryDirectory()) == nil)
  }

  @Test func decodesValidImageAndRejectsInvalidData() throws {
    let imageData = try #require(Data(base64Encoded: "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAADUlEQVR4nGP4z8AAAAMBAQDJ/pLvAAAAAElFTkSuQmCC"))
    #expect(StoryImageLoader.makeImage(from: imageData) != nil)
    #expect(StoryImageLoader.makeImage(from: nil) == nil)
    #expect(StoryImageLoader.makeImage(from: Data()) == nil)
    #expect(StoryImageLoader.makeImage(from: Data([1, 2, 3])) == nil)
  }
}

private func temporaryDirectory() -> URL {
  FileManager.default.temporaryDirectory.appendingPathComponent("WonderReadImageTests-\(UUID().uuidString)", isDirectory: true)
}
