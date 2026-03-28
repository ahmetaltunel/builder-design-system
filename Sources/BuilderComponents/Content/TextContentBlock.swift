import SwiftUI
import BuilderFoundation

public struct TextContentBlock: View {
    public let environment: DesignSystemEnvironment
    public let title: String?
    public let bodyText: String

    public init(environment: DesignSystemEnvironment, title: String? = nil, bodyText: String) {
        self.environment = environment
        self.title = title
        self.bodyText = bodyText
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title {
                Text(title)
                    .font(environment.theme.typography(.sectionTitle).font)
                    .foregroundStyle(environment.theme.color(.textPrimary))
            }

            Text(bodyText)
                .font(environment.theme.typography(.body).font)
                .foregroundStyle(environment.theme.color(.textSecondary))
        }
    }
}
