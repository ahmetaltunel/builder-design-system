import SwiftUI
import BuilderFoundation

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
    public let pickerTitle: String
    public let onPick: () -> Void
    public let onRemove: ((FileUploadItem) -> Void)?

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
        pickerTitle: String = "Browse files",
        onPick: @escaping () -> Void,
        onRemove: ((FileUploadItem) -> Void)? = nil
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
        self.pickerTitle = pickerTitle
        self.onPick = onPick
        self.onRemove = onRemove
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
            pickerTitle: pickerTitle,
            onPick: onPick,
            onRemove: onRemove
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
                    actionTitle: pickerTitle,
                    action: onPick
                )

                if !items.isEmpty {
                    FileTokenGroup(environment: environment, items: items, onRemove: onRemove)
                }
            }
        }
    }
}
