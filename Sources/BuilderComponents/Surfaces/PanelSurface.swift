import SwiftUI
import BuilderFoundation

public struct PanelSurface<Content: View>: View {
    public let environment: DesignSystemEnvironment
    public let title: String?
    public let subtitle: String?
    public let elevation: ElevationToken
    public let content: Content

    public init(
        environment: DesignSystemEnvironment,
        title: String? = nil,
        subtitle: String? = nil,
        elevation: ElevationToken = .flat,
        @ViewBuilder content: () -> Content
    ) {
        self.environment = environment
        self.title = title
        self.subtitle = subtitle
        self.elevation = elevation
        self.content = content()
    }

    public var body: some View {
        let material = environment.theme.material(.grouped)
        let shadow = environment.theme.elevation(elevation)

        VStack(alignment: .leading, spacing: environment.theme.spacing(.sm, density: environment.density)) {
            if title != nil || subtitle != nil {
                VStack(alignment: .leading, spacing: 4) {
                    if let title {
                        Text(title)
                            .font(environment.theme.typography(.sectionTitle).font)
                            .foregroundStyle(environment.theme.color(.textPrimary))
                    }

                    if let subtitle {
                        Text(subtitle)
                            .font(environment.theme.typography(.body).font)
                            .foregroundStyle(environment.theme.color(.textSecondary))
                    }
                }
            }

            content
        }
        .padding(environment.theme.spacing(.panelPadding, density: environment.density))
        .background(
            RoundedRectangle(cornerRadius: environment.theme.radius(material.radius), style: .continuous)
                .fill(material.fill.opacity(material.fillOpacity))
                .shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
        )
        .overlay(
            RoundedRectangle(cornerRadius: environment.theme.radius(material.radius), style: .continuous)
                .stroke(material.border, lineWidth: material.borderWidth)
        )
    }
}
