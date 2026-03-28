import UniformTypeIdentifiers
import SwiftUI
import BuilderFoundation
import BuilderBehaviors

public struct FileUploadField: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let subtitle: String?
    public let dropTitle: String
    public let dropDetail: String
    public let items: [FileUploadItem]
    public let state: AsyncContentState
    public let emptyActionTitle: String?
    public let onEmptyAction: (() -> Void)?
    public let errorActionTitle: String?
    public let onErrorAction: (() -> Void)?
    public let acceptedContentTypes: [UTType]
    public let isTargeted: Binding<Bool>?
    public let onDropURLs: (([URL]) -> Void)?
    public let pickerTitle: String
    public let onPick: () -> Void
    public let pasteActionTitle: String?
    public let onPaste: (() -> Void)?
    public let validationSummary: String?
    public let onRetry: ((FileUploadItem) -> Void)?
    public let onCancel: ((FileUploadItem) -> Void)?
    public let onRemove: ((FileUploadItem) -> Void)?
    public let onRetryFailed: (() -> Void)?
    public let onRemoveCompleted: (() -> Void)?
    public let onCancelAll: (() -> Void)?

    @State private var liveAnnouncement: String?

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        dropTitle: String = "Drop files",
        dropDetail: String = "Drag files here or browse from disk.",
        items: [FileUploadItem] = [],
        state: AsyncContentState = .ready,
        emptyActionTitle: String? = nil,
        onEmptyAction: (() -> Void)? = nil,
        errorActionTitle: String? = nil,
        onErrorAction: (() -> Void)? = nil,
        acceptedContentTypes: [UTType] = [.fileURL],
        isTargeted: Binding<Bool>? = nil,
        onDropURLs: (([URL]) -> Void)? = nil,
        pickerTitle: String = "Browse files",
        onPick: @escaping () -> Void,
        pasteActionTitle: String? = nil,
        onPaste: (() -> Void)? = nil,
        validationSummary: String? = nil,
        onRetry: ((FileUploadItem) -> Void)? = nil,
        onCancel: ((FileUploadItem) -> Void)? = nil,
        onRemove: ((FileUploadItem) -> Void)? = nil,
        onRetryFailed: (() -> Void)? = nil,
        onRemoveCompleted: (() -> Void)? = nil,
        onCancelAll: (() -> Void)? = nil
    ) {
        self.environment = environment
        self.title = title
        self.subtitle = subtitle
        self.dropTitle = dropTitle
        self.dropDetail = dropDetail
        self.items = items
        self.state = state
        self.emptyActionTitle = emptyActionTitle
        self.onEmptyAction = onEmptyAction
        self.errorActionTitle = errorActionTitle
        self.onErrorAction = onErrorAction
        self.acceptedContentTypes = acceptedContentTypes
        self.isTargeted = isTargeted
        self.onDropURLs = onDropURLs
        self.pickerTitle = pickerTitle
        self.onPick = onPick
        self.pasteActionTitle = pasteActionTitle
        self.onPaste = onPaste
        self.validationSummary = validationSummary
        self.onRetry = onRetry
        self.onCancel = onCancel
        self.onRemove = onRemove
        self.onRetryFailed = onRetryFailed
        self.onRemoveCompleted = onRemoveCompleted
        self.onCancelAll = onCancelAll
    }

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        dropTitle: String = "Drop files",
        dropDetail: String = "Drag files here or browse from disk.",
        items: [FileUploadItem] = [],
        pickerTitle: String = "Browse files",
        onPick: @escaping () -> Void,
        onRetry: ((FileUploadItem) -> Void)? = nil,
        onRemove: ((FileUploadItem) -> Void)? = nil
    ) {
        self.init(
            environment: environment,
            title: title,
            subtitle: subtitle,
            dropTitle: dropTitle,
            dropDetail: dropDetail,
            items: items,
            state: .ready,
            emptyActionTitle: nil,
            onEmptyAction: nil,
            errorActionTitle: nil,
            onErrorAction: nil,
            acceptedContentTypes: [.fileURL],
            isTargeted: nil,
            onDropURLs: nil,
            pickerTitle: pickerTitle,
            onPick: onPick,
            pasteActionTitle: nil,
            onPaste: nil,
            validationSummary: nil,
            onRetry: onRetry,
            onCancel: nil,
            onRemove: onRemove
        )
    }

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        dropTitle: String = "Drop files",
        dropDetail: String = "Drag files here or browse from disk.",
        items: [FileUploadItem] = [],
        pickerTitle: String = "Browse files",
        onPick: @escaping () -> Void,
        onRemove: ((FileUploadItem) -> Void)? = nil
    ) {
        self.init(
            environment: environment,
            title: title,
            subtitle: subtitle,
            dropTitle: dropTitle,
            dropDetail: dropDetail,
            items: items,
            state: .ready,
            emptyActionTitle: nil,
            onEmptyAction: nil,
            errorActionTitle: nil,
            onErrorAction: nil,
            acceptedContentTypes: [.fileURL],
            isTargeted: nil,
            onDropURLs: nil,
            pickerTitle: pickerTitle,
            onPick: onPick,
            pasteActionTitle: nil,
            onPaste: nil,
            validationSummary: nil,
            onRetry: nil,
            onCancel: nil,
            onRemove: onRemove
        )
    }

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        dropTitle: String = "Drop files",
        dropDetail: String = "Drag files here or browse from disk.",
        importController: FileImportController,
        uploadController: FileUploadSessionController,
        pickerTitle: String = "Browse files",
        pasteActionTitle: String? = "Paste files",
        allowsMultipleSelection: Bool = true
    ) {
        self.init(
            environment: environment,
            title: title,
            subtitle: subtitle,
            dropTitle: dropTitle,
            dropDetail: dropDetail,
            items: uploadController.items,
            state: uploadController.state,
            emptyActionTitle: nil,
            onEmptyAction: nil,
            errorActionTitle: nil,
            onErrorAction: nil,
            acceptedContentTypes: importController.acceptedContentTypes,
            isTargeted: Binding(
                get: { importController.isTargeted },
                set: { importController.setTargeted($0) }
            ),
            onDropURLs: { urls in
                let accepted = importController.handleDroppedURLs(urls)
                uploadController.enqueue(urls: accepted)
            },
            pickerTitle: pickerTitle,
            onPick: {
                Task {
                    let accepted = await importController.importFromPicker(
                        allowsMultipleSelection: allowsMultipleSelection
                    )
                    uploadController.enqueue(urls: accepted)
                }
            },
            pasteActionTitle: pasteActionTitle,
            onPaste: {
                let accepted = importController.importFromPasteboard()
                uploadController.enqueue(urls: accepted)
            },
            validationSummary: importController.validationSummary ?? uploadController.validationSummary,
            onRetry: nil,
            onCancel: { item in uploadController.cancel(id: item.id) },
            onRemove: { item in uploadController.remove(id: item.id) },
            onRetryFailed: nil,
            onRemoveCompleted: { uploadController.removeCompleted() },
            onCancelAll: uploadController.isUploading ? { uploadController.cancelAll() } : nil
        )
    }

    public var body: some View {
        PanelSurface(environment: environment, title: title, subtitle: subtitle) {
            AsyncContentRenderer(
                environment: environment,
                state: state,
                emptyActionTitle: emptyActionTitle,
                onEmptyAction: onEmptyAction,
                errorActionTitle: errorActionTitle,
                onErrorAction: onErrorAction
            ) {
                FileDropZone(
                    environment: environment,
                    title: dropTitle,
                    detail: dropDetail,
                    validationMessage: validationSummary,
                    state: .ready,
                    acceptedContentTypes: acceptedContentTypes,
                    isTargeted: isTargeted,
                    onDropURLs: handleDroppedURLs,
                    actionTitle: pickerTitle,
                    action: onPick,
                    secondaryActionTitle: pasteActionTitle,
                    secondaryAction: onPaste
                )

                if !items.isEmpty {
                    FileTokenGroup(
                        environment: environment,
                        items: items,
                        summaryMessage: validationSummary,
                        onRetry: onRetry,
                        onCancel: onCancel,
                        onRemove: onRemove,
                        onRetryFailed: onRetryFailed,
                        onRemoveCompleted: onRemoveCompleted,
                        onCancelAll: onCancelAll
                    )
                }

                if let liveAnnouncement, !liveAnnouncement.isEmpty {
                    AccessibilityAnnouncementRegion(message: liveAnnouncement)
                }
            }
        }
        .onChange(of: items) { oldValue, newValue in
            handleItemChange(from: oldValue, to: newValue)
        }
    }

    private func handleDroppedURLs(_ urls: [URL]) {
        onDropURLs?(urls)
    }

    private func handleItemChange(from oldValue: [FileUploadItem], to newValue: [FileUploadItem]) {
        let previousByID = Dictionary(uniqueKeysWithValues: oldValue.map { ($0.id, $0) })
        let currentByID = Dictionary(uniqueKeysWithValues: newValue.map { ($0.id, $0) })

        for item in newValue where previousByID[item.id] == nil {
            announce("\(item.title) added.")
        }

        for item in oldValue where currentByID[item.id] == nil {
            announce("\(item.title) removed.")
        }

        for item in newValue {
            guard let previous = previousByID[item.id], previous.status != item.status else { continue }

            switch item.status {
            case .success:
                announce("\(item.title) uploaded.")
            case .error:
                announce("\(item.title) failed to upload.")
            default:
                continue
            }
        }
    }

    private func announce(_ message: String) {
        liveAnnouncement = message
        postAccessibilityAnnouncement(message)
    }
}
