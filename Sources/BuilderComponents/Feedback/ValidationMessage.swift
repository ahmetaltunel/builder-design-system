import SwiftUI
import BuilderFoundation

public struct ValidationMessage: View {
    public let environment: DesignSystemEnvironment
    public let status: FieldStatus
    public let message: String

    public init(environment: DesignSystemEnvironment, status: FieldStatus, message: String) {
        self.environment = environment
        self.status = status
        self.message = message
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: symbol)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(color)
                .frame(width: 14, alignment: .center)

            Text(message)
                .font(environment.theme.typography(.caption).font)
                .foregroundStyle(color)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(message)
        .accessibilityHint(accessibilityHint)
    }

    private var color: Color {
        switch status {
        case .normal:
            environment.theme.color(.textSecondary)
        case .success:
            environment.theme.color(.success)
        case .warning:
            environment.theme.color(.warning)
        case .error:
            environment.theme.color(.danger)
        }
    }

    private var symbol: String {
        switch status {
        case .normal:
            "info.circle"
        case .success:
            "checkmark.circle"
        case .warning:
            "exclamationmark.triangle"
        case .error:
            "xmark.octagon"
        }
    }

    private var accessibilityHint: String {
        switch status {
        case .normal: "Supporting guidance"
        case .success: "Success message"
        case .warning: "Warning message"
        case .error: "Error message"
        }
    }
}
