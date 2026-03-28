import SwiftUI
import BuilderFoundation

public struct SidebarRow: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let symbol: String
    public let isSelected: Bool

    public init(environment: DesignSystemEnvironment, title: String, symbol: String, isSelected: Bool) {
        self.environment = environment
        self.title = title
        self.symbol = symbol
        self.isSelected = isSelected
    }

    public var body: some View {
        let verticalPadding = max(7, 9 + environment.density.controlHeightOffset / 2)

        HStack(spacing: 12) {
            Image(systemName: symbol)
                .font(.system(size: 14, weight: .medium))
                .frame(width: 16)

            Text(title)
                .font(environment.theme.typography(.bodySmallStrong).font)

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(isSelected ? environment.theme.color(.textPrimary) : environment.theme.color(.textSecondary))
        .padding(.horizontal, 12)
        .padding(.vertical, verticalPadding)
        .background(
            RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                .fill(isSelected ? environment.theme.color(.sidebarSelection).opacity(0.96) : .clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                .stroke(isSelected ? environment.theme.color(.strongBorder).opacity(environment.mode == .dark ? 0.5 : 0.75) : .clear, lineWidth: 1)
        )
        .contentShape(RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous))
    }
}
