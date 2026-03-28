import SwiftUI
import BuilderFoundation

public struct TokenBadge: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let tint: Color?

    public init(environment: DesignSystemEnvironment, title: String, tint: Color? = nil) {
        self.environment = environment
        self.title = title
        self.tint = tint
    }

    public var body: some View {
        HStack(spacing: 8) {
            if let tint {
                Circle()
                    .fill(tint)
                    .frame(width: 8, height: 8)
            }

            Text(title)
                .font(environment.theme.typography(.caption).font)
                .foregroundStyle(environment.theme.color(.textSecondary))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule(style: .continuous)
                .fill(environment.theme.color(.inputSurface))
        )
        .overlay(
            Capsule(style: .continuous)
                .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
        )
    }
}
