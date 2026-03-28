import SwiftUI
import BuilderFoundation

public struct TilePicker<Selection: Hashable>: View {
    public struct Option {
        public let label: String
        public let detail: String?
        public let symbol: String?
        public let value: Selection

        public init(label: String, detail: String? = nil, symbol: String? = nil, value: Selection) {
            self.label = label
            self.detail = detail
            self.symbol = symbol
            self.value = value
        }
    }

    public let environment: DesignSystemEnvironment
    public let columns: Int
    public let options: [Option]
    @Binding public var selection: Selection

    public init(environment: DesignSystemEnvironment, columns: Int = 2, options: [Option], selection: Binding<Selection>) {
        self.environment = environment
        self.columns = max(columns, 1)
        self.options = options
        self._selection = selection
    }

    public var body: some View {
        let grid = Array(repeating: GridItem(.flexible(), spacing: 12), count: columns)

        LazyVGrid(columns: grid, spacing: 12) {
            ForEach(Array(options.enumerated()), id: \.offset) { _, option in
                Button {
                    selection = option.value
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        if let symbol = option.symbol {
                            Image(systemName: symbol)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(environment.theme.color(.accentPrimary))
                        }

                        Text(option.label)
                            .font(environment.theme.typography(.bodyStrong).font)
                            .foregroundStyle(environment.theme.color(.textPrimary))

                        if let detail = option.detail {
                            Text(detail)
                                .font(environment.theme.typography(.caption).font)
                                .foregroundStyle(environment.theme.color(.textSecondary))
                        }
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, minHeight: 96, alignment: .topLeading)
                    .background(
                        RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                            .fill(option.value == selection ? environment.theme.color(.selectedSurface) : environment.theme.color(.groupedSurface))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                            .stroke(option.value == selection ? environment.theme.color(.accentPrimary) : environment.theme.color(.subtleBorder), lineWidth: 1)
                    )
                    .contentShape(RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous))
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
                .accessibilityLabel(option.label)
                .accessibilityValue(option.value == selection ? "Selected" : "Not selected")
                .accessibilityHint(option.detail ?? "Tile option")
            }
        }
    }
}
