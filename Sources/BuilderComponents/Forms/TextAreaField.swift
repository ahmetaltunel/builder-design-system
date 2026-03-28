import SwiftUI
import BuilderFoundation

public struct TextAreaField: View {
    public let environment: DesignSystemEnvironment
    public let placeholder: String
    @Binding public var text: String
    public let minHeight: CGFloat
    public let status: FieldStatus
    public let message: String?
    public let isReadOnly: Bool
    public let isEnabled: Bool

    public init(
        environment: DesignSystemEnvironment,
        placeholder: String = "",
        text: Binding<String>,
        minHeight: CGFloat = 120,
        status: FieldStatus = .normal,
        message: String? = nil,
        isReadOnly: Bool = false,
        isEnabled: Bool = true
    ) {
        self.environment = environment
        self.placeholder = placeholder
        self._text = text
        self.minHeight = minHeight
        self.status = status
        self.message = message
        self.isReadOnly = isReadOnly
        self.isEnabled = isEnabled
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack(alignment: .topLeading) {
                if text.isEmpty && placeholder.isEmpty == false {
                    Text(placeholder)
                        .font(environment.theme.typography(.bodySmall).font)
                        .foregroundStyle(environment.theme.color(.textMuted))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                }

                TextEditor(text: $text)
                    .font(environment.theme.typography(.bodySmall).font)
                    .foregroundStyle(isEnabled ? environment.theme.color(.textPrimary) : environment.theme.color(.textDisabled))
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .frame(minHeight: minHeight)
                    .disabled(isReadOnly || !isEnabled)
                    .accessibilityLabel(placeholder.isEmpty ? "Text area" : placeholder)
                    .accessibilityValue(text.isEmpty ? "Empty" : text)
                    .accessibilityHint(isReadOnly ? "Read-only text area" : "Editable text area")

                if isReadOnly {
                    HStack {
                        Spacer()
                        Text("Read-only")
                            .font(environment.theme.typography(.captionStrong).font)
                            .foregroundStyle(environment.theme.color(.textMuted))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(environment.theme.color(.groupedSurface))
                            )
                    }
                    .padding(10)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                    .fill((isReadOnly ? environment.theme.color(.insetSurface) : environment.theme.color(.inputSurface)))
            )
            .overlay(
                RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                    .stroke(borderColor, lineWidth: 1)
            )
            .opacity(isEnabled ? 1 : 0.62)

            if let message {
                ValidationMessage(environment: environment, status: status, message: message)
            }
        }
    }

    private var borderColor: Color {
        guard isEnabled else { return environment.theme.color(.subtleBorder) }
        switch status {
        case .normal:
            return environment.theme.color(.subtleBorder)
        case .success:
            return environment.theme.color(.success)
        case .warning:
            return environment.theme.color(.warning)
        case .error:
            return environment.theme.color(.danger)
        }
    }
}
