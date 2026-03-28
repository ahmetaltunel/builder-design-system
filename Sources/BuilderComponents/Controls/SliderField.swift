import SwiftUI
import BuilderFoundation

public struct SliderField: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let range: ClosedRange<Double>
    @Binding public var value: Double

    public init(environment: DesignSystemEnvironment, title: String, value: Binding<Double>, in range: ClosedRange<Double>) {
        self.environment = environment
        self.title = title
        self._value = value
        self.range = range
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(environment.theme.typography(.label).font)
                    .foregroundStyle(environment.theme.color(.textSecondary))
                Spacer()
                Text("\(Int(value))")
                    .font(environment.theme.typography(.caption).font)
                    .foregroundStyle(environment.theme.color(.textMuted))
            }

            Slider(value: $value, in: range)
                .tint(environment.theme.color(.accentPrimary))
                .accessibilityLabel(title)
                .accessibilityValue("\(Int(value))")
        }
    }
}
