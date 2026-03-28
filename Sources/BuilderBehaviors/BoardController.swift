import Combine
import Foundation

public struct BoardDragPayload: Codable, Hashable, Sendable {
    public enum SourceKind: String, Codable, Hashable, Sendable {
        case board
        case palette
    }

    public let itemID: String
    public let itemTitle: String
    public let sourceColumnID: String?
    public let sourceKind: SourceKind

    public init(
        itemID: String,
        itemTitle: String,
        sourceColumnID: String? = nil,
        sourceKind: SourceKind
    ) {
        self.itemID = itemID
        self.itemTitle = itemTitle
        self.sourceColumnID = sourceColumnID
        self.sourceKind = sourceKind
    }
}

@MainActor
public final class BoardController: ObservableObject {
    @Published public private(set) var selectedItemID: String?
    @Published public private(set) var focusedItemID: String?
    @Published public private(set) var draggedPayload: BoardDragPayload?

    public let announcementCenter: AnnouncementCenter?
    public let focusCoordinator: FocusCoordinator?
    public let undoRegistrar: UndoRegistrar?

    public init(
        selectedItemID: String? = nil,
        announcementCenter: AnnouncementCenter? = nil,
        focusCoordinator: FocusCoordinator? = nil,
        undoRegistrar: UndoRegistrar? = nil
    ) {
        self.selectedItemID = selectedItemID
        self.focusedItemID = selectedItemID
        self.announcementCenter = announcementCenter
        self.focusCoordinator = focusCoordinator
        self.undoRegistrar = undoRegistrar
    }

    public func select(itemID: String?) {
        selectedItemID = itemID
        focusedItemID = itemID
        focusCoordinator?.focus(itemID)
    }

    public func activate(itemID: String) {
        select(itemID: itemID)
    }

    public func beginDrag(_ payload: BoardDragPayload) {
        draggedPayload = payload
        focusCoordinator?.captureForRestore()
    }

    public func endDrag() {
        draggedPayload = nil
        focusCoordinator?.restore()
    }

    public func move(
        itemID: String,
        itemTitle: String,
        destinationColumnTitle: String,
        actionName: String = "Move Item",
        apply: () -> Void,
        undo: @escaping @MainActor () -> Void
    ) {
        apply()
        select(itemID: itemID)
        announcementCenter?.announce("\(itemTitle) moved to \(destinationColumnTitle).")
        undoRegistrar?.register(actionName: actionName, undo: undo)
        focusCoordinator?.restore()
    }

    public func insert(
        itemID: String,
        itemTitle: String,
        destinationColumnTitle: String,
        actionName: String = "Insert Item",
        apply: () -> Void,
        undo: @escaping @MainActor () -> Void
    ) {
        apply()
        select(itemID: itemID)
        announcementCenter?.announce("\(itemTitle) inserted in \(destinationColumnTitle).")
        undoRegistrar?.register(actionName: actionName, undo: undo)
        focusCoordinator?.restore()
    }
}

