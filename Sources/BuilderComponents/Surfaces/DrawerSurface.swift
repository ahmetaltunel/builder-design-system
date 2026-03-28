import SwiftUI
import BuilderFoundation

public struct DrawerSurface<Content: View>: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let subtitle: String?
    public let width: CGFloat
    public let content: Content

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        width: CGFloat = 320,
        @ViewBuilder content: () -> Content
    ) {
        self.environment = environment
        self.title = title
        self.subtitle = subtitle
        self.width = width
        self.content = content()
    }

    public var body: some View {
        let material = environment.theme.material(.drawer)

        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(environment.theme.typography(.sectionTitle).font)
                .foregroundStyle(environment.theme.color(.textPrimary))

            if let subtitle {
                Text(subtitle)
                    .font(environment.theme.typography(.body).font)
                    .foregroundStyle(environment.theme.color(.textSecondary))
            }

            content
        }
        .padding(environment.theme.spacing(.panelPadding, density: environment.density))
        .frame(width: width, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: environment.theme.radius(material.radius), style: .continuous)
                .fill(material.fill.opacity(material.fillOpacity))
        )
        .overlay(
            RoundedRectangle(cornerRadius: environment.theme.radius(material.radius), style: .continuous)
                .stroke(material.border, lineWidth: material.borderWidth)
        )
    }
}
