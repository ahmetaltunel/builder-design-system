import SwiftUI
import BuilderFoundation

public struct HeaderBlock<Trailing: View>: View {
    public let environment: DesignSystemEnvironment
    public let eyebrow: String?
    public let title: String
    public let subtitle: String?
    public let trailing: Trailing

    public init(
        environment: DesignSystemEnvironment,
        eyebrow: String? = nil,
        title: String,
        subtitle: String? = nil,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.environment = environment
        self.eyebrow = eyebrow
        self.title = title
        self.subtitle = subtitle
        self.trailing = trailing()
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                if let eyebrow {
                    Text(eyebrow)
                        .font(environment.theme.typography(.caption).font.weight(.semibold))
                        .foregroundStyle(environment.theme.color(.textMuted))
                }

                Text(title)
                    .font(environment.theme.typography(.pageTitle).font)
                    .foregroundStyle(environment.theme.color(.textPrimary))

                if let subtitle {
                    Text(subtitle)
                        .font(environment.theme.typography(.body).font)
                        .foregroundStyle(environment.theme.color(.textSecondary))
                }
            }

            Spacer(minLength: 16)
            trailing
        }
    }
}
