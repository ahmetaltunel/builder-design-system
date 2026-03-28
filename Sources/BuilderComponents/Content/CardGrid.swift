import SwiftUI
import BuilderFoundation

public struct CardGrid<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    public let environment: DesignSystemEnvironment
    public let data: Data
    public let columns: Int
    public let content: (Data.Element) -> Content

    public init(
        environment: DesignSystemEnvironment,
        data: Data,
        columns: Int = 3,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.environment = environment
        self.data = data
        self.columns = max(columns, 1)
        self.content = content
    }

    public var body: some View {
        let grid = Array(repeating: GridItem(.flexible(), spacing: 14), count: columns)

        LazyVGrid(columns: grid, spacing: 14) {
            ForEach(data) { element in
                content(element)
                    .padding(14)
                    .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
                    .background(
                        RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                            .fill(environment.theme.color(.groupedSurface))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                            .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
                    )
            }
        }
    }
}
