import Foundation

enum RepoAlertMessageMapper {
  static func confirmSwitchTitle() -> String {
    String(
      localized: "Switch Story Repository?",
      comment: "Title for alert confirming story repository switch"
    )
  }

  static func confirmSwitchMessage(repoName: String) -> String {
    String(
      localized: "Do you want to switch to \"\(repoName)\"? This will clear your current offline story cache.",
      comment: "Explanation message for repository switch confirmation dialog"
    )
  }

  static func switchedSuccessTitle() -> String {
    String(
      localized: "Repository Connected",
      comment: "Title for alert confirming successful repository switch"
    )
  }

  static func switchedSuccessMessage(repoName: String) -> String {
    String(
      localized: "Successfully connected to repository: \(repoName)",
      comment: "Message confirming connection to an imported story repository"
    )
  }
}
