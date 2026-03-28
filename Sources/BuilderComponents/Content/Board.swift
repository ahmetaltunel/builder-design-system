import SwiftUI
import BuilderFoundation

public struct Board: View {
    public struct Column: Identifiable, Hashable {
        public let id: String
        public let title: String
        public let cards: [String]

        public init(id: String? = nil, title: String, cards: [String]) {
            self.id = id ?? title
            self.title = title
            self.cards = cards
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

                        ForEach(column.cards, id: \.self) { card in
                            Text(card)
                                .font(environment.theme.typography(.body).font)
                                .foregroundStyle(environment.theme.color(.textPrimary))
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                                        .fill(environment.theme.color(.raisedSurface))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                                        .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
                                )
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
