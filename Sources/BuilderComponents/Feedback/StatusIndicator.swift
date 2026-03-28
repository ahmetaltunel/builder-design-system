import SwiftUI
import BuilderFoundation

public struct StatusIndicator: View {
    public enum Tone {
        case neutral
        case info
        case success
        case warning
        case danger
    }

    public let environment: DesignSystemEnvironment
    public let label: String
    public let detail: String?
    public let tone: Tone

    public init(
        environment: DesignSystemEnvironment,
        label: String,
        detail: String? = nil,
        tone: Tone = .neutral
    ) {
        self.environment = environment
        self.label = label
        self.detail = detail
        self.tone = tone
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(indicatorColor)
                .frame(width: 10, height: 10)
                .padding(.top, detail == nil ? 4 : 5)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(environment.theme.typography(.bodyStrong).font)
                    .foregroundStyle(environment.theme.color(.textPrimary))

                if let detail {
                    Text(detail)
                        .font(environment.theme.typography(.helper).font)
                        .foregroundStyle(environment.theme.color(.textSecondary))
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
        .accessibilityHint(detail ?? accessibilityTone)
    }

    private var indicatorColor: Color {
        switch tone {
        case .neutral:
            environment.theme.color(.textSecondary)
        case .info:
            environment.theme.color(.info)
        case .success:
            environment.theme.color(.success)
        case .warning:
            environment.theme.color(.warning)
        case .danger:
            environment.theme.color(.danger)
        }
    }

    private var accessibilityTone: String {
        switch tone {
        case .neutral:
            "Neutral status"
        case .info:
            "Informational status"
        case .success:
            "Success status"
        case .warning:
            "Warning status"
        case .danger:
            "Error status"
        }
    }
}
