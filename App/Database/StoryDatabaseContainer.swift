import Foundation
import SwiftData

enum StoryDatabaseContainer {
  static let schema = Schema([
    StoryCollectionEntity.self,
    StoryChapterEntity.self,
    ReadingProgressEntity.self
  ])

  static let shared: ModelContainer = {
    do {
      return try makeContainer(inMemory: false)
    } catch {
      fatalError("Failed to initialize SwiftData ModelContainer: \(error)")
    }
  }()

  static func makeInMemory() throws -> ModelContainer {
    try makeContainer(inMemory: true)
  }

  static func makeContainer(inMemory: Bool) throws -> ModelContainer {
    let configuration = ModelConfiguration(
      "WonderReadDatabase",
      schema: schema,
      isStoredInMemoryOnly: inMemory
    )
    return try initializeContainer(configuration: configuration)
  }

  private static func initializeContainer(
    configuration: ModelConfiguration
  ) throws -> ModelContainer {
    do {
      return try ModelContainer(for: schema, configurations: [configuration])
    } catch {
      guard !configuration.isStoredInMemoryOnly else { throw error }
      cleanStoreFiles(at: configuration.url)
      return try ModelContainer(for: schema, configurations: [configuration])
    }
  }

  private static func cleanStoreFiles(at url: URL) {
    let fileManager = FileManager.default
    let timestamp = Int(Date().timeIntervalSince1970)
    let paths = [
      url.path,
      url.path + "-shm",
      url.path + "-wal"
    ]
    for path in paths where fileManager.fileExists(atPath: path) {
      let backupPath = "\(path).corrupt.\(timestamp)"
      try? fileManager.moveItem(atPath: path, toPath: backupPath)
    }
  }
}
