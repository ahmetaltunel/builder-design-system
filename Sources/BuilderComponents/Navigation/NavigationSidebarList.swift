import AppKit
import SwiftUI
import BuilderFoundation

@MainActor
public struct NavigationSidebarList<ID: Hashable, RowContent: View>: NSViewRepresentable {
    public let environment: DesignSystemEnvironment
    public let sections: [NavigationSection<ID>]
    private let selectedID: ID?
    private let setSelection: (ID?) -> Void
    public let rowHeight: CGFloat
    public let sectionHeaderHeight: CGFloat
    public let focusRequest: Int
    public let onActivate: ((NavigationItem<ID>) -> Void)?
    public let rowContent: (NavigationItem<ID>, Bool) -> RowContent

    public init(
        environment: DesignSystemEnvironment,
        sections: [NavigationSection<ID>],
        selection: Binding<ID?>,
        rowHeight: CGFloat = 40,
        sectionHeaderHeight: CGFloat = 28,
        focusRequest: Int = 0,
        onActivate: ((NavigationItem<ID>) -> Void)? = nil,
        @ViewBuilder rowContent: @escaping (NavigationItem<ID>, Bool) -> RowContent
    ) {
        self.environment = environment
        self.sections = sections
        self.selectedID = selection.wrappedValue
        self.setSelection = { selection.wrappedValue = $0 }
        self.rowHeight = rowHeight
        self.sectionHeaderHeight = sectionHeaderHeight
        self.focusRequest = focusRequest
        self.onActivate = onActivate
        self.rowContent = rowContent
    }

    public init(
        environment: DesignSystemEnvironment,
        sections: [NavigationSection<ID>],
        selection: Binding<ID>,
        rowHeight: CGFloat = 40,
        sectionHeaderHeight: CGFloat = 28,
        focusRequest: Int = 0,
        onActivate: ((NavigationItem<ID>) -> Void)? = nil,
        @ViewBuilder rowContent: @escaping (NavigationItem<ID>, Bool) -> RowContent
    ) {
        self.environment = environment
        self.sections = sections
        self.selectedID = selection.wrappedValue
        self.setSelection = { newValue in
            guard let newValue else { return }
            selection.wrappedValue = newValue
        }
        self.rowHeight = rowHeight
        self.sectionHeaderHeight = sectionHeaderHeight
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
    public final class Coordinator: NSObject, NSOutlineViewDataSource, NSOutlineViewDelegate {
        var parent: NavigationSidebarList
        private weak var outlineView: NavigationOutlineView?
        private var lastFocusRequest: Int
        private var sectionNodes: [SectionNode] = []
        private var itemNodes: [[ItemNode]] = []
        private var isApplyingSelectionFromSwiftUI = false

        init(parent: NavigationSidebarList) {
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

            let outlineView = NavigationOutlineView()
            outlineView.headerView = nil
            outlineView.backgroundColor = .clear
            outlineView.selectionHighlightStyle = .none
            outlineView.intercellSpacing = .zero
            outlineView.indentationPerLevel = 0
            outlineView.indentationMarkerFollowsCell = false
            outlineView.delegate = self
            outlineView.dataSource = self
            outlineView.action = #selector(handleAction)
            outlineView.doubleAction = #selector(handleDoubleAction)
            outlineView.target = self
            outlineView.activationHandler = { [weak self] in
                self?.activateSelectedItem()
            }

            let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("navigation-sidebar"))
            column.resizingMask = .autoresizingMask
            outlineView.addTableColumn(column)
            outlineView.outlineTableColumn = column

            scrollView.documentView = outlineView
            self.outlineView = outlineView
            update(scrollView: scrollView)
            return scrollView
        }

        func update(scrollView: NSScrollView) {
            guard let outlineView else { return }

            rebuildNodes()
            outlineView.reloadData()
            sectionNodes.forEach { outlineView.expandItem($0, expandChildren: false) }
            syncSelection(scrollToVisible: false)

            if lastFocusRequest != parent.focusRequest {
                lastFocusRequest = parent.focusRequest
                DispatchQueue.main.async { [weak outlineView] in
                    guard let outlineView, let window = outlineView.window else { return }
                    window.makeFirstResponder(outlineView)
                }
            }
        }

        public func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
            if item == nil {
                return sectionNodes.count
            } else if let sectionNode = item as? SectionNode {
                return itemNodes[sectionNode.sectionIndex].count
            } else {
                return 0
            }
        }

