import Combine
import Foundation

@MainActor
public final class CollectionController<Item: Identifiable & Hashable>: ObservableObject {
    public struct SortOption {
        public let id: String
        public let title: String
        fileprivate let comparator: (Item, Item) -> Bool

        public init(
            id: String,
            title: String,
            comparator: @escaping (Item, Item) -> Bool
        ) {
            self.id = id
            self.title = title
            self.comparator = comparator
        }
    }

    public struct ViewPreferences: Codable, Hashable, Sendable {
        public let denseMode: Bool
        public let showsMetadata: Bool

        public init(denseMode: Bool, showsMetadata: Bool) {
            self.denseMode = denseMode
            self.showsMetadata = showsMetadata
        }
    }

    @Published public var state: AsyncContentState
    @Published public private(set) var items: [Item]
    @Published public private(set) var query: String
    @Published public private(set) var activeFilterTokens: [String]
    @Published public private(set) var selectedSortID: String?
    @Published public private(set) var currentPage: Int
    @Published public private(set) var pageSize: Int
    @Published public private(set) var selectedItemID: String?
    @Published public private(set) var denseMode: Bool
    @Published public private(set) var showsMetadata: Bool

    public let sortOptions: [SortOption]
    public let emptyPresentation: AsyncContentState.EmptyPresentation
    public let announcementCenter: AnnouncementCenter?

    private let searchableText: (Item) -> String
    private let filterMatcher: (Item, [String]) -> Bool
    private let preferencesStore: UserDefaultsValueStore<ViewPreferences>?
    private var sortOptionsByID: [String: SortOption]

    public init(
        items: [Item],
        state: AsyncContentState = .ready,
        query: String = "",
        activeFilterTokens: [String] = [],
        selectedSortID: String? = nil,
        currentPage: Int = 1,
        pageSize: Int = 8,
        selectedItemID: String? = nil,
        denseMode: Bool = false,
        showsMetadata: Bool = true,
        emptyPresentation: AsyncContentState.EmptyPresentation = .init(
            title: "No items",
            message: "Adjust the current filters to restore results."
        ),
        sortOptions: [SortOption] = [],
        searchableText: @escaping (Item) -> String,
        filterMatcher: ((Item, [String]) -> Bool)? = nil,
        preferencesStore: UserDefaultsValueStore<ViewPreferences>? = nil,
        announcementCenter: AnnouncementCenter? = nil
    ) {
        let restoredPreferences = preferencesStore?.load()

        self.items = items
        self.state = state
        self.query = query
        self.activeFilterTokens = activeFilterTokens
        self.selectedSortID = selectedSortID ?? sortOptions.first?.id
        self.currentPage = max(currentPage, 1)
        self.pageSize = max(pageSize, 1)
        self.selectedItemID = selectedItemID
        self.denseMode = restoredPreferences?.denseMode ?? denseMode
        self.showsMetadata = restoredPreferences?.showsMetadata ?? showsMetadata
        self.emptyPresentation = emptyPresentation
        self.sortOptions = sortOptions
        self.searchableText = searchableText
        self.filterMatcher = filterMatcher ?? { _, tokens in tokens.isEmpty }
        self.preferencesStore = preferencesStore
        self.announcementCenter = announcementCenter
        self.sortOptionsByID = Dictionary(uniqueKeysWithValues: sortOptions.map { ($0.id, $0) })
        clampPage()
    }

    public var filteredItems: [Item] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        var resolved = items.filter { item in
            let matchesQuery = trimmedQuery.isEmpty
            || searchableText(item).localizedCaseInsensitiveContains(trimmedQuery)
            let matchesFilters = activeFilterTokens.isEmpty || filterMatcher(item, activeFilterTokens)
            return matchesQuery && matchesFilters
        }

        if let selectedSortID, let sortOption = sortOptionsByID[selectedSortID] {
            resolved.sort(by: sortOption.comparator)
        }

        return resolved
    }

    public var visibleItems: [Item] {
        let items = filteredItems
        guard !items.isEmpty else { return [] }

        let startIndex = min((currentPage - 1) * pageSize, max(items.count - 1, 0))
        let endIndex = min(startIndex + pageSize, items.count)
        return Array(items[startIndex..<endIndex])
    }

    public var pageCount: Int {
        max(Int(ceil(Double(filteredItems.count) / Double(pageSize))), 1)
    }

    public var presentationState: AsyncContentState {
        switch state {
        case .ready:
            return filteredItems.isEmpty ? .empty(emptyPresentation) : .ready
        case .loading, .empty, .error:
            return state
        }
    }

    public func replaceItems(_ items: [Item]) {
        self.items = items
        clampPage()
    }

    public func updateQuery(_ query: String) {
        self.query = query
        currentPage = 1
        if !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            announcementCenter?.announce("Filtered to \(filteredItems.count) results.")
        }
    }

    public func setFilterTokens(_ tokens: [String]) {
        activeFilterTokens = tokens
        currentPage = 1
        announcementCenter?.announce(tokens.isEmpty ? "Cleared filters." : "Updated filters.")
    }

    public func toggleFilterToken(_ token: String) {
        if activeFilterTokens.contains(token) {
            activeFilterTokens.removeAll { $0 == token }
        } else {
            activeFilterTokens.append(token)
        }
        currentPage = 1
        announcementCenter?.announce("Updated filters.")
    }

    public func setSort(id: String?) {
        selectedSortID = id
        currentPage = 1
        if let id, let option = sortOptionsByID[id] {
            announcementCenter?.announce("Sorted by \(option.title).")
        }
    }

    public func select(itemID: String?, announcement: String? = nil) {
        selectedItemID = itemID
        if let announcement {
            announcementCenter?.announce(announcement)
        }
    }

    public func setPage(_ page: Int) {
        currentPage = min(max(page, 1), pageCount)
        announcementCenter?.announce("Page \(currentPage) of \(pageCount).")
    }

    public func nextPage() {
        setPage(currentPage + 1)
    }

    public func previousPage() {
        setPage(currentPage - 1)
    }

    public func setDenseMode(_ value: Bool) {
        denseMode = value
        persistPreferences()
        announcementCenter?.announce(value ? "Dense mode enabled." : "Dense mode disabled.")
    }

    public func setShowsMetadata(_ value: Bool) {
        showsMetadata = value
        persistPreferences()
        announcementCenter?.announce(value ? "Metadata shown." : "Metadata hidden.")
    }

    private func persistPreferences() {
        preferencesStore?.save(
            .init(
                denseMode: denseMode,
                showsMetadata: showsMetadata
            )
        )
    }

    private func clampPage() {
        currentPage = min(max(currentPage, 1), pageCount)
    }
}

