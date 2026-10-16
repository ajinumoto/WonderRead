import Foundation
import Observation

@MainActor
@Observable
final class StoryPreferencesStore {
  private enum Key {
    static let nickname = "profile.nickname"
    static let age = "profile.age"
    static let interests = "profile.interests"
    static let style = "story.style"
    static let theme = "story.theme"
    static let moral = "story.moral"
  }

  @ObservationIgnored private let defaults: UserDefaults

  var nickname: String {
    didSet { defaults.set(nickname, forKey: Key.nickname) }
  }

  var childAge: Int {
    didSet { defaults.set(childAge, forKey: Key.age) }
  }

  var interests: String {
    didSet { defaults.set(interests, forKey: Key.interests) }
  }

  var storyStyle: String {
    didSet { defaults.set(storyStyle, forKey: Key.style) }
  }

  var storyTheme: String {
    didSet { defaults.set(storyTheme, forKey: Key.theme) }
  }

  var storyMoral: String {
    didSet { defaults.set(storyMoral, forKey: Key.moral) }
  }

  var storyPreferences: StoryPreferences {
    StoryPreferences(
      nickname: nickname.trimmingCharacters(in: .whitespacesAndNewlines),
      age: childAge,
      interests: interests.trimmingCharacters(in: .whitespacesAndNewlines),
      style: storyStyle,
      theme: storyTheme,
      moral: storyMoral
    )
  }

  init(defaults: UserDefaults = .standard) {
    self.defaults = defaults
    nickname = defaults.string(forKey: Key.nickname) ?? ""
    childAge = defaults.object(forKey: Key.age) as? Int ?? 6
    interests = defaults.string(forKey: Key.interests) ?? ""
    storyStyle = defaults.string(forKey: Key.style) ?? "Hangat"
    storyTheme = defaults.string(forKey: Key.theme) ?? "Petualangan"
    storyMoral = defaults.string(forKey: Key.moral) ?? "Berani mencoba"
  }
}