        public func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
            if item == nil {
                return sectionNodes[index]
            } else if let sectionNode = item as? SectionNode {
                return itemNodes[sectionNode.sectionIndex][index]
            } else {
                fatalError("Unexpected outline item")
            }
        }

        public func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
            item is SectionNode
        }

        public func outlineView(_ outlineView: NSOutlineView, shouldShowOutlineCellForItem item: Any) -> Bool {
            false
        }

        public func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
            item is SectionNode
        }

        public func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
            guard let itemNode = item as? ItemNode else { return false }
            return parent.sections[itemNode.sectionIndex].items[itemNode.itemIndex].isEnabled
        }

        public func outlineViewSelectionDidChange(_ notification: Notification) {
            guard !isApplyingSelectionFromSwiftUI else { return }
            guard let outlineView,
                  outlineView.selectedRow >= 0,
                  let node = outlineView.item(atRow: outlineView.selectedRow) as? ItemNode else {
                return
            }

            let selectedItem = parent.sections[node.sectionIndex].items[node.itemIndex]
            guard selectedItem.id != parent.selectedID else { return }
            DispatchQueue.main.async { [weak self, selection = selectedItem.id] in
                guard let self else { return }
                guard selection != self.parent.selectedID else { return }
                self.parent.setSelection(selection)
            }
        }

        public func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
            NavigationRowView()
        }

        public func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
            item is SectionNode ? parent.sectionHeaderHeight : parent.rowHeight
        }

        public func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
            let identifier = NavigationHostingCellView.reuseIdentifier
            let cellView = (outlineView.makeView(withIdentifier: identifier, owner: nil) as? NavigationHostingCellView) ?? {
                let view = NavigationHostingCellView()
                view.identifier = identifier
                return view
            }()

            if let sectionNode = item as? SectionNode {
                let title = parent.sections[sectionNode.sectionIndex].title ?? ""
                cellView.setRootView(
                    AnyView(
                        Text(title)
                            .font(parent.environment.theme.typography(.captionStrong).font)
                            .foregroundStyle(parent.environment.theme.color(.textMuted))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 2)
                    )
                )
                return cellView
            }

            guard let itemNode = item as? ItemNode else { return nil }
            let navigationItem = parent.sections[itemNode.sectionIndex].items[itemNode.itemIndex]
            cellView.setRootView(AnyView(parent.rowContent(navigationItem, navigationItem.id == parent.selectedID)))
            return cellView
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
            guard let outlineView,
                  outlineView.selectedRow >= 0,
                  let node = outlineView.item(atRow: outlineView.selectedRow) as? ItemNode else {
                return
            }

            parent.onActivate?(parent.sections[node.sectionIndex].items[node.itemIndex])
        }

        private func rebuildNodes() {
            sectionNodes = parent.sections.enumerated().map { SectionNode(sectionIndex: $0.offset) }
            itemNodes = parent.sections.enumerated().map { sectionOffset, section in
                section.items.enumerated().map { ItemNode(sectionIndex: sectionOffset, itemIndex: $0.offset) }
            }
        }

        private func syncSelection(scrollToVisible: Bool) {
            guard let outlineView else { return }
            let allItems = parent.sections.flatMap(\.items)
            guard !allItems.isEmpty else {
                outlineView.deselectAll(nil)
                return
            }

            guard let selectedID = parent.selectedID else {
                if outlineView.selectedRow != -1 {
                    isApplyingSelectionFromSwiftUI = true
                    outlineView.deselectAll(nil)
                    isApplyingSelectionFromSwiftUI = false
                }
                return
            }

            var targetItemNode: ItemNode?
            for sectionIndex in parent.sections.indices {
                if let itemIndex = parent.sections[sectionIndex].items.firstIndex(where: { $0.id == selectedID }) {
                    targetItemNode = itemNodes[sectionIndex][itemIndex]
                    break
                }
            }

            guard let targetItemNode else {
                if outlineView.selectedRow != -1 {
                    isApplyingSelectionFromSwiftUI = true
                    outlineView.deselectAll(nil)
                    isApplyingSelectionFromSwiftUI = false
                }
                return
            }
            let row = outlineView.row(forItem: targetItemNode)
            guard row >= 0 else { return }

            let targetSelection = IndexSet(integer: row)
            if outlineView.selectedRowIndexes != targetSelection {
                isApplyingSelectionFromSwiftUI = true
                outlineView.selectRowIndexes(targetSelection, byExtendingSelection: false)
                isApplyingSelectionFromSwiftUI = false
            }

            if scrollToVisible {
                outlineView.scrollRowToVisible(row)
            }
        }

        @MainActor
        final class SectionNode: NSObject {
            let sectionIndex: Int

            init(sectionIndex: Int) {
                self.sectionIndex = sectionIndex
            }
        }

        @MainActor
        final class ItemNode: NSObject {
            let sectionIndex: Int
            let itemIndex: Int

            init(sectionIndex: Int, itemIndex: Int) {
                self.sectionIndex = sectionIndex
                self.itemIndex = itemIndex
            }
        }
    }
}
