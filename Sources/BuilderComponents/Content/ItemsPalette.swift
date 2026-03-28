import SwiftUI
import BuilderFoundation

public struct ItemsPalette: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let subtitle: String?
    public let items: [Board.Item]
    public let selectedItemID: Binding<String?>?
    public let insertDestinations: [Board.Destination]
    public let onActivateItem: ((Board.Item) -> Void)?
    public let onInsertItem: ((Board.Item, String, Int) -> Void)?

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

    public var body: some View {
        PanelSurface(environment: environment, title: title, subtitle: subtitle) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(items) { item in
                    BoardItemView(
                        environment: environment,
                        item: item,
                        isSelected: resolvedSelectedItemID == item.id,
                        onActivate: activationHandler(for: item),
                        insertDestinations: insertDestinations,
                        onInsert: onInsertItem == nil ? nil : { destination in
                            updateSelectedItemID(item.id)
                            onInsertItem?(item, destination.columnID, destination.index)
                            announce("\(item.title) inserted in \(destination.columnTitle).")
                        }
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

    private func announce(_ message: String) {
        liveAnnouncement = message
        postAccessibilityAnnouncement(message)
    }
}
