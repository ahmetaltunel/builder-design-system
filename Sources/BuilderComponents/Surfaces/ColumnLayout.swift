import SwiftUI
import BuilderFoundation

public struct ColumnLayout<Primary: View, Secondary: View>: View {
    public let environment: DesignSystemEnvironment
    public let secondaryWidth: CGFloat
    public let primary: Primary
    public let secondary: Secondary

    public init(
        environment: DesignSystemEnvironment,
        secondaryWidth: CGFloat = 280,
        @ViewBuilder primary: () -> Primary,
        @ViewBuilder secondary: () -> Secondary
    ) {
        self.environment = environment
        self.secondaryWidth = secondaryWidth
        self.primary = primary()
        self.secondary = secondary()
    }

    public var body: some View {
        HStack(alignment: .top, spacing: environment.theme.spacing(.lg, density: environment.density)) {
            primary
                .frame(maxWidth: .infinity, alignment: .topLeading)

            secondary
                .frame(width: secondaryWidth, alignment: .topLeading)
        }
    }
}
