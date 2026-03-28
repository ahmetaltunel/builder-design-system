import SwiftUI
import BuilderFoundation

public struct ResourceSelector: View {
    public let environment: DesignSystemEnvironment
    public let resources: [String]
    @Binding public var selection: String

    public init(environment: DesignSystemEnvironment, resources: [String], selection: Binding<String>) {
        self.environment = environment
        self.resources = resources
        self._selection = selection
    }

    public var body: some View {
        SelectMenu(
            environment: environment,
            options: resources.map { .init(label: $0, value: $0) },
            selection: $selection
        )
    }
}
