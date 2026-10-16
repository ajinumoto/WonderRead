import Foundation
import Security
import Testing
@testable import WonderRead

struct SecureAPIKeyStoreKeyTests {
  @Test func providesStableGeminiKeychainIdentity() {
    let key = SecureAPIKeyStore.Key.gemini
    #expect(key.service == "app.wonderread.gemini-api-key")
    #expect(key.account == "gemini-api-key")
    #expect(key.displayName == "Gemini")
  }
}

struct SecureAPIKeyStoreErrorTests {
  @Test func suppliesRecoveryForKnownKeychainConditions() {
    let locked = error(status: errSecInteractionNotAllowed)
    let missingEntitlement = error(status: errSecMissingEntitlement)
    let unavailable = error(status: errSecNotAvailable)
    let unknown = error(status: errSecParam)
    #expect(locked.recoverySuggestion?.isEmpty == false)
    #expect(missingEntitlement.recoverySuggestion?.isEmpty == false)
    #expect(unavailable.recoverySuggestion?.isEmpty == false)
    #expect(unknown.recoverySuggestion?.isEmpty == false)
  }

  @Test func describesProviderAndOperation() {
    let error = SecureAPIKeyStoreError(provider: "Gemini", operation: .save, status: errSecParam)
    #expect(error.errorDescription?.contains("Gemini") == true)
    #expect(error.errorDescription?.isEmpty == false)
  }
}

private func error(status: OSStatus) -> SecureAPIKeyStoreError {
  SecureAPIKeyStoreError(provider: "Gemini", operation: .read, status: status)
}

struct StoryLocalAIStatusTests {
  @Test func onlyReadyStatusCanStartGeneration() {
    #expect(StoryLocalAIStatus.ready(languageName: "English").canAttemptGeneration)
    #expect(StoryLocalAIStatus.unsupportedOS.canAttemptGeneration == false)
    #expect(StoryLocalAIStatus.deviceNotEligible.canAttemptGeneration == false)
    #expect(StoryLocalAIStatus.appleIntelligenceNotEnabled.canAttemptGeneration == false)
    #expect(StoryLocalAIStatus.modelNotReady.canAttemptGeneration == false)
    #expect(StoryLocalAIStatus.unsupportedLanguage(languageName: "Indonesian").canAttemptGeneration == false)
    #expect(StoryLocalAIStatus.unavailable.canAttemptGeneration == false)
  }

  @Test func everyStatusProvidesUserFacingMessage() {
    let statuses: [StoryLocalAIStatus] = [
      .ready(languageName: "English"), .unsupportedOS, .deviceNotEligible,
      .appleIntelligenceNotEnabled, .modelNotReady, .unsupportedLanguage(languageName: "Indonesian"), .unavailable
    ]
    #expect(statuses.allSatisfy { !$0.message.isEmpty })
  }
}
