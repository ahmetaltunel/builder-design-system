import SwiftUI
import BuilderFoundation

public struct AlertBanner: View {
    public enum Tone {
        case info
        case success
        case warning
        case danger
    }

    public let environment: DesignSystemEnvironment
    public let title: String
    public let message: String
    public let tone: Tone
    public let actionTitle: String?
    public let action: (() -> Void)?
    public let isDismissible: Bool
    public let onDismiss: (() -> Void)?

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        message: String,
        tone: Tone = .info,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil,
        isDismissible: Bool = false,
        onDismiss: (() -> Void)? = nil
    ) {
        self.environment = environment
        self.title = title
        self.message = message
        self.tone = tone
        self.actionTitle = actionTitle
        self.action = action
        self.isDismissible = isDismissible
        self.onDismiss = onDismiss
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: symbol)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(accentColor)
                .frame(width: 18)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(environment.theme.typography(.bodyStrong).font)
                    .foregroundStyle(environment.theme.color(.textPrimary))

                Text(message)
                    .font(environment.theme.typography(.body).font)
                    .foregroundStyle(environment.theme.color(.textSecondary))
                    .fixedSize(horizontal: false, vertical: true)

                if let actionTitle, let action {
                    SystemButton(environment: environment, title: actionTitle, tone: .secondary, action: action)
                        .padding(.top, 6)
                }
            }

            Spacer(minLength: 0)

            if isDismissible {
                Button {
                    onDismiss?()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(environment.theme.color(.textSecondary))
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                .fill(backgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel(title)
        .accessibilityHint(message)
    }

    private var accentColor: Color {
        switch tone {
        case .info:
            environment.theme.color(.info)
        case .success:
            environment.theme.color(.success)
        case .warning:
            environment.theme.color(.warning)
        case .danger:
            environment.theme.color(.danger)
        }
    }

    private var backgroundColor: Color {
        switch tone {
        case .info:
            environment.theme.color(.infoSurface)
        case .success:
            environment.theme.color(.successSurface)
        case .warning:
            environment.theme.color(.warningSurface)
        case .danger:
            environment.theme.color(.dangerSurface)
        }
    }

    private var symbol: String {
        switch tone {
        case .info:
            "info.circle"
        case .success:
            "checkmark.circle"
        case .warning:
            "exclamationmark.triangle"
        case .danger:
            "xmark.octagon"
        }
    }
}
