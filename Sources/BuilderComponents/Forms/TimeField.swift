import SwiftUI
import BuilderFoundation

public struct TimeField: View {
    public let environment: DesignSystemEnvironment
    @Binding public var value: Date

    public init(environment: DesignSystemEnvironment, value: Binding<Date>) {
        self.environment = environment
        self._value = value
    }

    public var body: some View {
        DatePicker("", selection: $value, displayedComponents: .hourAndMinute)
            .labelsHidden()
            .padding(.horizontal, 12)
            .frame(height: 38)
            .frame(maxWidth: .infinity, alignment: .leading)
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
