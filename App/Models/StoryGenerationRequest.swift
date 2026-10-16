import Foundation

struct StoryGenerationRequest: Sendable {
  var preferences: StoryPreferences
  var customIdea: String?
  var selectedFactors: SelectedStoryFactors
}
