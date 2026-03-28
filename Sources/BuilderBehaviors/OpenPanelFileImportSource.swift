import AppKit
import Foundation
import UniformTypeIdentifiers

@MainActor
public protocol FileImportSource: Sendable {
    func selectFiles(
        acceptedContentTypes: [UTType],
        allowsMultipleSelection: Bool
    ) async throws -> [URL]
}

public struct OpenPanelFileImportSource: FileImportSource, Sendable {
    public init() {}

    public func selectFiles(
        acceptedContentTypes: [UTType],
        allowsMultipleSelection: Bool
    ) async throws -> [URL] {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = allowsMultipleSelection
        panel.allowedContentTypes = acceptedContentTypes.filter { $0 != .fileURL }

        let response = panel.runModal()
        guard response == .OK else { return [] }
        return uniqueURLs(panel.urls)
    }
}

