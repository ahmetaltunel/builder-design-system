import Foundation

@MainActor
public final class UndoRegistrar {
    public weak var undoManager: UndoManager?

    public init(undoManager: UndoManager? = nil) {
        self.undoManager = undoManager
    }

    public func register(actionName: String, undo: @escaping @MainActor () -> Void) {
        guard let undoManager else { return }
        undoManager.registerUndo(withTarget: self) { _ in
            undo()
        }
        undoManager.setActionName(actionName)
    }
}

