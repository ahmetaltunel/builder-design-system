import SwiftUI
import BuilderFoundation

public struct AppLayoutToolbar<Content: View>: View {
    public let environment: DesignSystemEnvironment
    public let content: Content

    public init(environment: DesignSystemEnvironment, @ViewBuilder content: () -> Content) {
        self.environment = environment
        self.content = content()
    }

    public var body: some View {
        let material = environment.theme.material(.toolbar)
        HStack(spacing: 12) {
            content
        }
        .padding(.horizontal, environment.theme.spacing(.panelPadding, density: environment.density))
        .frame(height: environment.theme.spacing(.toolbarHeight, density: environment.density))
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(material.fill.opacity(material.fillOpacity))
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(material.border)
                .frame(height: material.borderWidth)
        }
    }
}
