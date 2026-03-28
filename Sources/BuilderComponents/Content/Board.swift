import SwiftUI
import BuilderFoundation

public struct Board: View {
    public struct Item: Identifiable {
        public let id: String
        public let title: String
        public let detail: String?
        public let status: String?
        public let statusColor: Color?
        public let symbol: String

        public init(
            id: String? = nil,
            title: String,
            detail: String? = nil,
            status: String? = nil,
            statusColor: Color? = nil,
            symbol: String = "square.grid.2x2"
        ) {
            self.id = id ?? title
            self.title = title
            self.detail = detail
            self.status = status
            self.statusColor = statusColor
            self.symbol = symbol
        }
    }

    public struct Column: Identifiable {
        public let id: String
        public let title: String
        public let items: [Item]

        public init(id: String? = nil, title: String, items: [Item]) {
            self.id = id ?? title
            self.title = title
            self.items = items
        }

        public init(id: String? = nil, title: String, cards: [String]) {
            self.init(
                id: id,
                title: title,
                items: cards.map { Item(title: $0) }
            )
        }
    }

    public struct Destination: Identifiable {
        public let id: String
        public let title: String
        public let columnID: String
        public let columnTitle: String
        public let index: Int

        public init(
            id: String? = nil,
            title: String,
            columnID: String,
            columnTitle: String,
            index: Int
        ) {
            self.id = id ?? "\(columnID)::\(index)::\(title)"
            self.title = title
            self.columnID = columnID
            self.columnTitle = columnTitle
            self.index = index
        }
    }

    public let environment: DesignSystemEnvironment
    public let columns: [Column]
    public let selectedItemID: Binding<String?>?
    public let onActivateItem: ((Item) -> Void)?
    public let onMoveItem: ((String, String, Int) -> Void)?

    @State private var localSelectedItemID: String?
    @State private var liveAnnouncement: String?

    public init(
        environment: DesignSystemEnvironment,
        columns: [Column],
        selectedItemID: Binding<String?>? = nil,
        onActivateItem: ((Item) -> Void)? = nil,
        onMoveItem: ((String, String, Int) -> Void)? = nil
    ) {
        self.environment = environment
        self.columns = columns
        self.selectedItemID = selectedItemID
        self.onActivateItem = onActivateItem
        self.onMoveItem = onMoveItem
    }

    public init(environment: DesignSystemEnvironment, columns: [Column]) {
        self.init(
            environment: environment,
            columns: columns,
            selectedItemID: nil,
            onActivateItem: nil,
            onMoveItem: nil
        )
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 16) {
                ForEach(Array(columns.enumerated()), id: \.element.id) { columnIndex, column in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(column.title)
                            .font(environment.theme.typography(.bodyStrong).font)
                            .foregroundStyle(environment.theme.color(.textPrimary))

                        ForEach(Array(column.items.enumerated()), id: \.element.id) { itemIndex, item in
                            BoardItemView(
                                environment: environment,
                                item: item,
                                isSelected: resolvedSelectedItemID == item.id,
                                onActivate: activationHandler(for: item),
                                moveDestinations: moveDestinations(for: itemIndex, in: column, columnIndex: columnIndex),
                                onMove: onMoveItem == nil ? nil : { destination in
                                    updateSelectedItemID(item.id)
                                    onMoveItem?(item.id, destination.columnID, destination.index)
                                    announce("\(item.title) moved to \(destination.columnTitle).")
                                }
                            )
                        }
                    }
                    .padding(14)
                    .frame(width: 260, alignment: .topLeading)
                    .background(
                        RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                            .fill(environment.theme.color(.groupedSurface))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                            .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
                    )
                }
            }
            .overlay(alignment: .bottomLeading) {
                if let liveAnnouncement, !liveAnnouncement.isEmpty {
                    AccessibilityAnnouncementRegion(message: liveAnnouncement)
                }
            }
        }
    }

    private var resolvedSelectedItemID: String? {
        selectedItemID?.wrappedValue ?? localSelectedItemID
    }

    private func activationHandler(for item: Item) -> (() -> Void)? {
        guard selectedItemID != nil || onActivateItem != nil else { return nil }

        return {
            updateSelectedItemID(item.id)
            onActivateItem?(item)
        }
    }

    private func updateSelectedItemID(_ itemID: String?) {
        if let selectedItemID {
            selectedItemID.wrappedValue = itemID
        } else {
            localSelectedItemID = itemID
        }
    }

    private func moveDestinations(
        for itemIndex: Int,
        in column: Column,
        columnIndex: Int
    ) -> [Destination] {
        guard onMoveItem != nil else { return [] }

        var destinations: [Destination] = []

        if itemIndex > 0 {
            destinations.append(
                Destination(
                    title: "Move up",
                    columnID: column.id,
                    columnTitle: column.title,
                    index: itemIndex - 1
                )
            )
        }

        if itemIndex < column.items.count - 1 {
            destinations.append(
                Destination(
                    title: "Move down",
                    columnID: column.id,
                    columnTitle: column.title,
                    index: itemIndex + 1
                )
            )
        }

        for destinationColumn in columns where destinationColumn.id != column.id {
            destinations.append(
                Destination(
                    title: "Move to \(destinationColumn.title)",
                    columnID: destinationColumn.id,
                    columnTitle: destinationColumn.title,
                    index: destinationColumn.items.count
                )
            )
        }

        if destinations.isEmpty {
            if columnIndex > 0 {
                let previousColumn = columns[columnIndex - 1]
                destinations.append(
                    Destination(
                        title: "Move to \(previousColumn.title)",
                        columnID: previousColumn.id,
                        columnTitle: previousColumn.title,
                        index: previousColumn.items.count
                    )
                )
            }

            if columnIndex < columns.count - 1 {
                let nextColumn = columns[columnIndex + 1]
                destinations.append(
                    Destination(
                        title: "Move to \(nextColumn.title)",
                        columnID: nextColumn.id,
                        columnTitle: nextColumn.title,
                        index: nextColumn.items.count
                    )
                )
            }
        }

        return destinations
    }

    private func announce(_ message: String) {
        liveAnnouncement = message
        postAccessibilityAnnouncement(message)
    }
}
