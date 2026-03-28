import SwiftUI
import BuilderFoundation

public struct Tabs<Selection: Hashable>: View {
    public struct TabItem {
        public let title: String
        public let value: Selection

        public init(title: String, value: Selection) {
            self.title = title
            self.value = value
        }
    }

    public let environment: DesignSystemEnvironment
    public let items: [TabItem]
    @Binding public var selection: Selection

    public init(
        environment: DesignSystemEnvironment,
        items: [TabItem],
        selection: Binding<Selection>
    ) {
        self.environment = environment
        self.items = items
        self._selection = selection
    }

    public var body: some View {
        HStack(spacing: 18) {
            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                let selected = item.value == selection

                Button {
                    selection = item.value
                } label: {
                    VStack(spacing: 8) {
                        Text(item.title)
                            .font(environment.theme.typography(.bodyStrong).font)
                            .foregroundStyle(selected ? environment.theme.color(.textPrimary) : environment.theme.color(.textSecondary))

                        Capsule(style: .continuous)
                            .fill(selected ? environment.theme.color(.accentPrimary) : .clear)
                            .frame(height: 3)
                    }
                }
                .buttonStyle(.plain)
            }

            Spacer(minLength: 0)
        }
    }
}
