import SwiftUI
import BuilderFoundation
import BuilderBehaviors

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

    public init(
        environment: DesignSystemEnvironment,
        controller: PromptComposerController,
        placeholder: String = "Prompt",
        actionTitle: String = "Run",
        isMultiline: Bool = false,
        minHeight: CGFloat = 120,
        secondaryActionTitle: String? = nil,
        secondaryActionSymbol: String? = nil,
        onSecondaryAction: (() -> Void)? = nil,
        onSubmit: @escaping () -> Void
    ) {
        self.init(
            environment: environment,
            prompt: Binding(
                get: { controller.draft },
                set: { controller.updateDraft($0) }
            ),
            placeholder: placeholder,
            actionTitle: actionTitle,
            supportingText: controller.supportingText,
            isEnabled: controller.isEnabled,
            isSubmitting: controller.isSubmitting,
            isMultiline: isMultiline,
            minHeight: minHeight,
            submitShortcutBehavior: Self.submitShortcutBehavior(for: controller.submitShortcutBehavior),
            secondaryActionTitle: secondaryActionTitle,
            secondaryActionSymbol: secondaryActionSymbol,
            onSecondaryAction: onSecondaryAction,
            onSubmit: onSubmit
        )
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            composerField()

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
    private func composerField() -> some View {
        if isMultiline {
            TextAreaField(
                environment: environment,
                placeholder: placeholder,
                text: prompt,
                minHeight: minHeight,
                isEnabled: isEnabled
            )
        } else {
            TextInputField(
                environment: environment,
                placeholder: placeholder,
                text: prompt,
                leadingSymbol: "sparkles",
                height: 44,
                isEnabled: isEnabled,
                onSubmit: inlineSubmitAction
            )
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

    private var inlineSubmitAction: (() -> Void)? {
        guard submitShortcutBehavior == .returnKey else { return nil }
        return submitIfPossible
    }

    private func submitIfPossible() {
        guard canSubmit else { return }
        onSubmit()
    }

    private static func submitShortcutBehavior(
        for behavior: PromptSubmitShortcutBehavior
    ) -> SubmitShortcutBehavior {
        switch behavior {
        case .none:
            .none
        case .returnKey:
            .returnKey
        case .commandReturn:
            .commandReturn
        }
    }
}
