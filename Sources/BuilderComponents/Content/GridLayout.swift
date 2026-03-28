import SwiftUI
import BuilderFoundation

public struct GridLayout<Content: View>: View {
    public let environment: DesignSystemEnvironment
    public let columns: Int
    public let content: Content

    public init(environment: DesignSystemEnvironment, columns: Int = 3, @ViewBuilder content: () -> Content) {
        self.environment = environment
        self.columns = max(columns, 1)
        self.content = content()
    }

    public var body: some View {
        let gridItems = Array(repeating: GridItem(.flexible(), spacing: environment.theme.spacing(.md, density: environment.density)), count: columns)
        LazyVGrid(columns: gridItems, spacing: environment.theme.spacing(.md, density: environment.density)) {
            content
        }
    }
}
