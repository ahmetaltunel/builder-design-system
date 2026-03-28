import AppKit
import Combine
import Foundation
import UniformTypeIdentifiers

@MainActor
public final class FileImportController: ObservableObject {
    @Published public var state: AsyncContentState
    @Published public private(set) var acceptedContentTypes: [UTType]
    @Published public private(set) var isTargeted: Bool
    @Published public private(set) var lastImportedURLs: [URL]
    @Published public private(set) var rejectedURLs: [URL]
    @Published public private(set) var validationSummary: String?

    public let announcementCenter: AnnouncementCenter?
    public let focusCoordinator: FocusCoordinator?

    private let source: FileImportSource?

    public init(
        state: AsyncContentState = .ready,
        acceptedContentTypes: [UTType] = [.fileURL],
        isTargeted: Bool = false,
        source: FileImportSource? = nil,
        announcementCenter: AnnouncementCenter? = nil,
        focusCoordinator: FocusCoordinator? = nil
    ) {
        self.state = state
        self.acceptedContentTypes = acceptedContentTypes
        self.isTargeted = isTargeted
        self.lastImportedURLs = []
        self.rejectedURLs = []
        self.validationSummary = nil
        self.source = source
        self.announcementCenter = announcementCenter
        self.focusCoordinator = focusCoordinator
    }

    public func setAcceptedContentTypes(_ acceptedContentTypes: [UTType]) {
        self.acceptedContentTypes = acceptedContentTypes
    }

    public func setTargeted(_ isTargeted: Bool) {
        self.isTargeted = isTargeted
    }

    @discardableResult
    public func handleDroppedURLs(_ urls: [URL]) -> [URL] {
        let unique = uniqueURLs(urls)
        let accepted = unique.filter { matchesAcceptedContentType($0, acceptedContentTypes: acceptedContentTypes) }
        let rejected = unique.filter { !accepted.contains($0) }

        lastImportedURLs = accepted
        rejectedURLs = rejected
        validationSummary = rejected.isEmpty ? nil : rejectionSummary(for: rejected)

        if !accepted.isEmpty {
            announcementCenter?.announce(
                accepted.count == 1
                ? "\(accepted[0].lastPathComponent) added."
                : "\(accepted.count) files added."
            )
        }

        if !rejected.isEmpty {
            announcementCenter?.announce(rejectionSummary(for: rejected))
        }

        return accepted
    }

    @discardableResult
    public func handleItemProviders(_ providers: [NSItemProvider]) async -> [URL] {
        let urls = await ItemProviderURLBridge.resolveURLs(providers: providers)
        return handleDroppedURLs(urls)
    }

    @discardableResult
    public func importFromPicker(allowsMultipleSelection: Bool = true) async -> [URL] {
        guard let source else { return [] }

        do {
            focusCoordinator?.captureForRestore()
            let urls = try await source.selectFiles(
                acceptedContentTypes: acceptedContentTypes,
                allowsMultipleSelection: allowsMultipleSelection
            )
            let accepted = handleDroppedURLs(urls)
            focusCoordinator?.restore()
            return accepted
        } catch {
            validationSummary = "File selection failed."
            announcementCenter?.announce("File selection failed.")
            focusCoordinator?.restore()
            return []
        }
    }

    @discardableResult
    public func importFromPasteboard() -> [URL] {
        handleDroppedURLs(PasteboardBridge.fileURLs())
    }

    private func rejectionSummary(for rejected: [URL]) -> String {
        if rejected.count == 1 {
            return "\(rejected[0].lastPathComponent) does not match the accepted file types."
        }

        return "\(rejected.count) files do not match the accepted file types."
    }
}

