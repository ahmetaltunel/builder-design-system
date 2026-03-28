import SwiftUI
import BuilderFoundation

public struct PopoverSurface<Content: View>: View {
    public let environment: DesignSystemEnvironment
    public let title: String?
    public let content: Content

    public init(
        environment: DesignSystemEnvironment,
        title: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.environment = environment
        self.title = title
        self.content = content()
    }

    public var body: some View {
        let material = environment.theme.material(.popover)

        VStack(alignment: .leading, spacing: 12) {
            if let title {
                Text(title)
                    .font(environment.theme.typography(.bodyStrong).font)
                    .foregroundStyle(environment.theme.color(.textPrimary))
            }

            content
        }
        .padding(environment.theme.spacing(.md, density: environment.density))
        .background(
            RoundedRectangle(cornerRadius: environment.theme.radius(material.radius), style: .continuous)
                .fill(material.fill.opacity(material.fillOpacity))
                .shadow(
                    color: environment.theme.elevation(material.elevation).color,
                    radius: environment.theme.elevation(material.elevation).radius,
                    x: environment.theme.elevation(material.elevation).x,
                    y: environment.theme.elevation(material.elevation).y
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: environment.theme.radius(material.radius), style: .continuous)
                .stroke(material.border, lineWidth: material.borderWidth)
        )
    }
}
