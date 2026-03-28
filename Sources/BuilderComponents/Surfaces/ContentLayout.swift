import SwiftUI
import BuilderFoundation

public struct ContentLayout<Header: View, Content: View>: View {
    public let environment: DesignSystemEnvironment
    public let maxWidth: CGFloat?
    public let header: Header
    public let content: Content

    public init(
        environment: DesignSystemEnvironment,
        maxWidth: CGFloat? = 980,
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content
    ) {
        self.environment = environment
        self.maxWidth = maxWidth
        self.header = header()
        self.content = content()
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: environment.theme.spacing(.xl, density: environment.density)) {
                header
                content
            }
            .padding(environment.theme.spacing(.xl, density: environment.density))
            .frame(maxWidth: maxWidth, alignment: .topLeading)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }
}
