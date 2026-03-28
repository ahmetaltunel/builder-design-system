import SwiftUI
import BuilderFoundation

public struct SettingsGroup<Content: View>: View {
    public let environment: DesignSystemEnvironment
    public let content: Content

    public init(environment: DesignSystemEnvironment, @ViewBuilder content: () -> Content) {
        self.environment = environment
        self.content = content()
    }

    public var body: some View {
        let material = environment.theme.material(.panel)
        VStack(spacing: 0) {
            content
        }
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
