import SwiftUI
import BuilderFoundation

public struct AnchorNavigation: View {
    public struct Item: Identifiable, Hashable {
        public let id: String
        public let title: String

        public init(id: String? = nil, title: String) {
            self.id = id ?? title
            self.title = title
        }
    }

    public let environment: DesignSystemEnvironment
    public let items: [Item]
    @Binding public var selection: String

    public init(environment: DesignSystemEnvironment, items: [Item], selection: Binding<String>) {
        self.environment = environment
        self.items = items
        self._selection = selection
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(items) { item in
                Button {
                    selection = item.id
                } label: {
                    HStack {
                        Text(item.title)
                        Spacer()
                    }
                    .font(environment.theme.typography(.body).font)
                    .foregroundStyle(selection == item.id ? environment.theme.color(.textPrimary) : environment.theme.color(.textSecondary))
                    .padding(.horizontal, 12)
                    .frame(height: 34)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                            .fill(selection == item.id ? environment.theme.color(.sidebarSelection) : .clear)
                    )
                    .contentShape(RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }
}
