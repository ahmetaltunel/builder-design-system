import Foundation

public struct NavigationItem<ID: Hashable>: Identifiable, Hashable {
    public let id: ID
    public let title: String
    public let subtitle: String?
    public let symbol: String?
    public let isEnabled: Bool

    public init(
        id: ID,
        title: String,
        subtitle: String? = nil,
        symbol: String? = nil,
        isEnabled: Bool = true
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.symbol = symbol
        self.isEnabled = isEnabled
    }
}
