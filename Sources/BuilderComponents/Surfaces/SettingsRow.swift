import SwiftUI
import BuilderFoundation

public struct SettingsRow<Control: View>: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let detail: String
    public let control: Control

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        detail: String,
        @ViewBuilder control: () -> Control
    ) {
        self.environment = environment
        self.title = title
        self.detail = detail
        self.control = control()
    }

    public var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .top, spacing: 20) {
                labelBlock
                    .frame(maxWidth: .infinity, alignment: .leading)

                control
            }

            VStack(alignment: .leading, spacing: 12) {
                labelBlock
                control
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private var labelBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(environment.theme.typography(.bodyStrong).font)
                .foregroundStyle(environment.theme.color(.textPrimary))

            Text(detail)
                .font(environment.theme.typography(.helper).font)
                .foregroundStyle(environment.theme.color(.textSecondary))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
