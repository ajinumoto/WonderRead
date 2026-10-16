import Foundation
import Security

struct SecureAPIKeyStoreError: LocalizedError, Sendable {
  enum Operation: Sendable {
    case read
    case save
    case delete
  }

  var provider: String
  var operation: Operation
  var status: OSStatus

  var errorDescription: String? {
    let action = switch operation {
    case .read: String(localized: "read")
    case .save: String(localized: "save")
    case .delete: String(localized: "delete")
    }
    return String(localized: "Keychain couldn't \(action) the \(provider) API key (code \(status)). \(systemMessage)")
  }

  var recoverySuggestion: String? {
    if status == errSecInteractionNotAllowed {
      #if os(macOS)
      return String(localized: "Unlock your Mac, then try again.")
      #else
      return String(localized: "Unlock your device, then try again.")
      #endif
    }
    if status == errSecMissingEntitlement {
      return String(localized: "This app doesn't have Keychain access. Update or reinstall the app.")
    }
    if status == errSecNotAvailable {
      return String(localized: "Device security services aren't ready yet. Try again in a moment.")
    }
    return String(localized: "Try again, or restart the device.")
  }

  private var systemMessage: String {
    if let error = SecCopyErrorMessageString(status, nil) as String? {
      return error
    }
    return String(localized: "A system error occurred.")
  }
}
