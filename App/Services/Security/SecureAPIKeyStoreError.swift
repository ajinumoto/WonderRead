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
    case .read: String(localized: "read", comment: "Localized app copy.")
    case .save: String(localized: "save", comment: "Localized app copy.")
    case .delete: String(localized: "delete", comment: "Localized app copy.")
    }
    return String(localized: "Keychain couldn't \(action) the \(provider) API key (code \(status)). \(systemMessage)", comment: "Localized app copy.")
  }

  var recoverySuggestion: String? {
    if status == errSecInteractionNotAllowed {
      #if os(macOS)
      return String(localized: "Unlock your Mac, then try again.", comment: "Localized app copy.")
      #else
      return String(localized: "Unlock your device, then try again.", comment: "Localized app copy.")
      #endif
    }
    if status == errSecMissingEntitlement {
      return String(localized: "This app doesn't have Keychain access. Update or reinstall the app.", comment: "Localized app copy.")
    }
    if status == errSecNotAvailable {
      return String(localized: "Device security services aren't ready yet. Try again in a moment.", comment: "Localized app copy.")
    }
    return String(localized: "Try again, or restart the device.", comment: "Localized app copy.")
  }

  private var systemMessage: String {
    if let error = SecCopyErrorMessageString(status, nil) as String? {
      return error
    }
    return String(localized: "A system error occurred.", comment: "Localized app copy.")
  }
}
