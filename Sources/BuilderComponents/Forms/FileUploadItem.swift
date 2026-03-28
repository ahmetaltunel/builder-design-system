import Foundation

public struct FileUploadItem: Identifiable, Hashable, Sendable {
    public enum Status: Hashable, Sendable {
        case ready
        case uploading
        case success
        case warning
        case error
    }

    public let id: String
    public let title: String
    public let detail: String?
    public let status: Status
    public let progress: Double?
    public let message: String?
    public let symbol: String
    public let canRetry: Bool

    public init(
        id: String? = nil,
        title: String,
        detail: String? = nil,
        status: Status = .ready,
        progress: Double? = nil,
        message: String? = nil,
        symbol: String = "doc",
        canRetry: Bool = false
    ) {
        self.id = id ?? title
        self.title = title
        self.detail = detail
        self.status = status
        self.progress = progress.map { min(max($0, 0), 1) }
        self.message = message
        self.symbol = symbol
        self.canRetry = canRetry
    }

    public init(
        id: String? = nil,
        title: String,
        detail: String? = nil,
        status: Status = .ready
    ) {
        self.init(
            id: id,
            title: title,
            detail: detail,
            status: status,
            progress: nil,
            message: nil,
            symbol: "doc",
            canRetry: false
        )
    }
}
