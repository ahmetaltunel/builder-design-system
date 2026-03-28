import SwiftUI
import BuilderFoundation

public struct Checkbox: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let detail: String?
    @Binding public var isOn: Bool
    public let isMixed: Bool
    public let isEnabled: Bool

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        detail: String? = nil,
        isOn: Binding<Bool>,
        isMixed: Bool = false,
        isEnabled: Bool = true
    ) {
        self.environment = environment
        self.title = title
        self.detail = detail
        self._isOn = isOn
        self.isMixed = isMixed
        self.isEnabled = isEnabled
    }

    public var body: some View {
        Button {
            guard isEnabled else { return }
            isOn.toggle()
        } label: {
            HStack(alignment: .top, spacing: 12) {
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .fill((isOn || isMixed) ? environment.theme.color(.accentPrimary) : environment.theme.color(.inputSurface))
                    .frame(width: 20, height: 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .stroke((isOn || isMixed) ? environment.theme.color(.accentPrimary) : environment.theme.color(.subtleBorder), lineWidth: 1)
                    )
                    .overlay {
                        if isOn || isMixed {
                            Image(systemName: isMixed ? "minus" : "checkmark")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(environment.theme.color(.textOnAccent))
                        }
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(environment.theme.typography(.bodyStrong).font)
                        .foregroundStyle(environment.theme.color(.textPrimary))

                    if let detail {
                        Text(detail)
                            .font(environment.theme.typography(.helper).font)
                            .foregroundStyle(environment.theme.color(.textSecondary))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                    .fill((isOn || isMixed) ? environment.theme.color(.selectedSurface) : .clear)
            )
            .opacity(isEnabled ? 1 : 0.55)
            .contentShape(RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityValue(accessibilityValue)
        .accessibilityHint(detail ?? (isEnabled ? "Checkbox" : "Disabled checkbox"))
    }

    private var accessibilityValue: String {
        if isMixed {
            return "Mixed"
        }
        return isOn ? "On" : "Off"
    }
}
