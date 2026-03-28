import AppKit
import SwiftUI
import BuilderFoundation

@MainActor
public struct NavigationBrowserList<ID: Hashable, RowContent: View>: NSViewRepresentable {
    public let environment: DesignSystemEnvironment
    public let items: [NavigationItem<ID>]
    @Binding public var selection: ID
    public let rowHeight: CGFloat
    public let focusRequest: Int
    public let onActivate: ((NavigationItem<ID>) -> Void)?
    public let rowContent: (NavigationItem<ID>, Bool) -> RowContent

    public init(
        environment: DesignSystemEnvironment,
        items: [NavigationItem<ID>],
        selection: Binding<ID>,
        rowHeight: CGFloat = 52,
        focusRequest: Int = 0,
        onActivate: ((NavigationItem<ID>) -> Void)? = nil,
        @ViewBuilder rowContent: @escaping (NavigationItem<ID>, Bool) -> RowContent
    ) {
        self.environment = environment
        self.items = items
        self._selection = selection
        self.rowHeight = rowHeight
        self.focusRequest = focusRequest
        self.onActivate = onActivate
        self.rowContent = rowContent
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    public func makeNSView(context: Context) -> NSScrollView {
        context.coordinator.makeScrollView()
    }

    public func updateNSView(_ nsView: NSScrollView, context: Context) {
        context.coordinator.parent = self
        context.coordinator.update(scrollView: nsView)
    }

    @MainActor
    public final class Coordinator: NSObject, NSTableViewDataSource, NSTableViewDelegate {
        var parent: NavigationBrowserList
        private weak var tableView: NavigationTableView?
        private var lastFocusRequest: Int
        private var isApplyingSelectionFromSwiftUI = false

        init(parent: NavigationBrowserList) {
            self.parent = parent
            self.lastFocusRequest = parent.focusRequest
        }

        func makeScrollView() -> NSScrollView {
            let scrollView = NSScrollView()
            scrollView.drawsBackground = false
            scrollView.borderType = .noBorder
            scrollView.hasVerticalScroller = true
            scrollView.hasHorizontalScroller = false
            scrollView.autohidesScrollers = true
            scrollView.focusRingType = .none

            let tableView = NavigationTableView()
            tableView.headerView = nil
            tableView.backgroundColor = .clear
            tableView.selectionHighlightStyle = .none
            tableView.intercellSpacing = .zero
            tableView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
            tableView.delegate = self
            tableView.dataSource = self
            tableView.action = #selector(handleAction)
            tableView.doubleAction = #selector(handleDoubleAction)
            tableView.target = self
            tableView.activationHandler = { [weak self] in
                self?.activateSelectedItem()
            }

            let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("navigation-browser"))
            column.resizingMask = .autoresizingMask
            tableView.addTableColumn(column)

            scrollView.documentView = tableView
            self.tableView = tableView
            update(scrollView: scrollView)
            return scrollView
        }

        func update(scrollView: NSScrollView) {
            guard let tableView else { return }

            tableView.rowHeight = parent.rowHeight
            tableView.reloadData()
            syncSelection(scrollToVisible: false)

            if lastFocusRequest != parent.focusRequest {
                lastFocusRequest = parent.focusRequest
                DispatchQueue.main.async { [weak tableView] in
                    guard let tableView, let window = tableView.window else { return }
                    window.makeFirstResponder(tableView)
                }
            }
        }

        public func numberOfRows(in tableView: NSTableView) -> Int {
            parent.items.count
        }

        public func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
            parent.rowHeight
        }

        public func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
            parent.items[row].isEnabled
        }

        public func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
            NavigationRowView()
        }

        public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
            let item = parent.items[row]
            let identifier = NavigationHostingCellView.reuseIdentifier
            let cellView = (tableView.makeView(withIdentifier: identifier, owner: nil) as? NavigationHostingCellView) ?? {
                let view = NavigationHostingCellView()
                view.identifier = identifier
                return view
            }()

            cellView.setRootView(AnyView(parent.rowContent(item, item.id == parent.selection)))
            return cellView
        }

        public func tableViewSelectionDidChange(_ notification: Notification) {
            guard !isApplyingSelectionFromSwiftUI else { return }
            guard let tableView, tableView.selectedRow >= 0, tableView.selectedRow < parent.items.count else { return }

            let selectedItem = parent.items[tableView.selectedRow]
            guard selectedItem.id != parent.selection else { return }
            DispatchQueue.main.async { [weak self, selection = selectedItem.id] in
                guard let self else { return }
                guard selection != self.parent.selection else { return }
                self.parent.selection = selection
            }
        }

        @objc
        private func handleAction() {
            activateSelectedItem()
        }

        @objc
        private func handleDoubleAction() {
            activateSelectedItem()
        }

        private func activateSelectedItem() {
            guard let tableView, tableView.selectedRow >= 0, tableView.selectedRow < parent.items.count else { return }
            parent.onActivate?(parent.items[tableView.selectedRow])
        }

        private func syncSelection(scrollToVisible: Bool) {
            guard let tableView else { return }

            guard !parent.items.isEmpty else {
                tableView.deselectAll(nil)
                return
            }

            let targetIndex = parent.items.firstIndex(where: { $0.id == parent.selection }) ?? 0
            if targetIndex == 0, parent.items[targetIndex].id != parent.selection {
                DispatchQueue.main.async { [selection = parent.items[targetIndex].id] in
                    self.parent.selection = selection
                }
            }

            let targetSelection = IndexSet(integer: targetIndex)
            if tableView.selectedRowIndexes != targetSelection {
                isApplyingSelectionFromSwiftUI = true
                tableView.selectRowIndexes(targetSelection, byExtendingSelection: false)
                isApplyingSelectionFromSwiftUI = false
            }

            if scrollToVisible {
                tableView.scrollRowToVisible(targetIndex)
            }
        }
    }
}
