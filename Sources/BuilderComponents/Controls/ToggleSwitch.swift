import SwiftUI
import BuilderFoundation

public struct ToggleSwitch: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let detail: String?
    @Binding public var isOn: Bool
    public let isEnabled: Bool
    public let isLoading: Bool

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        detail: String? = nil,
        isOn: Binding<Bool>,
        isEnabled: Bool = true,
        isLoading: Bool = false
    ) {
        self.environment = environment
        self.title = title
        self.detail = detail
        self._isOn = isOn
        self.isEnabled = isEnabled
        self.isLoading = isLoading
    }

    public var body: some View {
        Button {
            guard isEnabled, !isLoading else { return }
            isOn.toggle()
        } label: {
            HStack(spacing: 14) {
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

                HStack(spacing: 10) {
                    if isLoading {
                        ProgressView()
                            .controlSize(.small)
                    }

                    Capsule(style: .continuous)
                        .fill(isOn ? environment.theme.color(.accentPrimary) : environment.theme.color(.inputSurface))
                        .frame(width: 44, height: 28)
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(isOn ? environment.theme.color(.accentPrimary) : environment.theme.color(.subtleBorder), lineWidth: 1)
                        )
                        .overlay(alignment: isOn ? .trailing : .leading) {
                            Circle()
                                .fill(environment.mode == .dark ? Color.white.opacity(0.96) : Color.white)
                                .frame(width: 22, height: 22)
                                .padding(3)
                        }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .opacity((isEnabled && !isLoading) ? 1 : 0.55)
            .contentShape(RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityValue(isLoading ? "Loading" : (isOn ? "On" : "Off"))
        .accessibilityHint(detail ?? (isEnabled ? "Toggle switch" : "Disabled toggle switch"))
    }
}
