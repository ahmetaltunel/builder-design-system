import SwiftUI
import BuilderFoundation

public struct FormField<Control: View>: View {
    public let environment: DesignSystemEnvironment
    public let label: String
    public let description: String?
    public let hint: String?
    public let control: Control

    public init(
        environment: DesignSystemEnvironment,
        label: String,
        description: String? = nil,
        hint: String? = nil,
        @ViewBuilder control: () -> Control
    ) {
        self.environment = environment
        self.label = label
        self.description = description
        self.hint = hint
        self.control = control()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(environment.theme.typography(.label).font)
                .foregroundStyle(environment.theme.color(.textPrimary))

            if let description {
                Text(description)
                    .font(environment.theme.typography(.caption).font)
                    .foregroundStyle(environment.theme.color(.textSecondary))
            }

            control

            if let hint {
                Text(hint)
                    .font(environment.theme.typography(.helper).font)
                    .foregroundStyle(environment.theme.color(.textMuted))
            }
        }
    }
}
