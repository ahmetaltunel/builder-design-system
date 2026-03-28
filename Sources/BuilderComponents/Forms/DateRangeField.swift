import SwiftUI
import BuilderFoundation

public struct DateRangeField: View {
    public let environment: DesignSystemEnvironment
    @Binding public var startDate: Date
    @Binding public var endDate: Date

    public init(environment: DesignSystemEnvironment, startDate: Binding<Date>, endDate: Binding<Date>) {
        self.environment = environment
        self._startDate = startDate
        self._endDate = endDate
    }

    public var body: some View {
        HStack(spacing: 12) {
            DateField(environment: environment, value: $startDate)
            DateField(environment: environment, value: $endDate)
        }
    }
}
