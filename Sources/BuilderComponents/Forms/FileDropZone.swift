import SwiftUI
import BuilderFoundation

public struct FileDropZone: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let detail: String

    public init(environment: DesignSystemEnvironment, title: String = "Drop files", detail: String = "Drag files here or use the action button to select them.") {
        self.environment = environment
        self.title = title
        self.detail = detail
    }

    public var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(environment.theme.color(.accentPrimary))
            Text(title)
                .font(environment.theme.typography(.bodyStrong).font)
                .foregroundStyle(environment.theme.color(.textPrimary))
            Text(detail)
                .font(environment.theme.typography(.caption).font)
                .foregroundStyle(environment.theme.color(.textSecondary))
                .multilineTextAlignment(.center)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                .fill(environment.theme.color(.groupedSurface))
        )
        .overlay(
            RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [6, 5]))
                .foregroundStyle(environment.theme.color(.subtleBorder))
        )
    }
}
