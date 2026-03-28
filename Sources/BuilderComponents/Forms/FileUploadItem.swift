import Foundation

public struct FileUploadItem: Identifiable {
    public enum Status {
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

    public init(
        id: String? = nil,
        title: String,
        detail: String? = nil,
        status: Status = .ready
    ) {
        self.id = id ?? title
        self.title = title
        self.detail = detail
        self.status = status
    }
}
