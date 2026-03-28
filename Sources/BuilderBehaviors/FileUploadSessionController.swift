import Combine
import Foundation

public struct FileUploadRequest: Identifiable, Hashable, Sendable {
    public let id: String
    public let url: URL
    public let title: String
    public let detail: String?
    public let symbol: String

    public init(
        id: String? = nil,
        url: URL,
        title: String? = nil,
        detail: String? = nil,
        symbol: String = "doc"
    ) {
        self.id = id ?? url.lastPathComponent
        self.url = url
        self.title = title ?? url.lastPathComponent
        self.detail = detail
        self.symbol = symbol
    }
}

public struct FileUploadEvent: Hashable, Sendable {
    public let requestID: String
    public let status: FileUploadItem.Status
    public let progress: Double?
    public let message: String?
    public let symbol: String?
    public let canRetry: Bool

    public init(
        requestID: String,
        status: FileUploadItem.Status,
        progress: Double? = nil,
        message: String? = nil,
        symbol: String? = nil,
        canRetry: Bool = false
    ) {
        self.requestID = requestID
        self.status = status
        self.progress = progress
        self.message = message
        self.symbol = symbol
        self.canRetry = canRetry
    }
}

public protocol FileUploadDriver: Sendable {
    func upload(request: FileUploadRequest) -> AsyncThrowingStream<FileUploadEvent, Error>
}

@MainActor
public final class FileUploadSessionController: ObservableObject {
    @Published public var state: AsyncContentState
    @Published public private(set) var items: [FileUploadItem]
    @Published public private(set) var validationSummary: String?

    public let announcementCenter: AnnouncementCenter?

    private var requestsByID: [String: FileUploadRequest]
    private var tasks: [String: Task<Void, Never>]

    public init(
        items: [FileUploadItem] = [],
        state: AsyncContentState = .ready,
        announcementCenter: AnnouncementCenter? = nil
    ) {
        self.items = items
        self.state = state
        self.announcementCenter = announcementCenter
        self.validationSummary = nil
        self.requestsByID = [:]
        self.tasks = [:]
    }

    public var isUploading: Bool {
        items.contains { $0.status == .uploading }
    }

    @discardableResult
    public func enqueue(urls: [URL], symbol: String = "doc") -> [FileUploadRequest] {
        let requests = urls.map { FileUploadRequest(url: $0, symbol: symbol) }
        enqueue(requests: requests)
        return requests
    }

    public func enqueue(requests: [FileUploadRequest]) {
        for request in requests {
            requestsByID[request.id] = request

            if let index = items.firstIndex(where: { $0.id == request.id }) {
                items[index] = FileUploadItem(
                    id: request.id,
                    title: request.title,
                    detail: request.detail,
                    status: .ready,
                    symbol: request.symbol
                )
            } else {
                items.append(
                    FileUploadItem(
                        id: request.id,
                        title: request.title,
                        detail: request.detail,
                        status: .ready,
                        symbol: request.symbol
                    )
                )
            }
        }
    }

    public func startUploads(using driver: FileUploadDriver) {
        for item in items where item.status == .ready || (item.canRetry && (item.status == .error || item.status == .warning)) {
            startUpload(id: item.id, using: driver)
        }
    }

    public func startUpload(id: String, using driver: FileUploadDriver) {
        guard tasks[id] == nil, let request = requestsByID[id] else { return }

        apply(
            FileUploadEvent(
                requestID: id,
                status: .uploading,
                progress: nil,
                message: "Uploading",
                symbol: request.symbol,
                canRetry: false
            )
        )

        tasks[id] = Task {
            do {
                for try await event in driver.upload(request: request) {
                    await MainActor.run {
                        self.apply(event)
                    }
                }
            } catch {
                await MainActor.run {
                    self.apply(
                        FileUploadEvent(
                            requestID: id,
                            status: .error,
                            progress: nil,
                            message: "Upload failed.",
                            symbol: request.symbol,
                            canRetry: true
                        )
                    )
                }
            }

            await MainActor.run {
                self.tasks[id] = nil
            }
        }
    }

    public func retry(id: String, using driver: FileUploadDriver) {
        startUpload(id: id, using: driver)
    }

    public func retryFailed(using driver: FileUploadDriver) {
        for item in items where item.canRetry {
            startUpload(id: item.id, using: driver)
        }
    }

    public func cancel(id: String) {
        tasks[id]?.cancel()
        tasks[id] = nil

        if let request = requestsByID[id] {
            apply(
                FileUploadEvent(
                    requestID: id,
                    status: .warning,
                    progress: nil,
                    message: "Upload canceled.",
                    symbol: request.symbol,
                    canRetry: true
                )
            )
        }
    }

    public func cancelAll() {
        for id in tasks.keys {
            cancel(id: id)
        }
    }

    public func remove(id: String) {
        cancel(id: id)
        items.removeAll { $0.id == id }
        requestsByID.removeValue(forKey: id)
    }

    public func removeCompleted() {
        let completedIDs = Set(items.filter { $0.status == .success }.map(\.id))
        items.removeAll { completedIDs.contains($0.id) }
        for id in completedIDs {
            requestsByID.removeValue(forKey: id)
        }
    }

    private func apply(_ event: FileUploadEvent) {
        guard let existingIndex = items.firstIndex(where: { $0.id == event.requestID }) else { return }

        let existing = items[existingIndex]
        let updated = FileUploadItem(
            id: existing.id,
            title: existing.title,
            detail: existing.detail,
            status: event.status,
            progress: event.progress,
            message: event.message,
            symbol: event.symbol ?? existing.symbol,
            canRetry: event.canRetry
        )
        items[existingIndex] = updated

        switch event.status {
        case .success:
            announcementCenter?.announce("\(updated.title) uploaded.")
        case .error:
            announcementCenter?.announce("\(updated.title) failed to upload.")
        default:
            break
        }

        let failedCount = items.filter { $0.status == .error || $0.status == .warning }.count
        validationSummary = failedCount == 0 ? nil : "\(failedCount) upload items need attention."
    }
}

