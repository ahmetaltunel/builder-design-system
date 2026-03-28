import SwiftUI
import BuilderFoundation

public struct ContextPanel<Content: View>: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let content: Content

    public init(environment: DesignSystemEnvironment, title: String, @ViewBuilder content: () -> Content) {
        self.environment = environment
        self.title = title
        self.content = content()
    }

    public var body: some View {
        PanelSurface(environment: environment, title: title) {
            content
        }
    }
}
