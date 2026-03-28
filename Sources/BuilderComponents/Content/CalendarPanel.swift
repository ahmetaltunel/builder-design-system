import SwiftUI
import BuilderFoundation

public struct CalendarPanel: View {
    public let environment: DesignSystemEnvironment
    @Binding public var date: Date

    public init(environment: DesignSystemEnvironment, date: Binding<Date>) {
        self.environment = environment
        self._date = date
    }

    public var body: some View {
        DatePicker("Calendar", selection: $date, displayedComponents: .date)
            .datePickerStyle(.graphical)
            .padding(environment.theme.spacing(.panelPadding, density: environment.density))
            .background(
                RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                    .fill(environment.theme.color(.groupedSurface))
            )
            .overlay(
                RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                    .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
            )
    }
}
