import SwiftUI
import BuilderFoundation

public struct TextInputField: View {
    public let environment: DesignSystemEnvironment
    public let placeholder: String
    @Binding public var text: String
    @Binding private var externalFocus: Bool
    public let leadingSymbol: String?
    public let width: CGFloat?
    public let height: CGFloat
    public let status: FieldStatus
    public let message: String?
    public let isReadOnly: Bool
    public let isEnabled: Bool
    public let onEscape: (() -> Void)?

    @FocusState private var isFocused: Bool

    public init(
        environment: DesignSystemEnvironment,
        placeholder: String,
        text: Binding<String>,
        isFocused: Binding<Bool>? = nil,
        leadingSymbol: String? = nil,
        width: CGFloat? = nil,
        height: CGFloat = 38,
        status: FieldStatus = .normal,
        message: String? = nil,
        isReadOnly: Bool = false,
        isEnabled: Bool = true,
        onEscape: (() -> Void)? = nil
    ) {
        self.environment = environment
        self.placeholder = placeholder
        self._text = text
        self._externalFocus = isFocused ?? .constant(false)
        self.leadingSymbol = leadingSymbol
        self.width = width
        self.height = height
        self.status = status
        self.message = message
        self.isReadOnly = isReadOnly
        self.isEnabled = isEnabled
        self.onEscape = onEscape
    }

    public var body: some View {
        let material = environment.theme.material(.input)
        let resolvedHeight = max(34, height + environment.density.controlHeightOffset)
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 10) {
                if let leadingSymbol {
                    Image(systemName: leadingSymbol)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(environment.theme.color(.textMuted))
                }

                TextField(
                    "",
                    text: $text,
                    prompt: Text(placeholder)
                        .foregroundStyle(environment.theme.color(.textMuted))
                )
                .textFieldStyle(.plain)
                .font(environment.theme.typography(.bodySmall).font)
                .foregroundStyle(isEnabled ? environment.theme.color(.textPrimary) : environment.theme.color(.textDisabled))
                .focused($isFocused)
                .disabled(isReadOnly || !isEnabled)
                .onChange(of: isFocused) { _, newValue in
                    externalFocus = newValue
                }
                .onChange(of: externalFocus) { _, newValue in
                    guard newValue != isFocused else { return }
                    isFocused = newValue
                }
                .onExitCommand {
                    guard isFocused else { return }
                    isFocused = false
                    externalFocus = false
                    onEscape?()
                }
                .accessibilityLabel(placeholder)
                .accessibilityValue(text.isEmpty ? "Empty" : text)
                .accessibilityHint(isReadOnly ? "Read-only text field" : "Editable text field")

                if isReadOnly {
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
            }
            .padding(.horizontal, 12)
            .frame(maxWidth: width == nil ? .infinity : nil, alignment: .leading)
            .frame(width: width)
            .frame(height: resolvedHeight)
            .background(
                RoundedRectangle(cornerRadius: environment.theme.radius(material.radius), style: .continuous)
                    .fill(fillColor.opacity(material.fillOpacity))
            )
            .overlay(
                RoundedRectangle(cornerRadius: environment.theme.radius(material.radius), style: .continuous)
                    .stroke(
                        isFocused ? environment.theme.color(.focusRing) : borderColor,
                        lineWidth: isFocused ? 1.5 : material.borderWidth
                    )
            )
            .contentShape(RoundedRectangle(cornerRadius: environment.theme.radius(material.radius), style: .continuous))
            .opacity(isEnabled ? 1 : 0.62)
            .onTapGesture {
                guard !isReadOnly, isEnabled else { return }
                isFocused = true
                externalFocus = true
            }

            if let message {
                ValidationMessage(environment: environment, status: status, message: message)
            }
        }
    }

    private var fillColor: Color {
        if isReadOnly {
            return environment.theme.color(.insetSurface)
        }
        return environment.theme.color(.inputSurface)
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
