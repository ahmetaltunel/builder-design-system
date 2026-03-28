import Foundation

public struct HelpTopic: Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let detail: String?
    public let symbol: String?

    public init(
        id: String? = nil,
        title: String,
        detail: String? = nil,
        symbol: String? = nil
    ) {
        self.id = id ?? title
        self.title = title
        self.detail = detail
        self.symbol = symbol
    }
}

