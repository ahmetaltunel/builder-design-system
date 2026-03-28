import SwiftUI
import BuilderFoundation

public struct ProgressBar: View {
    public let environment: DesignSystemEnvironment
    public let value: Double
    public let label: String?
    public let showsValue: Bool

    public init(
        environment: DesignSystemEnvironment,
        value: Double,
        label: String? = nil,
        showsValue: Bool = true
    ) {
        self.environment = environment
        self.value = min(max(value, 0), 1)
        self.label = label
        self.showsValue = showsValue
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if label != nil || showsValue {
                HStack {
                    if let label {
                        Text(label)
                            .font(environment.theme.typography(.label).font)
                            .foregroundStyle(environment.theme.color(.textSecondary))
                    }

                    Spacer()

                    if showsValue {
                        Text("\(Int(value * 100))%")
                            .font(environment.theme.typography(.caption).font)
                            .foregroundStyle(environment.theme.color(.textMuted))
                    }
                }
            }

            RoundedRectangle(cornerRadius: 999, style: .continuous)
                .fill(environment.theme.color(.inputSurface))
                .frame(height: 10)
                .overlay(alignment: .leading) {
                    GeometryReader { proxy in
                        RoundedRectangle(cornerRadius: 999, style: .continuous)
                            .fill(environment.theme.color(.accentPrimary))
                            .frame(width: max(proxy.size.width * value, value > 0 ? 10 : 0))
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 999, style: .continuous)
                        .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
                )
        }
    }
}
