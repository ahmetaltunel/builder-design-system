import SwiftUI
import BuilderFoundation

public struct ButtonDropdown: View {
    public struct Item: Identifiable, Hashable {
        public let id: String
        public let title: String
        public let symbol: String?
        public let action: () -> Void

        public init(id: String? = nil, title: String, symbol: String? = nil, action: @escaping () -> Void) {
            self.id = id ?? title
            self.title = title
            self.symbol = symbol
            self.action = action
        }

        public static func == (lhs: Item, rhs: Item) -> Bool { lhs.id == rhs.id && lhs.title == rhs.title && lhs.symbol == rhs.symbol }
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(title)
            hasher.combine(symbol)
        }
    }

    public let environment: DesignSystemEnvironment
    public let title: String
    public let tone: ButtonTone
    public let items: [Item]

    public init(environment: DesignSystemEnvironment, title: String, tone: ButtonTone = .secondary, items: [Item]) {
        self.environment = environment
        self.title = title
        self.tone = tone
        self.items = items
    }

    public var body: some View {
        Menu {
            ForEach(items) { item in
                Button(action: item.action) {
                    if let symbol = item.symbol {
                        Label(item.title, systemImage: symbol)
                    } else {
                        Text(item.title)
                    }
                }
            }
        } label: {
            HStack(spacing: 8) {
                Text(title)
                    .font(environment.theme.typography(.button).font)
                Image(systemName: "chevron.down")
                    .font(.system(size: 11, weight: .semibold))
            }
            .foregroundStyle(tone == .primary ? environment.theme.color(.textOnAccent) : environment.theme.color(.textPrimary))
            .padding(.horizontal, 16)
            .frame(height: 38)
            .background(
                RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                    .fill(tone == .primary ? environment.theme.color(.accentPrimary) : environment.theme.color(.inputSurface))
            )
            .overlay(
                RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                    .stroke(tone == .primary ? .clear : environment.theme.color(.subtleBorder), lineWidth: 1)
            )
        }
        .menuStyle(.borderlessButton)
    }
}
