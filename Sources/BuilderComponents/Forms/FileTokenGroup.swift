import SwiftUI
import BuilderFoundation

public struct FileTokenGroup: View {
    public let environment: DesignSystemEnvironment
    public let items: [FileUploadItem]
    public let onRemove: ((FileUploadItem) -> Void)?

    public init(
        environment: DesignSystemEnvironment,
        items: [FileUploadItem],
        onRemove: ((FileUploadItem) -> Void)? = nil
    ) {
        self.environment = environment
        self.items = items
        self.onRemove = onRemove
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(items) { item in
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: "doc")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(environment.theme.color(.accentPrimary))
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
                        label: statusLabel(for: item.status),
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
            }
        }
    }

    private func statusLabel(for status: FileUploadItem.Status) -> String {
        switch status {
        case .ready:
            "Ready"
        case .uploading:
            "Uploading"
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
}
