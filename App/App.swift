import SwiftUI
import SwiftData

@main
struct AppDefinition: App {
  @State private var storyLibrary = StoryLibrary()
  @State private var preferences = StoryPreferencesStore()
  @State private var curatedReadingTracker = CuratedReadingTracker()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(storyLibrary)
        .environment(preferences)
        .environment(curatedReadingTracker)
        .modelContainer(StoryDatabaseContainer.shared)
    }

    #if os(macOS)
    Settings {
      StoryPreferencesSettingsView()
        .environment(storyLibrary)
        .environment(preferences)
        .environment(curatedReadingTracker)
        .modelContainer(StoryDatabaseContainer.shared)
    }
    #endif
  }
}
