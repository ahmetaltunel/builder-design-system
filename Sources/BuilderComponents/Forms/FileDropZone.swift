import Foundation
import SwiftUI
import UniformTypeIdentifiers
import BuilderFoundation
import BuilderBehaviors

public struct FileDropZone: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let detail: String
    public let validationMessage: String?
    public let state: AsyncContentState
    public let acceptedContentTypes: [UTType]
    public let isTargeted: Binding<Bool>?
    public let onDropURLs: (([URL]) -> Void)?
    public let actionTitle: String?
    public let action: (() -> Void)?
    public let secondaryActionTitle: String?
    public let secondaryAction: (() -> Void)?

    @State private var localIsTargeted = false
    @State private var liveAnnouncement: String?

    public init(
        environment: DesignSystemEnvironment,
        title: String = "Drop files",
        detail: String = "Drag files here or use the action button to select them.",
        validationMessage: String? = nil,
        state: AsyncContentState = .ready,
        acceptedContentTypes: [UTType] = [.fileURL],
        isTargeted: Binding<Bool>? = nil,
        onDropURLs: (([URL]) -> Void)? = nil,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil,
        secondaryActionTitle: String? = nil,
        secondaryAction: (() -> Void)? = nil
    ) {
        self.environment = environment
        self.title = title
        self.detail = detail
        self.validationMessage = validationMessage
        self.state = state
        self.acceptedContentTypes = acceptedContentTypes
        self.isTargeted = isTargeted
        self.onDropURLs = onDropURLs
        self.actionTitle = actionTitle
        self.action = action
        self.secondaryActionTitle = secondaryActionTitle
        self.secondaryAction = secondaryAction
    }

    public init(
        environment: DesignSystemEnvironment,
        title: String = "Drop files",
        detail: String = "Drag files here or use the action button to select them.",
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.init(
            environment: environment,
            title: title,
            detail: detail,
            validationMessage: nil,
            state: .ready,
            acceptedContentTypes: [.fileURL],
            isTargeted: nil,
            onDropURLs: nil,
            actionTitle: actionTitle,
            action: action,
            secondaryActionTitle: nil,
            secondaryAction: nil
        )
    }

    public init(
        environment: DesignSystemEnvironment,
        title: String = "Drop files",
        subtitle: String,
        validationMessage: String? = nil,
        state: AsyncContentState = .ready,
        acceptedContentTypes: [UTType] = [.fileURL],
        isTargeted: Binding<Bool>? = nil,
        onDropURLs: (([URL]) -> Void)? = nil,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil,
        secondaryActionTitle: String? = nil,
        secondaryAction: (() -> Void)? = nil
    ) {
        self.init(
            environment: environment,
            title: title,
            detail: subtitle,
            validationMessage: validationMessage,
            state: state,
            acceptedContentTypes: acceptedContentTypes,
            isTargeted: isTargeted,
            onDropURLs: onDropURLs,
            actionTitle: actionTitle,
            action: action,
            secondaryActionTitle: secondaryActionTitle,
            secondaryAction: secondaryAction
        )
    }

    public init(
        environment: DesignSystemEnvironment,
        title: String = "Drop files",
        subtitle: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.init(
            environment: environment,
            title: title,
            detail: subtitle,
            validationMessage: nil,
            state: .ready,
            acceptedContentTypes: [.fileURL],
            isTargeted: nil,
            onDropURLs: nil,
            actionTitle: actionTitle,
            action: action,
            secondaryActionTitle: nil,
            secondaryAction: nil
        )
    }

    public init(
        environment: DesignSystemEnvironment,
        title: String = "Drop files",
        detail: String = "Drag files here or use the action button to select them.",
        controller: FileImportController,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil,
        secondaryActionTitle: String? = nil,
        secondaryAction: (() -> Void)? = nil
    ) {
        self.init(
            environment: environment,
            title: title,
            detail: detail,
            validationMessage: controller.validationSummary,
            state: controller.state,
            acceptedContentTypes: controller.acceptedContentTypes,
            isTargeted: Binding(
                get: { controller.isTargeted },
                set: { controller.setTargeted($0) }
            ),
            onDropURLs: { urls in
                _ = controller.handleDroppedURLs(urls)
            },
            actionTitle: actionTitle,
            action: action,
            secondaryActionTitle: secondaryActionTitle,
            secondaryAction: secondaryAction
        )
    }

    public var body: some View {
        AsyncContentRenderer(environment: environment, state: state) {
            VStack(spacing: 10) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(resolvedIsTargeted.wrappedValue ? environment.theme.color(.textOnAccent) : environment.theme.color(.accentPrimary))
                Text(title)
                    .font(environment.theme.typography(.bodyStrong).font)
                    .foregroundStyle(environment.theme.color(.textPrimary))
                Text(detail)
                    .font(environment.theme.typography(.caption).font)
                    .foregroundStyle(environment.theme.color(.textSecondary))
                    .multilineTextAlignment(.center)

                if let validationMessage {
                    ValidationMessage(
                        environment: environment,
                        status: .warning,
                        message: validationMessage
                    )
                }

                if actionTitle != nil || secondaryActionTitle != nil {
                    HStack(spacing: 8) {
                        if let actionTitle, let action {
                            FilePickerButton(environment: environment, title: actionTitle, action: action)
                        }

                        if let secondaryActionTitle, let secondaryAction {
                            SystemButton(
                                environment: environment,
                                title: secondaryActionTitle,
                                tone: .secondary,
                                size: .small,
                                leadingSymbol: "doc.on.clipboard",
                                action: secondaryAction
                            )
                        }
                    }
                }

                if let liveAnnouncement, !liveAnnouncement.isEmpty {
                    AccessibilityAnnouncementRegion(message: liveAnnouncement)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                    .fill(resolvedIsTargeted.wrappedValue ? environment.theme.color(.accentPrimary).opacity(environment.mode == .dark ? 0.2 : 0.12) : environment.theme.color(.groupedSurface))
            )
            .overlay(
                RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                    .stroke(style: StrokeStyle(lineWidth: resolvedIsTargeted.wrappedValue ? 2 : 1, dash: resolvedIsTargeted.wrappedValue ? [] : [6, 5]))
                    .foregroundStyle(resolvedIsTargeted.wrappedValue ? environment.theme.color(.accentPrimary) : environment.theme.color(.subtleBorder))
            )
            .onDrop(of: resolvedDropTypes, isTargeted: resolvedIsTargeted, perform: handleDrop(providers:))
            .accessibilityElement(children: .contain)
            .accessibilityLabel(title)
            .accessibilityHint("Drop files here or use the browse action.")
        }
    }

    private var resolvedDropTypes: [UTType] {
        let requested = acceptedContentTypes.isEmpty ? [UTType.fileURL] : acceptedContentTypes
        if requested.contains(.fileURL) {
            return requested
        }
        return requested + [.fileURL]
    }

    private var resolvedIsTargeted: Binding<Bool> {
        isTargeted ?? $localIsTargeted
    }

    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        guard !providers.isEmpty else { return false }

        let candidateProviders = providers.filter {
            $0.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier)
        }

        guard !candidateProviders.isEmpty else { return false }

        let group = DispatchGroup()
        let collector = URLCollector()

        for provider in candidateProviders {
            group.enter()
            provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, _ in
                defer { group.leave() }

                guard let url = resolvedURL(from: item) else { return }
                collector.append(url)
            }
        }

        group.notify(queue: .main) {
            let resolvedURLs = unique(collector.values).filter { url in
                BuilderBehaviors.matchesAcceptedContentType(url, acceptedContentTypes: acceptedContentTypes)
            }
            guard !resolvedURLs.isEmpty else { return }

            onDropURLs?(resolvedURLs)

            let announcement = resolvedURLs.count == 1
                ? "\(resolvedURLs[0].lastPathComponent) added."
                : "\(resolvedURLs.count) files added."
            liveAnnouncement = announcement
            postAccessibilityAnnouncement(announcement)
        }

        return true
    }
}

