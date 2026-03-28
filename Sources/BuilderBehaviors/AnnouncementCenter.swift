import Combine
import Foundation

@MainActor
public final class AnnouncementCenter: ObservableObject {
    @Published public private(set) var latestMessage: String?

    public init(latestMessage: String? = nil) {
        self.latestMessage = latestMessage
    }

    public func announce(_ message: String) {
        latestMessage = message
    }

    public func clear() {
        latestMessage = nil
    }
}

