import Foundation

@MainActor
public final class CommandRegistry {
    public struct Command: Identifiable, Hashable, Sendable {
        public let id: String
        public let title: String
        public let discoverabilityTitle: String?

        public init(id: String, title: String, discoverabilityTitle: String? = nil) {
            self.id = id
            self.title = title
            self.discoverabilityTitle = discoverabilityTitle
        }
    }

    public enum CommandID {
        public static let nextTutorialStep = "builder.nextTutorialStep"
        public static let previousTutorialStep = "builder.previousTutorialStep"
        public static let submitPrompt = "builder.submitPrompt"
        public static let retryMessage = "builder.retryMessage"
        public static let moveBoardItem = "builder.moveBoardItem"
        public static let openHelp = "builder.openHelp"
        public static let nextPage = "builder.nextPage"
        public static let previousPage = "builder.previousPage"
    }

    private var handlers: [String: () -> Void] = [:]
    public private(set) var commands: [Command] = []

    public init() {}

    public func register(_ command: Command, action: @escaping () -> Void) {
        handlers[command.id] = action
        if let index = commands.firstIndex(where: { $0.id == command.id }) {
            commands[index] = command
        } else {
            commands.append(command)
        }
    }

    @discardableResult
    public func perform(_ id: String) -> Bool {
        guard let handler = handlers[id] else { return false }
        handler()
        return true
    }

    public func remove(_ id: String) {
        handlers.removeValue(forKey: id)
        commands.removeAll { $0.id == id }
    }
}

