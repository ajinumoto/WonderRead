import SwiftUI

struct ParentalGateChallenge: Sendable, Equatable {
  let factorA: Int
  let factorB: Int

  var answer: Int { factorA * factorB }
  var questionText: String { "\(factorA) × \(factorB)" }

  static func generate() -> ParentalGateChallenge {
    ParentalGateChallenge(factorA: Int.random(in: 4...9), factorB: Int.random(in: 4...9))
  }
}

struct ParentalGateView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.colorScheme) private var colorScheme
  @State private var challenge = ParentalGateChallenge.generate()
  @State private var inputAnswer = ""
  @State private var showError = false

  var onSuccess: () -> Void

  var body: some View {
    NavigationStack {
      challengeContent
        .navigationTitle(String(localized: "Grown-Ups Only", comment: "Parental gate navigation title"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar { cancelToolbarItem }
    }
    .presentationBackground(StoryPalette.page(for: colorScheme))
    #if os(iOS)
    .presentationDetents([.medium])
    .presentationDragIndicator(.visible)
    #endif
  }

  private var challengeContent: some View {
    VStack(spacing: 20) {
      gateIcon
      gatePrompt
      challengeField
      unlockButton
      Spacer()
    }
    .padding(24)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(StoryPalette.page(for: colorScheme).ignoresSafeArea())
  }

  @ToolbarContentBuilder
  private var cancelToolbarItem: some ToolbarContent {
    ToolbarItem(placement: .cancellationAction) {
      Button(String(localized: "Cancel", comment: "Dismiss button")) { dismiss() }
    }
  }

  private var gateIcon: some View {
    Image(systemName: "lock.shield.fill")
      .font(.system(size: 48))
      .foregroundStyle(StoryPalette.accent)
      .padding(.top, 12)
  }

  private var gatePrompt: some View {
    VStack(spacing: 6) {
      Text(String(localized: "Parent Verification", comment: "Parental gate header"))
        .font(.headline)
      Text(String(localized: "Please ask a grown-up to solve this puzzle to proceed:", comment: "Parental gate explanation"))
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
    }
  }

  private var challengeField: some View {
    VStack(spacing: 8) {
      Text("\(challenge.questionText) = ?")
        .font(.title2.weight(.bold))
        .fontDesign(.rounded)

      TextField(String(localized: "Answer", comment: "Challenge answer field"), text: $inputAnswer)
        .textFieldStyle(.roundedBorder)
        .frame(maxWidth: 160)
        .multilineTextAlignment(.center)
        #if os(iOS)
        .keyboardType(.numberPad)
        #endif

      if showError {
        Text(String(localized: "Incorrect. Please try again.", comment: "Parental gate error"))
          .font(.caption)
          .foregroundStyle(.red)
      }
    }
  }

  private var unlockButton: some View {
    Button(String(localized: "Continue", comment: "Parental gate proceed button")) {
      verifyAnswer()
    }
    .buttonStyle(.borderedProminent)
    .tint(StoryPalette.accent)
    .disabled(inputAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
  }

  private func verifyAnswer() {
    guard let value = Int(inputAnswer.trimmingCharacters(in: .whitespacesAndNewlines)),
          value == challenge.answer else {
      showError = true
      challenge = ParentalGateChallenge.generate()
      inputAnswer = ""
      return
    }
    dismiss()
    onSuccess()
  }
}
