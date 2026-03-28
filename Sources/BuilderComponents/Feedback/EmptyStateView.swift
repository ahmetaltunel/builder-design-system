import SwiftUI
import BuilderFoundation

public struct EmptyStateView: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let message: String
    public let symbol: String
    public let actionTitle: String?
    public let action: (() -> Void)?

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        message: String,
        symbol: String = "tray",
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.environment = environment
        self.title = title
        self.message = message
        self.symbol = symbol
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: symbol)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(environment.theme.color(.textMuted))

            Text(title)
                .font(environment.theme.typography(.sectionTitle).font)
                .foregroundStyle(environment.theme.color(.textPrimary))

            Text(message)
                .font(environment.theme.typography(.body).font)
                .foregroundStyle(environment.theme.color(.textSecondary))
                .fixedSize(horizontal: false, vertical: true)

            if let actionTitle, let action {
                SystemButton(environment: environment, title: actionTitle, tone: .secondary, action: action)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                .fill(environment.theme.color(.groupedSurface))
        )
        .overlay(
            RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityHint(message)
    }
}
