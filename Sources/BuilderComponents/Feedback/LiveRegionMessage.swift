import SwiftUI
import BuilderFoundation

public struct LiveRegionMessage: View {
    public let environment: DesignSystemEnvironment
    public let message: String

    public init(environment: DesignSystemEnvironment, message: String) {
        self.environment = environment
        self.message = message
    }

    public var body: some View {
        Text(message)
            .font(environment.theme.typography(.body).font)
            .foregroundStyle(environment.theme.color(.textPrimary))
            .accessibilityLabel(message)
            .accessibilityHint("Status update")
    }
}
