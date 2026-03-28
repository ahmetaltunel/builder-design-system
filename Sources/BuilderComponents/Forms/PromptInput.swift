import SwiftUI
import BuilderFoundation

public struct PromptInput: View {
    public let environment: DesignSystemEnvironment
    @Binding public var prompt: String
    public let placeholder: String
    public let actionTitle: String
    public let isEnabled: Bool
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
        self._prompt = prompt
        self.placeholder = placeholder
        self.actionTitle = actionTitle
        self.isEnabled = isEnabled
        self.onSubmit = onSubmit
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 10) {
            TextInputField(
                environment: environment,
                placeholder: placeholder,
                text: $prompt,
                leadingSymbol: "sparkles",
                isEnabled: isEnabled
            )

            SystemButton(
                environment: environment,
                title: actionTitle,
                tone: .primary,
                isEnabled: isEnabled && !prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                action: onSubmit
            )
        }
    }
}
