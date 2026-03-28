import SwiftUI
import BuilderFoundation

public struct ToolbarButton: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let symbol: String?
    public let emphasized: Bool
    public let action: () -> Void

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        symbol: String? = nil,
        emphasized: Bool = false,
        action: @escaping () -> Void
    ) {
        self.environment = environment
        self.title = title
        self.symbol = symbol
        self.emphasized = emphasized
        self.action = action
    }

    public var body: some View {
        let resolvedHeight = max(28, 32 + environment.density.controlHeightOffset)
        let cornerRadius = environment.theme.radius(.medium)

        Button(action: action) {
            HStack(spacing: 8) {
                if let symbol {
                    Image(systemName: symbol)
                        .font(.system(size: 12, weight: .medium))
                }

                Text(title)
                    .font(environment.theme.typography(.label).font)
            }
            .foregroundStyle(emphasized ? environment.theme.color(.textOnAccent) : environment.theme.color(.textPrimary))
            .padding(.horizontal, 12)
            .frame(height: resolvedHeight)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(emphasized ? environment.theme.color(.accentPrimary) : environment.theme.color(.inputSurface))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(emphasized ? .clear : environment.theme.color(.subtleBorder), lineWidth: 1)
            )
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityHint(emphasized ? "Primary toolbar action" : "Toolbar action")
    }
}
