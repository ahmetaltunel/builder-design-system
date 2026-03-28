import Combine
import Foundation

@MainActor
public final class FocusCoordinator: ObservableObject {
    @Published public private(set) var focusedID: String?
    @Published public private(set) var pendingRestoreID: String?

    public init(focusedID: String? = nil) {
        self.focusedID = focusedID
        self.pendingRestoreID = focusedID
    }

    public func focus(_ id: String?) {
        focusedID = id
        if let id {
            pendingRestoreID = id
        }
    }

    public func captureForRestore() {
        pendingRestoreID = focusedID
    }

    public func restore() {
        focusedID = pendingRestoreID
    }

    public func clear() {
        focusedID = nil
    }
}

