import SwiftUI
import BuilderFoundation

public struct BreadcrumbGroup: View {
    public struct Item: Identifiable, Hashable {
        public let id: String
        public let title: String
        public let isCurrent: Bool
        public let action: (() -> Void)?

        public init(id: String? = nil, title: String, isCurrent: Bool = false, action: (() -> Void)? = nil) {
            self.id = id ?? title
            self.title = title
            self.isCurrent = isCurrent
            self.action = action
        }

        public static func == (lhs: Item, rhs: Item) -> Bool { lhs.id == rhs.id && lhs.title == rhs.title && lhs.isCurrent == rhs.isCurrent }
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(title)
            hasher.combine(isCurrent)
        }
    }

    public let environment: DesignSystemEnvironment
    public let items: [Item]

    public init(environment: DesignSystemEnvironment, items: [Item]) {
        self.environment = environment
        self.items = items
    }

    public var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                if let action = item.action, item.isCurrent == false {
                    Button(action: action) {
                        Text(item.title)
                            .foregroundStyle(environment.theme.color(.textSecondary))
                    }
                    .buttonStyle(.plain)
                } else {
                    Text(item.title)
                        .foregroundStyle(item.isCurrent ? environment.theme.color(.textPrimary) : environment.theme.color(.textSecondary))
                }

                if index < items.count - 1 {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(environment.theme.color(.textMuted))
                }
            }
        }
        .font(environment.theme.typography(.caption).font)
    }
}
