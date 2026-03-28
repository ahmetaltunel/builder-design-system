import SwiftUI
import BuilderFoundation

public struct Box<Content: View>: View {
    public let environment: DesignSystemEnvironment
    public let content: Content

    public init(environment: DesignSystemEnvironment, @ViewBuilder content: () -> Content) {
        self.environment = environment
        self.content = content()
    }

    public var body: some View {
        ContainerBox(environment: environment, content: { content })
    }
}
