import SwiftUI
import BuilderFoundation
import BuilderBehaviors

public struct ChatBubble: View {
    public enum Role: Hashable, Sendable {
        case assistant
        case user
        case system
    }

    public enum MessageState: Hashable, Sendable {
        case streaming
        case complete
        case error
    }

    public struct FooterMetadata: Identifiable, Hashable, Sendable {
        public let id: String
        public let label: String
        public let value: String

        public init(id: String? = nil, label: String, value: String) {
            self.id = id ?? label
            self.label = label
            self.value = value
        }
    }

    public let environment: DesignSystemEnvironment
    public let role: Role
    public let author: String
    public let message: String
    public let detail: String?
    public let state: MessageState
    public let footerMetadata: [FooterMetadata]
    public let showsCopyAction: Bool
    public let copyActionTitle: String
    public let retryActionTitle: String
    public let onRetry: (() -> Void)?

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
        self.state = .complete
        self.footerMetadata = []
        self.showsCopyAction = false
        self.copyActionTitle = "Copy"
        self.retryActionTitle = "Retry"
        self.onRetry = nil
    }

    public init(
        environment: DesignSystemEnvironment,
        role: Role,
        author: String,
        message: String,
        detail: String? = nil,
        state: MessageState = .complete,
        footerMetadata: [FooterMetadata] = [],
        showsCopyAction: Bool = false,
        copyActionTitle: String = "Copy",
        retryActionTitle: String = "Retry",
        onRetry: (() -> Void)? = nil
    ) {
        self.environment = environment
        self.role = role
        self.author = author
        self.message = message
        self.detail = detail
        self.state = state
        self.footerMetadata = footerMetadata
        self.showsCopyAction = showsCopyAction
        self.copyActionTitle = copyActionTitle
        self.retryActionTitle = retryActionTitle
        self.onRetry = onRetry
    }

    public init(
        environment: DesignSystemEnvironment,
        message: ConversationMessage,
        showsCopyAction: Bool = false,
        copyActionTitle: String = "Copy",
        retryActionTitle: String = "Retry",
        onRetry: (() -> Void)? = nil
    ) {
        self.init(
            environment: environment,
            role: Self.role(for: message.role),
            author: message.author,
            message: message.message,
            detail: message.detail,
            state: Self.messageState(for: message.state),
            footerMetadata: message.footerMetadata.map {
                .init(id: $0.id, label: $0.label, value: $0.value)
            },
            showsCopyAction: showsCopyAction,
            copyActionTitle: copyActionTitle,
            retryActionTitle: retryActionTitle,
            onRetry: onRetry
        )
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if role != .user {
                AvatarView(environment: environment, title: author, symbol: avatarSymbol, tint: avatarTint, size: 30)
            } else {
                Spacer(minLength: 0)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center, spacing: 8) {
                    Text(author)
                        .font(environment.theme.typography(.captionStrong).font)
                        .foregroundStyle(environment.theme.color(.textSecondary))

                    if state != .complete {
                        StatusBadge(
                            environment: environment,
                            label: stateLabel,
                            color: stateColor
                        )
                    }
                }

                Text(message)
                    .font(environment.theme.typography(.body).font)
                    .foregroundStyle(messageColor)
                    .fixedSize(horizontal: false, vertical: true)

                if let detail {
                    detailView(detail)
                }

                if state == .streaming {
                    LoadingBar(
                        environment: environment,
                        label: "Streaming response",
                        detail: "Keep the conversation visible while content arrives.",
                        height: 6
                    )
                }

                if !footerMetadata.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(footerMetadata) { item in
                            Text("\(item.label): \(item.value)")
                                .font(environment.theme.typography(.caption).font)
                                .foregroundStyle(environment.theme.color(.textMuted))
                        }
                    }
                }

                if showsActions {
                    HStack(spacing: 8) {
                        if showsCopyAction {
                            CopyToClipboardButton(
                                environment: environment,
                                title: copyActionTitle,
                                value: message
                            )
                        }

                        if let onRetry {
                            SystemButton(
                                environment: environment,
                                title: retryActionTitle,
                                tone: .secondary,
                                size: .small,
                                leadingSymbol: "arrow.clockwise",
                                action: onRetry
                            )
                        }
                    }
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
            .frame(maxWidth: 460, alignment: .leading)
            .accessibilityElement(children: .contain)
            .accessibilityLabel(author)
            .accessibilityValue(message)
            .accessibilityHint(accessibilityHint)

            if role == .user {
                AvatarView(environment: environment, title: author, symbol: avatarSymbol, tint: avatarTint, size: 30)
            } else {
                Spacer(minLength: 0)
            }
        }
        .frame(maxWidth: .infinity, alignment: role == .user ? .trailing : .leading)
    }

    @ViewBuilder
    private func detailView(_ detail: String) -> some View {
        if state == .error {
            ValidationMessage(environment: environment, status: .error, message: detail)
        } else {
            Text(detail)
                .font(environment.theme.typography(.caption).font)
                .foregroundStyle(role == .user ? environment.theme.color(.textOnAccent).opacity(0.82) : environment.theme.color(.textMuted))
        }
    }

    private var showsActions: Bool {
        showsCopyAction || onRetry != nil
    }

    private var stateLabel: String {
        switch state {
        case .streaming:
            "Streaming"
        case .complete:
            "Ready"
        case .error:
            "Needs retry"
        }
    }

    private var stateColor: Color {
        switch state {
        case .streaming:
            environment.theme.color(.info)
        case .complete:
            environment.theme.color(.success)
        case .error:
            environment.theme.color(.danger)
        }
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
            state == .error ? environment.theme.color(.danger) : environment.theme.color(.subtleBorder)
        case .user:
            .clear
        case .system:
            environment.theme.color(.info)
        }
    }

    private var messageColor: Color {
        switch role {
        case .user:
            environment.theme.color(.textOnAccent)
        case .assistant, .system:
            state == .error ? environment.theme.color(.danger) : environment.theme.color(.textPrimary)
        }
    }

    private var avatarTint: Color {
        switch role {
        case .assistant:
            state == .error ? environment.theme.color(.danger) : environment.theme.color(.accentPrimary)
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

    private var accessibilityHint: String {
        switch state {
        case .streaming:
            "Response is still streaming"
        case .complete:
            "Conversation message"
        case .error:
            "Message needs retry"
        }
    }

    private static func role(for role: ConversationMessage.Role) -> Role {
        switch role {
        case .assistant:
            .assistant
        case .user:
            .user
        case .system:
            .system
        }
    }

    private static func messageState(for state: ConversationMessage.State) -> MessageState {
        switch state {
        case .streaming:
            .streaming
        case .complete:
            .complete
        case .error:
            .error
        }
    }
}
