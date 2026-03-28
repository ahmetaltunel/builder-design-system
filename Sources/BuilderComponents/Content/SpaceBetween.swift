import SwiftUI
import BuilderFoundation

public struct SpaceBetween<Content: View>: View {
    public let environment: DesignSystemEnvironment
    public let spacing: CGFloat?
    public let content: Content

    public init(environment: DesignSystemEnvironment, spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.environment = environment
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: spacing ?? environment.theme.spacing(.md, density: environment.density)) {
            content
        }
    }
}
