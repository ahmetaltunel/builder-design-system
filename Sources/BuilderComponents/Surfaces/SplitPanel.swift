import SwiftUI
import BuilderFoundation

public struct SplitPanel<Primary: View, Secondary: View>: View {
    public let environment: DesignSystemEnvironment
    public let showsSecondary: Bool
    public let secondaryWidth: CGFloat
    public let primary: Primary
    public let secondary: Secondary

    public init(
        environment: DesignSystemEnvironment,
        showsSecondary: Bool = true,
        secondaryWidth: CGFloat = 320,
        @ViewBuilder primary: () -> Primary,
        @ViewBuilder secondary: () -> Secondary
    ) {
        self.environment = environment
        self.showsSecondary = showsSecondary
        self.secondaryWidth = secondaryWidth
        self.primary = primary()
        self.secondary = secondary()
    }

    public var body: some View {
        HStack(spacing: 0) {
            primary
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            if showsSecondary {
                Rectangle()
                    .fill(environment.theme.color(.subtleBorder))
                    .frame(width: 1)

                secondary
                    .frame(width: secondaryWidth)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
                    .background(environment.theme.color(.groupedSurface))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
        )
    }
}
