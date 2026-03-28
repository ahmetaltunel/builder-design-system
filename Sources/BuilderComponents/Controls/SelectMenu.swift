import SwiftUI
import BuilderFoundation

public struct SelectMenu<Selection: Hashable>: View {
    public struct Option {
        public let label: String
        public let value: Selection

        public init(label: String, value: Selection) {
            self.label = label
            self.value = value
        }
    }

    public let environment: DesignSystemEnvironment
    public let options: [Option]
    @Binding public var selection: Selection
    public let leadingSymbol: String?
    public let width: CGFloat?
    public let placeholder: String
    public let isEnabled: Bool

    public init(
        environment: DesignSystemEnvironment,
        options: [Option],
        selection: Binding<Selection>,
        leadingSymbol: String? = nil,
        width: CGFloat? = nil,
        placeholder: String = "Select",
        isEnabled: Bool = true
    ) {
        self.environment = environment
        self.options = options
        self._selection = selection
        self.leadingSymbol = leadingSymbol
        self.width = width
        self.placeholder = placeholder
        self.isEnabled = isEnabled
    }

    public var body: some View {
        let controlHeight = max(32, 36 + environment.density.controlHeightOffset)

        Menu {
            ForEach(Array(options.enumerated()), id: \.offset) { _, option in
                Button {
                    selection = option.value
                } label: {
                    if option.value == selection {
                        Label(option.label, systemImage: "checkmark")
                    } else {
                        Text(option.label)
                    }
                }
            }
        } label: {
            HStack(spacing: 10) {
                if let leadingSymbol {
                    Image(systemName: leadingSymbol)
                        .foregroundStyle(environment.theme.color(.textMuted))
                }

                Text(currentLabel)
                    .font(environment.theme.typography(.bodySmall).font)
                    .foregroundStyle(hasSelection ? environment.theme.color(.textPrimary) : environment.theme.color(.textMuted))

                Spacer(minLength: 6)

                Image(systemName: "chevron.down")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(environment.theme.color(.textSecondary))
            }
            .padding(.horizontal, 12)
            .frame(width: width, height: controlHeight)
            .frame(maxWidth: width == nil ? .infinity : nil, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                    .fill(environment.theme.color(.inputSurface))
            )
            .overlay(
                RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                    .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
            )
            .contentShape(RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous))
            .opacity(isEnabled ? 1 : 0.55)
        }
        .menuStyle(.borderlessButton)
        .disabled(!isEnabled)
        .accessibilityLabel(placeholder)
        .accessibilityValue(currentLabel)
        .accessibilityHint(isEnabled ? "Opens a selection menu" : "Disabled selection menu")
    }

    private var currentLabel: String {
        options.first(where: { $0.value == selection })?.label ?? placeholder
    }

    private var hasSelection: Bool {
        options.contains(where: { $0.value == selection })
    }
}
