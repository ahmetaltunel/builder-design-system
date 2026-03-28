import SwiftUI
import BuilderFoundation

public struct PropertyFilterBar: View {
    public let environment: DesignSystemEnvironment
    @Binding public var query: String
    public let activeTokens: [String]

    public init(environment: DesignSystemEnvironment, query: Binding<String>, activeTokens: [String]) {
        self.environment = environment
        self._query = query
        self.activeTokens = activeTokens
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextFilterField(environment: environment, placeholder: "Filter properties", text: $query)
            TokenGroup(environment: environment, titles: activeTokens)
        }
    }
}
