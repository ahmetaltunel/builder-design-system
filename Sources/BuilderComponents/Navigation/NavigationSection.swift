import Foundation

public struct NavigationSection<ID: Hashable>: Identifiable, Hashable {
    public let id: String
    public let title: String?
    public let items: [NavigationItem<ID>]

    public init(id: String, title: String? = nil, items: [NavigationItem<ID>]) {
        self.id = id
        self.title = title
        self.items = items
    }
}
