import SwiftUI
import BuilderFoundation

public struct ErrorStateView: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let message: String
    public let actionTitle: String?
    public let action: (() -> Void)?

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.environment = environment
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        PanelSurface(environment: environment, title: title, subtitle: message) {
            HStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(environment.theme.color(.danger))

                if let actionTitle, let action {
                    SystemButton(environment: environment, title: actionTitle, tone: .secondary, action: action)
                }
            }
        }
    }
}
