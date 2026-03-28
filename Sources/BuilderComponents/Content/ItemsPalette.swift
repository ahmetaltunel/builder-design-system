import SwiftUI
import BuilderFoundation

public struct ItemsPalette: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let subtitle: String?
    public let items: [Board.Item]
    public let onSelect: ((Board.Item) -> Void)?

    public init(
        environment: DesignSystemEnvironment,
        title: String = "Items palette",
        subtitle: String? = nil,
        items: [Board.Item],
        onSelect: ((Board.Item) -> Void)? = nil
    ) {
        self.environment = environment
        self.title = title
        self.subtitle = subtitle
        self.items = items
        self.onSelect = onSelect
    }

    public var body: some View {
        PanelSurface(environment: environment, title: title, subtitle: subtitle) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(items) { item in
                    Group {
                        if let onSelect {
                            Button {
                                onSelect(item)
                            } label: {
                                BoardItemView(environment: environment, item: item)
                            }
                            .buttonStyle(.plain)
                        } else {
                            BoardItemView(environment: environment, item: item)
                        }
                    }
                }
            }
        }
    }
}
