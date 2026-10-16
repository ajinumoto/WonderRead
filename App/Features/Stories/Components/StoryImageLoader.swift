import Foundation
import ImageIO
import Nuke
import NukeUI
import SwiftUI

enum StoryImageLoader {
  static let sharedPipeline: ImagePipeline = {
    var config = ImagePipeline.Configuration.withDataCache(
      name: "id.co.aspamungkas.WonderRead.ImageCache",
      sizeLimit: 150 * 1024 * 1024 // 150 MB disk cache
    )
    config.imageCache = ImageCache()
    return ImagePipeline(configuration: config)
  }()

  static func resolveURL(
    for filenameOrURL: String,
    storiesDirectory: URL? = nil,
    fileManager: FileManager = .default
  ) -> URL? {
    let trimmed = filenameOrURL.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return nil }

    if trimmed.hasPrefix("http://") || trimmed.hasPrefix("https://") {
      guard let url = URL(string: trimmed),
            let scheme = url.scheme?.lowercased(),
            ["http", "https"].contains(scheme) else { return nil }
      return url
    }
    guard let safeName = StoryArchive.sanitizedFilename(trimmed) else { return nil }
    return StoryArchive.illustrationURL(for: safeName, storiesDirectory: storiesDirectory, fileManager: fileManager)
  }

  static func loadImageData(
    for filenameOrURL: String,
    storiesDirectory: URL? = nil,
    fileManager: FileManager = .default
  ) async -> Data? {
    guard let url = resolveURL(for: filenameOrURL, storiesDirectory: storiesDirectory, fileManager: fileManager) else { return nil }
    if url.isFileURL {
      return try? Data(contentsOf: url)
    }
    if let cached = cachedData(for: url) { return cached }
    return await downloadData(from: url)
  }

  private static func cachedData(for url: URL) -> Data? {
    guard let data = sharedPipeline.configuration.dataCache?.cachedData(for: url.absoluteString), !data.isEmpty else {
      return nil
    }
    return data
  }

  private static func downloadData(from url: URL) async -> Data? {
    do {
      let (data, _) = try await sharedPipeline.data(for: ImageRequest(url: url))
      return data
    } catch {
      #if DEBUG
      print("Nuke failed to load data for \(url): \(error.localizedDescription)")
      #endif
      return nil
    }
  }

  static func makeImage(from data: Data?) -> Image? {
    guard let data,
          !data.isEmpty,
          let source = CGImageSourceCreateWithData(data as CFData, nil),
          let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
      return nil
    }
    return Image(decorative: cgImage, scale: 1)
  }
}
