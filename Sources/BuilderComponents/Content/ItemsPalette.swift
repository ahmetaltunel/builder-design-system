import SwiftUI
import BuilderFoundation
import BuilderBehaviors

public struct ItemsPalette: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let subtitle: String?
    public let items: [Board.Item]
    public let selectedItemID: Binding<String?>?
    public let insertDestinations: [Board.Destination]
    public let onActivateItem: ((Board.Item) -> Void)?
    public let onInsertItem: ((Board.Item, String, Int) -> Void)?
    public let boardController: BoardController?

    @State private var localSelectedItemID: String?
    @State private var liveAnnouncement: String?

    public init(
        environment: DesignSystemEnvironment,
        title: String = "Items palette",
        subtitle: String? = nil,
        items: [Board.Item],
        selectedItemID: Binding<String?>? = nil,
        insertDestinations: [Board.Destination] = [],
        onActivateItem: ((Board.Item) -> Void)? = nil,
        onInsertItem: ((Board.Item, String, Int) -> Void)? = nil
    ) {
        self.environment = environment
        self.title = title
        self.subtitle = subtitle
        self.items = items
        self.selectedItemID = selectedItemID
        self.insertDestinations = insertDestinations
        self.onActivateItem = onActivateItem
        self.onInsertItem = onInsertItem
        self.boardController = nil
    }

    public init(
        environment: DesignSystemEnvironment,
        title: String = "Items palette",
        subtitle: String? = nil,
        items: [Board.Item],
        onSelect: ((Board.Item) -> Void)? = nil
    ) {
        self.init(
            environment: environment,
            title: title,
            subtitle: subtitle,
            items: items,
            selectedItemID: nil,
            insertDestinations: [],
            onActivateItem: onSelect,
            onInsertItem: nil
        )
    }

    public init(
        environment: DesignSystemEnvironment,
        title: String = "Items palette",
        subtitle: String? = nil,
        items: [Board.Item],
        controller: BoardController,
        insertDestinations: [Board.Destination] = [],
        onActivateItem: ((Board.Item) -> Void)? = nil,
        onInsertItem: ((Board.Item, String, Int) -> Void)? = nil
    ) {
        self.environment = environment
        self.title = title
        self.subtitle = subtitle
        self.items = items
        self.selectedItemID = Binding(
            get: { controller.selectedItemID },
            set: { controller.select(itemID: $0) }
        )
        self.insertDestinations = insertDestinations
        self.onActivateItem = onActivateItem
        self.onInsertItem = onInsertItem
        self.boardController = controller
    }

    public var body: some View {
        PanelSurface(environment: environment, title: title, subtitle: subtitle) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(items) { item in
                    BoardItemView(
                        environment: environment,
                        item: item,
                        isSelected: resolvedSelectedItemID == item.id,
                        isFocused: boardController?.focusedItemID == item.id,
                        onActivate: activationHandler(for: item),
                        insertDestinations: insertDestinations,
                        onInsert: onInsertItem == nil ? nil : { destination in
                            updateSelectedItemID(item.id)
                            onInsertItem?(item, destination.columnID, destination.index)
                            announce("\(item.title) inserted in \(destination.columnTitle).")
                        },
                        dragPayload: dragPayload(for: item)
                    )
                }

                if let liveAnnouncement, !liveAnnouncement.isEmpty {
                    AccessibilityAnnouncementRegion(message: liveAnnouncement)
                }
            }
        }
    }

    private var resolvedSelectedItemID: String? {
        selectedItemID?.wrappedValue ?? localSelectedItemID
    }

    private func activationHandler(for item: Board.Item) -> (() -> Void)? {
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

    private func announce(_ message: String) {
        liveAnnouncement = message
        postAccessibilityAnnouncement(message)
    }

    private func dragPayload(for item: Board.Item) -> String? {
        guard boardController != nil else { return nil }
        let payload = BoardDragPayload(
            itemID: item.id,
            itemTitle: item.title,
            sourceColumnID: nil,
            sourceKind: .palette
        )
        guard let data = try? JSONEncoder().encode(payload) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
