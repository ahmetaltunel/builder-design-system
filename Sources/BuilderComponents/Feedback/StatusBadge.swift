import SwiftUI
import BuilderFoundation

public struct StatusBadge: View {
    public let environment: DesignSystemEnvironment
    public let label: String
    public let color: Color

    public init(environment: DesignSystemEnvironment, label: String, color: Color) {
        self.environment = environment
        self.label = label
        self.color = color
    }

    public var body: some View {
        Text(label)
            .font(environment.theme.typography(.caption).font.weight(.semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule(style: .continuous)
                    .fill(color.opacity(environment.mode == .dark ? 0.16 : 0.12))
            )
    }
}
