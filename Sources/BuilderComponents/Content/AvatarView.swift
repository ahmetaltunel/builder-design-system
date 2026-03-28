import SwiftUI
import BuilderFoundation

public struct AvatarView: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let symbol: String?
    public let tint: Color?
    public let size: CGFloat

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        symbol: String? = nil,
        tint: Color? = nil,
        size: CGFloat = 34
    ) {
        self.environment = environment
        self.title = title
        self.symbol = symbol
        self.tint = tint
        self.size = size
    }

    public var body: some View {
        ZStack {
            Circle()
                .fill((tint ?? environment.theme.color(.accentPrimary)).opacity(environment.mode == .dark ? 0.9 : 0.82))

            if let symbol {
                Image(systemName: symbol)
                    .font(.system(size: max(12, size * 0.34), weight: .semibold))
                    .foregroundStyle(environment.theme.color(.textOnAccent))
            } else {
                Text(initials)
                    .font(environment.theme.typography(.captionStrong).font)
                    .foregroundStyle(environment.theme.color(.textOnAccent))
            }
        }
        .frame(width: size, height: size)
        .accessibilityLabel(title)
    }

    private var initials: String {
        let parts = title
            .split(separator: " ")
            .prefix(2)
            .map { $0.prefix(1).uppercased() }

        return parts.joined()
    }
}
