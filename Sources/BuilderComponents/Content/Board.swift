import SwiftUI
import BuilderFoundation

public struct Board: View {
    public struct Item: Identifiable {
        public let id: String
        public let title: String
        public let detail: String?
        public let status: String?
        public let statusColor: Color?
        public let symbol: String

        public init(
            id: String? = nil,
            title: String,
            detail: String? = nil,
            status: String? = nil,
            statusColor: Color? = nil,
            symbol: String = "square.grid.2x2"
        ) {
            self.id = id ?? title
            self.title = title
            self.detail = detail
            self.status = status
            self.statusColor = statusColor
            self.symbol = symbol
        }
    }

    public struct Column: Identifiable {
        public let id: String
        public let title: String
        public let items: [Item]

        public init(id: String? = nil, title: String, items: [Item]) {
            self.id = id ?? title
            self.title = title
            self.items = items
        }

        public init(id: String? = nil, title: String, cards: [String]) {
            self.init(
                id: id,
                title: title,
                items: cards.map { Item(title: $0) }
            )
        }
    }

    public let environment: DesignSystemEnvironment
    public let columns: [Column]

    public init(environment: DesignSystemEnvironment, columns: [Column]) {
        self.environment = environment
        self.columns = columns
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 16) {
                ForEach(columns) { column in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(column.title)
                            .font(environment.theme.typography(.bodyStrong).font)
                            .foregroundStyle(environment.theme.color(.textPrimary))

                        ForEach(column.items) { item in
                            BoardItemView(environment: environment, item: item)
                        }
                    }
                    .padding(14)
                    .frame(width: 240, alignment: .topLeading)
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
}
