import SwiftUI
import BuilderFoundation

public struct LoadingSpinner: View {
    public let environment: DesignSystemEnvironment
    public let label: String?
    public let controlSize: ControlSize

    public init(
        environment: DesignSystemEnvironment,
        label: String? = nil,
        controlSize: ControlSize = .regular
    ) {
        self.environment = environment
        self.label = label
        self.controlSize = controlSize
    }

    public var body: some View {
        HStack(spacing: 10) {
            ProgressView()
                .controlSize(controlSize)
                .tint(environment.theme.color(.accentPrimary))

            if let label {
                Text(label)
                    .font(environment.theme.typography(.body).font)
                    .foregroundStyle(environment.theme.color(.textSecondary))
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label ?? "Loading")
        .accessibilityHint("Activity in progress")
    }
}
