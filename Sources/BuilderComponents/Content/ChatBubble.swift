import SwiftUI
import BuilderFoundation

public struct ChatBubble: View {
    public enum Role {
        case assistant
        case user
        case system
    }

    public let environment: DesignSystemEnvironment
    public let role: Role
    public let author: String
    public let message: String
    public let detail: String?

    public init(
        environment: DesignSystemEnvironment,
        role: Role,
        author: String,
        message: String,
        detail: String? = nil
    ) {
        self.environment = environment
        self.role = role
        self.author = author
        self.message = message
        self.detail = detail
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if role != .user {
                AvatarView(environment: environment, title: author, symbol: avatarSymbol, tint: avatarTint, size: 30)
            } else {
                Spacer(minLength: 0)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(author)
                    .font(environment.theme.typography(.captionStrong).font)
                    .foregroundStyle(environment.theme.color(.textSecondary))

                Text(message)
                    .font(environment.theme.typography(.body).font)
                    .foregroundStyle(foregroundColor)
                    .fixedSize(horizontal: false, vertical: true)

                if let detail {
                    Text(detail)
                        .font(environment.theme.typography(.caption).font)
                        .foregroundStyle(role == .user ? environment.theme.color(.textOnAccent).opacity(0.8) : environment.theme.color(.textMuted))
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                    .stroke(borderColor, lineWidth: role == .user ? 0 : 1)
            )
            .frame(maxWidth: 420, alignment: .leading)

            if role == .user {
                AvatarView(environment: environment, title: author, symbol: avatarSymbol, tint: avatarTint, size: 30)
            } else {
                Spacer(minLength: 0)
            }
        }
        .frame(maxWidth: .infinity, alignment: role == .user ? .trailing : .leading)
    }

    private var backgroundColor: Color {
        switch role {
        case .assistant:
            environment.theme.color(.groupedSurface)
        case .user:
            environment.theme.color(.accentPrimary)
        case .system:
            environment.theme.color(.infoSurface)
        }
    }

    private var borderColor: Color {
        switch role {
        case .assistant:
            environment.theme.color(.subtleBorder)
        case .user:
            .clear
        case .system:
            environment.theme.color(.info)
        }
    }

    private var foregroundColor: Color {
        switch role {
        case .user:
            environment.theme.color(.textOnAccent)
        default:
            environment.theme.color(.textPrimary)
        }
    }

    private var avatarTint: Color {
        switch role {
        case .assistant:
            environment.theme.color(.accentPrimary)
        case .user:
            environment.theme.color(.chartTeal)
        case .system:
            environment.theme.color(.info)
        }
    }

    private var avatarSymbol: String? {
        switch role {
        case .assistant:
            "sparkles"
        case .user:
            "person.fill"
        case .system:
            "info.circle.fill"
        }
    }
}
