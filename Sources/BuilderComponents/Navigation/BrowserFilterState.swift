import Foundation

@MainActor
public final class BrowserFilterState<Scope: Hashable>: ObservableObject {
    @Published public var query: String
    @Published public var selectedScope: Scope?

    public init(query: String = "", selectedScope: Scope? = nil) {
        self.query = query
        self.selectedScope = selectedScope
    }

    public var hasQuery: Bool {
        !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
