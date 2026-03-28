import Foundation

public enum AsyncContentState: Hashable, Sendable {
    public struct LoadingPresentation: Hashable, Sendable {
        public let label: String?
        public let detail: String?

        public init(label: String? = nil, detail: String? = nil) {
            self.label = label
            self.detail = detail
        }
    }

    public struct EmptyPresentation: Hashable, Sendable {
        public let title: String
        public let message: String
        public let symbol: String

        public init(
            title: String,
            message: String,
            symbol: String = "tray"
        ) {
            self.title = title
            self.message = message
            self.symbol = symbol
        }
    }

    public struct ErrorPresentation: Hashable, Sendable {
        public let title: String
        public let message: String

        public init(
            title: String,
            message: String
        ) {
            self.title = title
            self.message = message
        }
    }

    case ready
    case loading(LoadingPresentation)
    case empty(EmptyPresentation)
    case error(ErrorPresentation)

    public var isReady: Bool {
        if case .ready = self {
            true
        } else {
            false
        }
    }
}

