import SwiftUI
import BuilderFoundation

public struct PromptInput: View {
    public enum SubmitShortcutBehavior: Hashable, Sendable {
        case none
        case returnKey
        case commandReturn
    }

    public let environment: DesignSystemEnvironment
    public let prompt: Binding<String>
    public let placeholder: String
    public let actionTitle: String
    public let supportingText: String?
    public let isEnabled: Bool
    public let isSubmitting: Bool
    public let isMultiline: Bool
    public let minHeight: CGFloat
    public let submitShortcutBehavior: SubmitShortcutBehavior
    public let secondaryActionTitle: String?
    public let secondaryActionSymbol: String?
    public let onSecondaryAction: (() -> Void)?
    public let onSubmit: () -> Void

    public init(
        environment: DesignSystemEnvironment,
        prompt: Binding<String>,
        placeholder: String = "Prompt",
        actionTitle: String = "Run",
        isEnabled: Bool = true,
        onSubmit: @escaping () -> Void
    ) {
        self.environment = environment
        self.prompt = prompt
        self.placeholder = placeholder
        self.actionTitle = actionTitle
        self.supportingText = nil
        self.isEnabled = isEnabled
        self.isSubmitting = false
        self.isMultiline = false
        self.minHeight = 120
        self.submitShortcutBehavior = .returnKey
        self.secondaryActionTitle = nil
        self.secondaryActionSymbol = nil
        self.onSecondaryAction = nil
        self.onSubmit = onSubmit
    }

    public init(
        environment: DesignSystemEnvironment,
        prompt: Binding<String>,
        placeholder: String = "Prompt",
        actionTitle: String = "Run",
        supportingText: String? = nil,
        isEnabled: Bool = true,
        isSubmitting: Bool = false,
        isMultiline: Bool = false,
        minHeight: CGFloat = 120,
        submitShortcutBehavior: SubmitShortcutBehavior = .commandReturn,
        secondaryActionTitle: String? = nil,
        secondaryActionSymbol: String? = nil,
        onSecondaryAction: (() -> Void)? = nil,
        onSubmit: @escaping () -> Void
    ) {
        self.environment = environment
        self.prompt = prompt
        self.placeholder = placeholder
        self.actionTitle = actionTitle
        self.supportingText = supportingText
        self.isEnabled = isEnabled
        self.isSubmitting = isSubmitting
        self.isMultiline = isMultiline
        self.minHeight = minHeight
        self.submitShortcutBehavior = submitShortcutBehavior
        self.secondaryActionTitle = secondaryActionTitle
        self.secondaryActionSymbol = secondaryActionSymbol
        self.onSecondaryAction = onSecondaryAction
        self.onSubmit = onSubmit
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextAreaField(
                environment: environment,
                placeholder: placeholder,
                text: prompt,
                minHeight: isMultiline ? minHeight : 52,
                isEnabled: isEnabled
            )

            HStack(alignment: .center, spacing: 10) {
                if let supportingText {
                    Text(supportingText)
                        .font(environment.theme.typography(.caption).font)
                        .foregroundStyle(environment.theme.color(.textSecondary))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)

                if let secondaryActionTitle, let onSecondaryAction {
                    SystemButton(
                        environment: environment,
                        title: secondaryActionTitle,
                        tone: .secondary,
                        size: .small,
                        leadingSymbol: secondaryActionSymbol,
                        action: onSecondaryAction
                    )
                }

                submitButton
            }
        }
    }

    @ViewBuilder
    private var submitButton: some View {
        if submitShortcutBehavior == .commandReturn {
            SystemButton(
                environment: environment,
                title: actionTitle,
                tone: .primary,
                isEnabled: canSubmit,
                isLoading: isSubmitting,
                action: submitIfPossible
            )
            .keyboardShortcut(.return, modifiers: [.command])
        } else if submitShortcutBehavior == .returnKey && !isMultiline {
            SystemButton(
                environment: environment,
                title: actionTitle,
                tone: .primary,
                isEnabled: canSubmit,
                isLoading: isSubmitting,
                action: submitIfPossible
            )
            .keyboardShortcut(.return, modifiers: [])
        } else {
            SystemButton(
                environment: environment,
                title: actionTitle,
                tone: .primary,
                isEnabled: canSubmit,
                isLoading: isSubmitting,
                action: submitIfPossible
            )
        }
    }

    private var canSubmit: Bool {
        isEnabled && !isSubmitting && !trimmedPrompt.isEmpty
    }

    private var trimmedPrompt: String {
        prompt.wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func submitIfPossible() {
        guard canSubmit else { return }
        onSubmit()
    }
}
