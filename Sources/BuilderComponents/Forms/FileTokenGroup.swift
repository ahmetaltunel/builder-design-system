import SwiftUI
import BuilderFoundation

public struct FileTokenGroup: View {
    public let environment: DesignSystemEnvironment
    public let items: [FileUploadItem]
    public let onRetry: ((FileUploadItem) -> Void)?
    public let onRemove: ((FileUploadItem) -> Void)?

    public init(
        environment: DesignSystemEnvironment,
        items: [FileUploadItem],
        onRetry: ((FileUploadItem) -> Void)? = nil,
        onRemove: ((FileUploadItem) -> Void)? = nil
    ) {
        self.environment = environment
        self.items = items
        self.onRetry = onRetry
        self.onRemove = onRemove
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(items) { item in
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: item.symbol)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(iconColor(for: item.status))
                            .frame(width: 18)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.title)
                                .font(environment.theme.typography(.bodyStrong).font)
                                .foregroundStyle(environment.theme.color(.textPrimary))

                            if let detail = item.detail {
                                Text(detail)
                                    .font(environment.theme.typography(.caption).font)
                                    .foregroundStyle(environment.theme.color(.textSecondary))
                            }
                        }

                        Spacer(minLength: 0)

                        StatusBadge(
                            environment: environment,
                            label: statusLabel(for: item),
                            color: statusColor(for: item.status)
                        )

                        if let onRemove {
                            Button {
                                onRemove(item)
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundStyle(environment.theme.color(.textSecondary))
                                    .frame(width: 22, height: 22)
                                    .background(
                                        Circle()
                                            .fill(environment.theme.color(.hoverSurface))
                                    )
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("Remove \(item.title)")
                        }
                    }

                    if item.status == .uploading {
                        if let progress = item.progress {
                            ProgressBar(
                                environment: environment,
                                value: progress,
                                label: item.message ?? "Uploading",
                                showsValue: true
                            )
                        } else {
                            LoadingBar(
                                environment: environment,
                                label: item.message ?? "Uploading",
                                detail: "Upload progress is not yet known.",
                                height: 8
                            )
                        }
                    } else if let message = item.message {
                        Text(message)
                            .font(environment.theme.typography(.caption).font)
                            .foregroundStyle(messageColor(for: item.status))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if item.canRetry, let onRetry, item.status == .error || item.status == .warning {
                        HStack(spacing: 8) {
                            SystemButton(
                                environment: environment,
                                title: "Retry",
                                tone: .secondary,
                                size: .small,
                                leadingSymbol: "arrow.clockwise"
                            ) {
                                onRetry(item)
                            }

                            Spacer(minLength: 0)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                        .fill(environment.theme.color(.inputSurface))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                        .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
                )
                .accessibilityElement(children: .contain)
                .accessibilityLabel(item.title)
                .accessibilityHint(accessibilityHint(for: item.status))
            }
        }
    }

    private func statusLabel(for item: FileUploadItem) -> String {
        switch item.status {
        case .ready:
            "Ready"
        case .uploading:
            if let progress = item.progress {
                "\(Int(progress * 100))%"
            } else {
                "Uploading"
            }
        case .success:
            "Uploaded"
        case .warning:
            "Review"
        case .error:
            "Error"
        }
    }

    private func statusColor(for status: FileUploadItem.Status) -> Color {
        switch status {
        case .ready:
            environment.theme.color(.textSecondary)
        case .uploading:
            environment.theme.color(.info)
        case .success:
            environment.theme.color(.success)
        case .warning:
            environment.theme.color(.warning)
        case .error:
            environment.theme.color(.danger)
        }
    }

    private func iconColor(for status: FileUploadItem.Status) -> Color {
        switch status {
        case .success:
            environment.theme.color(.success)
        case .warning:
            environment.theme.color(.warning)
        case .error:
            environment.theme.color(.danger)
        case .uploading:
            environment.theme.color(.info)
        case .ready:
            environment.theme.color(.accentPrimary)
        }
    }

    private func messageColor(for status: FileUploadItem.Status) -> Color {
        switch status {
        case .warning:
            environment.theme.color(.warning)
        case .error:
            environment.theme.color(.danger)
        case .success:
            environment.theme.color(.success)
        case .uploading, .ready:
            environment.theme.color(.textSecondary)
        }
    }

    private func accessibilityHint(for status: FileUploadItem.Status) -> String {
        switch status {
        case .ready:
            "Ready to upload"
        case .uploading:
            "Upload in progress"
        case .success:
            "Upload completed"
        case .warning:
            "Needs review"
        case .error:
            "Upload failed"
        }
    }
}
