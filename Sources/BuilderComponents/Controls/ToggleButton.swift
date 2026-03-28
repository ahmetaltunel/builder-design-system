import SwiftUI
import BuilderFoundation

public struct ToggleButton: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    @Binding public var isOn: Bool

    public init(environment: DesignSystemEnvironment, title: String, isOn: Binding<Bool>) {
        self.environment = environment
        self.title = title
        self._isOn = isOn
    }

    public var body: some View {
        Button {
            isOn.toggle()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isOn ? environment.theme.color(.accentPrimary) : environment.theme.color(.textMuted))
                Text(title)
                    .font(environment.theme.typography(.body).font.weight(.medium))
                    .foregroundStyle(environment.theme.color(.textPrimary))
            }
            .padding(.horizontal, 14)
            .frame(height: 38)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                    .fill(isOn ? environment.theme.color(.selectedSurface) : environment.theme.color(.inputSurface))
            )
            .overlay(
                RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                    .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
            )
            .contentShape(RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
