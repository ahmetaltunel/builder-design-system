import SwiftUI
import BuilderFoundation

public struct CommandPalette<ID: Hashable>: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let placeholder: String
    @Binding public var query: String
    @Binding private var isFocused: Bool
    public let sections: [SearchResultSection<ID>]
    public let onSelect: (SearchResultItem<ID>) -> Void

    public init(
        environment: DesignSystemEnvironment,
        title: String = "Command palette",
        placeholder: String = "Search commands",
        query: Binding<String>,
        isFocused: Binding<Bool>? = nil,
        sections: [SearchResultSection<ID>],
        onSelect: @escaping (SearchResultItem<ID>) -> Void
    ) {
        self.environment = environment
        self.title = title
        self.placeholder = placeholder
        self._query = query
        self._isFocused = isFocused ?? .constant(false)
        self.sections = sections
        self.onSelect = onSelect
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(environment.theme.typography(.labelStrong).font)
                .foregroundStyle(environment.theme.color(.textPrimary))

            TextInputField(
                environment: environment,
                placeholder: placeholder,
                text: $query,
                isFocused: $isFocused,
                leadingSymbol: "magnifyingglass"
            )

            if sections.isEmpty {
                EmptyStateView(
                    environment: environment,
                    title: "No matches",
                    message: "Try a broader term or clear the current query.",
                    symbol: "magnifyingglass"
                )
            } else {
                SearchResultsOverlay(environment: environment, sections: sections, onSelect: onSelect)
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                .fill(environment.theme.color(.raisedSurface))
        )
        .overlay(
            RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel(title)
    }
}
