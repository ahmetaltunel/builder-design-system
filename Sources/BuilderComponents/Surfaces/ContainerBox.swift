import SwiftUI
import BuilderFoundation

public struct ContainerBox<Content: View>: View {
    public let environment: DesignSystemEnvironment
    public let inset: Bool
    public let content: Content

    public init(
        environment: DesignSystemEnvironment,
        inset: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.environment = environment
        self.inset = inset
        self.content = content()
    }

    public var body: some View {
        let fill = inset ? environment.theme.color(.insetSurface) : environment.theme.color(.groupedSurface)

        content
            .padding(environment.theme.spacing(.panelPadding, density: environment.density))
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                    .fill(fill)
            )
            .overlay(
                RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                    .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
            )
    }
}