private final class URLCollector: @unchecked Sendable {
    private let lock = NSLock()
    private var urls: [URL] = []

    func append(_ url: URL) {
        lock.lock()
        urls.append(url)
        lock.unlock()
    }

    var values: [URL] {
        lock.lock()
        defer { lock.unlock() }
        return urls
    }
}

private func resolvedURL(from item: NSSecureCoding?) -> URL? {
    if let url = item as? URL {
        return url
    }

    if let data = item as? Data {
        return URL(dataRepresentation: data, relativeTo: nil)
    }

    if let string = item as? String {
        return URL(string: string)
    }

    return nil
}

func matchesAcceptedContentType(_ url: URL, acceptedContentTypes: [UTType]) -> Bool {
    let constrainedTypes = acceptedContentTypes.filter { $0 != .fileURL }
    guard !constrainedTypes.isEmpty else { return true }

    let resolvedType = fileContentType(for: url)
    return constrainedTypes.contains { acceptedType in
        resolvedType?.conforms(to: acceptedType) == true
    }
}

private func fileContentType(for url: URL) -> UTType? {
    if let resolvedType = try? url.resourceValues(forKeys: [.contentTypeKey]).contentType {
        return resolvedType
    }

    return UTType(filenameExtension: url.pathExtension)
}

private func unique(_ urls: [URL]) -> [URL] {
    var seen: Set<URL> = []
    var uniqueURLs: [URL] = []

    for url in urls where !seen.contains(url) {
        seen.insert(url)
        uniqueURLs.append(url)
    }

    return uniqueURLs
}
