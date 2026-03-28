import SwiftUI
import BuilderFoundation

public struct SearchResultItem<ID: Hashable>: Identifiable, Hashable {
    public let id: ID
    public let title: String
    public let subtitle: String
    public let symbol: String

    public init(id: ID, title: String, subtitle: String, symbol: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.symbol = symbol
    }
}

public struct SearchResultSection<ID: Hashable>: Identifiable, Hashable {
    public let title: String
    public let items: [SearchResultItem<ID>]

    public var id: String { title }

    public init(title: String, items: [SearchResultItem<ID>]) {
        self.title = title
        self.items = items
    }
}

public struct SearchResultsOverlay<ID: Hashable>: View {
    public let environment: DesignSystemEnvironment
    public let sections: [SearchResultSection<ID>]
    public let onSelect: (SearchResultItem<ID>) -> Void

    public init(
        environment: DesignSystemEnvironment,
        sections: [SearchResultSection<ID>],
        onSelect: @escaping (SearchResultItem<ID>) -> Void
    ) {
        self.environment = environment
        self.sections = sections
        self.onSelect = onSelect
    }

    public var body: some View {
        ScrollView(showsIndicators: true) {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(sections) { section in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(section.title)
                            .font(environment.theme.typography(.captionStrong).font)
                            .foregroundStyle(environment.theme.color(.textMuted))

                        ForEach(section.items) { item in
                            Button {
                                onSelect(item)
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: item.symbol)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(environment.theme.color(.textSecondary))
                                        .frame(width: 16)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(item.title)
                                            .font(environment.theme.typography(.bodySmallStrong).font)
                                            .foregroundStyle(environment.theme.color(.textPrimary))
                                        Text(item.subtitle)
                                            .font(environment.theme.typography(.caption).font)
                                            .foregroundStyle(environment.theme.color(.textSecondary))
                                            .lineLimit(1)
                                    }

                                    Spacer(minLength: 0)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                                        .fill(environment.theme.color(.inputSurface))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                                        .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("\(item.title), \(item.subtitle)")
                            .accessibilityHint("Open search result")
                        }
                    }
                }
            }
            .padding(14)
        }
        .frame(maxWidth: .infinity, maxHeight: 420, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                .fill(environment.theme.color(.groupedSurface))
        )
        .overlay(
            RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Search results")
    }
}
