import SwiftUI
import BuilderFoundation

public struct TokenGroup: View {
    public let environment: DesignSystemEnvironment
    public let titles: [String]

    public init(environment: DesignSystemEnvironment, titles: [String]) {
        self.environment = environment
        self.titles = titles
    }

    public var body: some View {
        HStack(spacing: 8) {
            ForEach(titles, id: \.self) { title in
                TokenBadge(environment: environment, title: title)
            }
        }
    }
}
