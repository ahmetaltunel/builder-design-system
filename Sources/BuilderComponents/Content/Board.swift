import SwiftUI
import BuilderFoundation
import BuilderBehaviors
import UniformTypeIdentifiers

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

    public struct Destination: Identifiable, Sendable {
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
    public let columnsBinding: Binding<[Column]>?
    public let selectedItemID: Binding<String?>?
    public let onActivateItem: ((Item) -> Void)?
    public let onMoveItem: ((String, String, Int) -> Void)?
    public let paletteItemResolver: ((String) -> Item?)?
    public let boardController: BoardController?

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
        self.columnsBinding = nil
        self.selectedItemID = selectedItemID
        self.onActivateItem = onActivateItem
        self.onMoveItem = onMoveItem
        self.paletteItemResolver = nil
        self.boardController = nil
    }

    public init(
        environment: DesignSystemEnvironment,
        columns: Binding<[Column]>,
        controller: BoardController,
        onActivateItem: ((Item) -> Void)? = nil,
        paletteItemResolver: ((String) -> Item?)? = nil
    ) {
        self.environment = environment
        self.columns = columns.wrappedValue
        self.columnsBinding = columns
        self.selectedItemID = Binding(
            get: { controller.selectedItemID },
            set: { controller.select(itemID: $0) }
        )
        self.onActivateItem = onActivateItem
        self.onMoveItem = nil
        self.paletteItemResolver = paletteItemResolver
        self.boardController = controller
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
                ForEach(Array(resolvedColumns.enumerated()), id: \.element.id) { columnIndex, column in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(column.title)
                            .font(environment.theme.typography(.bodyStrong).font)
                            .foregroundStyle(environment.theme.color(.textPrimary))

                        ForEach(Array(column.items.enumerated()), id: \.element.id) { itemIndex, item in
                            BoardItemView(
                                environment: environment,
                                item: item,
                                isSelected: resolvedSelectedItemID == item.id,
                                isFocused: boardController?.focusedItemID == item.id,
                                onActivate: activationHandler(for: item),
                                moveDestinations: moveDestinations(for: itemIndex, in: column, columnIndex: columnIndex),
                                onMove: supportsRuntimeMoves ? { destination in
                                    performRuntimeMove(
                                        itemID: item.id,
                                        itemTitle: item.title,
                                        destination: destination
                                    )
                                } : (onMoveItem == nil ? nil : { destination in
                                    updateSelectedItemID(item.id)
                                    onMoveItem?(item.id, destination.columnID, destination.index)
                                    announce("\(item.title) moved to \(destination.columnTitle).")
                                }),
                                dragPayload: dragPayload(for: item, sourceColumnID: column.id)
                            )
                            .onDrop(of: [.plainText], isTargeted: nil) { providers in
                                handleDrop(
                                    providers: providers,
                                    destination: Destination(
                                        title: "Move to \(column.title)",
                                        columnID: column.id,
                                        columnTitle: column.title,
                                        index: itemIndex
                                    )
                                )
                            }
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
                    .onDrop(of: [.plainText], isTargeted: nil) { providers in
                        handleDrop(
                            providers: providers,
                            destination: Destination(
                                title: "Move to \(column.title)",
                                columnID: column.id,
                                columnTitle: column.title,
                                index: column.items.count
                            )
                        )
                    }
                }
            }
            .overlay(alignment: .bottomLeading) {
                if let liveAnnouncement, !liveAnnouncement.isEmpty {
                    AccessibilityAnnouncementRegion(message: liveAnnouncement)
                }
            }
        }
    }

    private var resolvedColumns: [Column] {
        columnsBinding?.wrappedValue ?? columns
    }

    private var supportsRuntimeMoves: Bool {
        boardController != nil && columnsBinding != nil
    }

    private func dragPayload(for item: Item, sourceColumnID: String?) -> String? {
        guard boardController != nil else { return nil }
        let payload = BoardDragPayload(
            itemID: item.id,
            itemTitle: item.title,
            sourceColumnID: sourceColumnID,
            sourceKind: .board
        )
        return encodedPayload(payload)
    }

    private func performRuntimeMove(
        itemID: String,
        itemTitle: String,
        destination: Destination
    ) {
        guard let columnsBinding, let boardController else { return }
        let oldColumns = columnsBinding.wrappedValue
        let newColumns = movedColumns(
            itemID: itemID,
            in: oldColumns,
            destinationColumnID: destination.columnID,
            destinationIndex: destination.index
        )

        boardController.move(
            itemID: itemID,
            itemTitle: itemTitle,
            destinationColumnTitle: destination.columnTitle
        ) {
            columnsBinding.wrappedValue = newColumns
        } undo: {
            columnsBinding.wrappedValue = oldColumns
        }
    }

    private func performRuntimeInsert(
        item: Item,
        destination: Destination
    ) {
        guard let columnsBinding, let boardController else { return }
        let oldColumns = columnsBinding.wrappedValue
        let newColumns = insertedColumns(
            item: item,
            into: oldColumns,
            destinationColumnID: destination.columnID,
            destinationIndex: destination.index
        )

        boardController.insert(
            itemID: item.id,
            itemTitle: item.title,
            destinationColumnTitle: destination.columnTitle
        ) {
            columnsBinding.wrappedValue = newColumns
        } undo: {
            columnsBinding.wrappedValue = oldColumns
        }
    }

    private func handleDrop(
        providers: [NSItemProvider],
        destination: Destination
    ) -> Bool {
        guard supportsRuntimeMoves else { return false }

        let provider = providers.first {
            $0.hasItemConformingToTypeIdentifier(UTType.plainText.identifier)
        }
        guard let provider else { return false }

        provider.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { item, _ in
            guard
                let payloadString = boardPayloadString(from: item),
                let payload = decodedPayload(payloadString)
            else { return }

            DispatchQueue.main.async {
                self.boardController?.beginDrag(payload)

                switch payload.sourceKind {
                case .board:
                    self.performRuntimeMove(
                        itemID: payload.itemID,
                        itemTitle: payload.itemTitle,
                        destination: destination
                    )
                case .palette:
                    guard let item = self.paletteItemResolver?(payload.itemID) else { return }
                    self.performRuntimeInsert(item: item, destination: destination)
                }

                self.boardController?.endDrag()
            }
        }

        return true
    }

    private var resolvedSelectedItemID: String? {
        boardController?.selectedItemID ?? selectedItemID?.wrappedValue ?? localSelectedItemID
    }

    private func activationHandler(for item: Item) -> (() -> Void)? {
        guard selectedItemID != nil || onActivateItem != nil || boardController != nil else { return nil }

        return {
            updateSelectedItemID(item.id)
            boardController?.activate(itemID: item.id)
            onActivateItem?(item)
        }
    }

    private func updateSelectedItemID(_ itemID: String?) {
        if let boardController {
            boardController.select(itemID: itemID)
            return
        }
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
        guard onMoveItem != nil || supportsRuntimeMoves else { return [] }

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

        for destinationColumn in resolvedColumns where destinationColumn.id != column.id {
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
                let previousColumn = resolvedColumns[columnIndex - 1]
                destinations.append(
                    Destination(
                        title: "Move to \(previousColumn.title)",
                        columnID: previousColumn.id,
                        columnTitle: previousColumn.title,
                        index: previousColumn.items.count
                    )
                )
            }

            if columnIndex < resolvedColumns.count - 1 {
                let nextColumn = resolvedColumns[columnIndex + 1]
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

private func movedColumns(
    itemID: String,
    in columns: [Board.Column],
    destinationColumnID: String,
    destinationIndex: Int
) -> [Board.Column] {
    var mutableColumns = columns
    var movingItem: Board.Item?

    for columnIndex in mutableColumns.indices {
        if let itemIndex = mutableColumns[columnIndex].items.firstIndex(where: { $0.id == itemID }) {
            movingItem = mutableColumns[columnIndex].items[itemIndex]
            var items = mutableColumns[columnIndex].items
            items.remove(at: itemIndex)
            mutableColumns[columnIndex] = Board.Column(
                id: mutableColumns[columnIndex].id,
                title: mutableColumns[columnIndex].title,
                items: items
            )
            break
        }
    }

    guard let movingItem else { return columns }

    guard let destinationColumnIndex = mutableColumns.firstIndex(where: { $0.id == destinationColumnID }) else {
        return columns
    }

    var destinationItems = mutableColumns[destinationColumnIndex].items
    let safeIndex = min(max(destinationIndex, 0), destinationItems.count)
    destinationItems.insert(movingItem, at: safeIndex)
    mutableColumns[destinationColumnIndex] = Board.Column(
        id: mutableColumns[destinationColumnIndex].id,
        title: mutableColumns[destinationColumnIndex].title,
        items: destinationItems
    )

    return mutableColumns
}

private func insertedColumns(
    item: Board.Item,
    into columns: [Board.Column],
    destinationColumnID: String,
    destinationIndex: Int
) -> [Board.Column] {
    guard let destinationColumnIndex = columns.firstIndex(where: { $0.id == destinationColumnID }) else {
        return columns
    }

    var mutableColumns = columns
    var items = mutableColumns[destinationColumnIndex].items
    let safeIndex = min(max(destinationIndex, 0), items.count)
    items.insert(item, at: safeIndex)
    mutableColumns[destinationColumnIndex] = Board.Column(
        id: mutableColumns[destinationColumnIndex].id,
        title: mutableColumns[destinationColumnIndex].title,
        items: items
    )
    return mutableColumns
}

private func encodedPayload(_ payload: BoardDragPayload) -> String? {
    guard let data = try? JSONEncoder().encode(payload) else { return nil }
    return String(data: data, encoding: .utf8)
}

private func decodedPayload(_ payload: String) -> BoardDragPayload? {
    guard let data = payload.data(using: .utf8) else { return nil }
    return try? JSONDecoder().decode(BoardDragPayload.self, from: data)
}

private func boardPayloadString(from item: NSSecureCoding?) -> String? {
    if let string = item as? String {
        return string
    }

    if let data = item as? Data {
        return String(data: data, encoding: .utf8)
    }

    return nil
}
