import Combine
import Foundation

@MainActor
public final class SelectionStore<Value: Hashable & Sendable>: ObservableObject {
    @Published public private(set) var selection: Value?

    public init(selection: Value? = nil) {
        self.selection = selection
    }

    public func select(_ value: Value?) {
        selection = value
    }

    public func clear() {
        selection = nil
    }

    public func toggle(_ value: Value) {
        selection = selection == value ? nil : value
    }
}

