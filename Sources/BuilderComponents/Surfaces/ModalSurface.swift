import SwiftUI
import BuilderFoundation

public struct ModalSurface<Content: View, Footer: View>: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let subtitle: String?
    public let width: CGFloat
    public let content: Content
    public let footer: Footer

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        width: CGFloat = 440,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.environment = environment
        self.title = title
        self.subtitle = subtitle
        self.width = width
        self.content = content()
        self.footer = footer()
    }

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        width: CGFloat = 440,
        @ViewBuilder content: () -> Content
    ) where Footer == EmptyView {
        self.init(environment: environment, title: title, subtitle: subtitle, width: width, content: content) {
            EmptyView()
        }
    }

    public var body: some View {
        let material = environment.theme.material(.modal)

        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(environment.theme.typography(.sectionTitle).font)
                    .foregroundStyle(environment.theme.color(.textPrimary))

                if let subtitle {
                    Text(subtitle)
                        .font(environment.theme.typography(.body).font)
                        .foregroundStyle(environment.theme.color(.textSecondary))
                }
            }

            content

            footer
        }
        .padding(environment.theme.spacing(.panelPadding, density: environment.density))
        .frame(maxWidth: width, alignment: .leading)
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
