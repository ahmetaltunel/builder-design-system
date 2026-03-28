import SwiftUI
import BuilderFoundation

public struct BoardItemView: View {
    public let environment: DesignSystemEnvironment
    public let item: Board.Item

    public init(environment: DesignSystemEnvironment, item: Board.Item) {
        self.environment = environment
        self.item = item
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 8) {
                Image(systemName: item.symbol)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(environment.theme.color(.accentPrimary))

                Text(item.title)
                    .font(environment.theme.typography(.bodyStrong).font)
                    .foregroundStyle(environment.theme.color(.textPrimary))

                Spacer(minLength: 0)

                if let status = item.status {
                    StatusBadge(environment: environment, label: status, color: item.statusColor ?? environment.theme.color(.textSecondary))
                }
            }

            if let detail = item.detail {
                Text(detail)
                    .font(environment.theme.typography(.caption).font)
                    .foregroundStyle(environment.theme.color(.textSecondary))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                .fill(environment.theme.color(.raisedSurface))
        )
        .overlay(
            RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
        )
    }
}
