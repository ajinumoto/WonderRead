import SwiftUI

struct RepoConfirmationAlertModifier: ViewModifier {
  @Binding var isPresented: Bool
  let payload: SupabaseRepoPayload?
  let onConfirm: (SupabaseRepoPayload) -> Void
  let onCancel: () -> Void

  func body(content: Content) -> some View {
    content.alert(
      RepoAlertMessageMapper.confirmSwitchTitle(),
      isPresented: $isPresented,
      presenting: payload
    ) { pending in
      Button(String(localized: "Switch Repository", comment: "Confirm switch action")) {
        onConfirm(pending)
      }
      Button(String(localized: "Cancel", comment: "Cancel switch action"), role: .cancel) {
        onCancel()
      }
    } message: { pending in
      Text(RepoAlertMessageMapper.confirmSwitchMessage(repoName: pending.repoName))
    }
  }
}

struct RepoSwitchedAlertModifier: ViewModifier {
  @Binding var isPresented: Bool
  let repoName: String

  func body(content: Content) -> some View {
    content.alert(
      RepoAlertMessageMapper.switchedSuccessTitle(),
      isPresented: $isPresented
    ) {
      Button(String(localized: "OK", comment: "Dismiss alert action"), role: .cancel) {}
    } message: {
      Text(RepoAlertMessageMapper.switchedSuccessMessage(repoName: repoName))
    }
  }
}

extension View {
  func confirmRepoSwitchAlert(
    isPresented: Binding<Bool>,
    payload: SupabaseRepoPayload?,
    onConfirm: @escaping (SupabaseRepoPayload) -> Void,
    onCancel: @escaping () -> Void
  ) -> some View {
    modifier(RepoConfirmationAlertModifier(
      isPresented: isPresented,
      payload: payload,
      onConfirm: onConfirm,
      onCancel: onCancel
    ))
  }

  func repoSwitchedAlert(
    isPresented: Binding<Bool>,
    repoName: String
  ) -> some View {
    modifier(RepoSwitchedAlertModifier(
      isPresented: isPresented,
      repoName: repoName
    ))
  }
}
