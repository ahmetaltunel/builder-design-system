import SwiftUI
import UniformTypeIdentifiers
import BuilderFoundation

public struct BoardItemView: View {
    public let environment: DesignSystemEnvironment
    public let item: Board.Item
    public let isSelected: Bool
    public let isFocused: Bool
    public let onActivate: (() -> Void)?
    public let moveDestinations: [Board.Destination]
    public let onMove: ((Board.Destination) -> Void)?
    public let insertDestinations: [Board.Destination]
    public let onInsert: ((Board.Destination) -> Void)?
    public let dragPayload: String?

    public init(
        environment: DesignSystemEnvironment,
        item: Board.Item,
        isSelected: Bool = false,
        isFocused: Bool = false,
        onActivate: (() -> Void)? = nil,
        moveDestinations: [Board.Destination] = [],
        onMove: ((Board.Destination) -> Void)? = nil,
        insertDestinations: [Board.Destination] = [],
        onInsert: ((Board.Destination) -> Void)? = nil,
        dragPayload: String? = nil
    ) {
        self.environment = environment
        self.item = item
        self.isSelected = isSelected
        self.isFocused = isFocused
        self.onActivate = onActivate
        self.moveDestinations = moveDestinations
        self.onMove = onMove
        self.insertDestinations = insertDestinations
        self.onInsert = onInsert
        self.dragPayload = dragPayload
    }

    public init(environment: DesignSystemEnvironment, item: Board.Item) {
        self.init(
            environment: environment,
            item: item,
            isSelected: false,
            isFocused: false,
            onActivate: nil,
            moveDestinations: [],
            onMove: nil,
            insertDestinations: [],
            onInsert: nil,
            dragPayload: nil
        )
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            dragEnabledContent {
                if let onActivate {
                    Button(action: onActivate) {
                        itemCard
                    }
                    .buttonStyle(.plain)
                } else {
                    itemCard
                }
            }

            if !moveDestinations.isEmpty || !insertDestinations.isEmpty {
                HStack(spacing: 8) {
                    if let onMove, !moveDestinations.isEmpty {
                        Menu {
                            ForEach(moveDestinations) { destination in
                                Button(destination.title) {
                                    onMove(destination)
                                }
                            }
                        } label: {
                            actionChip(title: "Move", symbol: "arrow.up.arrow.down")
                        }
                        .menuStyle(.borderlessButton)
                    }

                    if let onInsert, !insertDestinations.isEmpty {
                        Menu {
                            ForEach(insertDestinations) { destination in
                                Button(destination.title) {
                                    onInsert(destination)
                                }
                            }
                        } label: {
                            actionChip(title: "Insert", symbol: "plus")
                        }
                        .menuStyle(.borderlessButton)
                    }

                    Spacer(minLength: 0)
                }
            }
        }
    }

    private var itemCard: some View {
        let selectedMaterial = environment.theme.material(.selected)

        return VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 8) {
                Image(systemName: item.symbol)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(environment.theme.color(.accentPrimary))

                Text(item.title)
                    .font(environment.theme.typography(.bodyStrong).font)
                    .foregroundStyle(environment.theme.color(.textPrimary))

                Spacer(minLength: 0)

                if let status = item.status {
                    StatusBadge(
                        environment: environment,
                        label: status,
                        color: item.statusColor ?? environment.theme.color(.textSecondary)
                    )
                }
            }

            if let detail = item.detail {
                Text(detail)
                    .font(environment.theme.typography(.caption).font)
                    .foregroundStyle(environment.theme.color(.textSecondary))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                .fill(
                    isSelected
                    ? selectedMaterial.fill.opacity(selectedMaterial.fillOpacity)
                    : environment.theme.color(.raisedSurface)
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                .stroke(
                    isFocused
                    ? environment.theme.color(.focusRing)
                    : (isSelected ? environment.theme.color(.accentPrimary) : environment.theme.color(.subtleBorder)),
                    lineWidth: isFocused || isSelected ? 1.5 : 1
                )
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(item.title)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityHint(onActivate == nil ? "Board item" : "Activate item")
    }

    private func actionChip(title: String, symbol: String) -> some View {
        Label(title, systemImage: symbol)
            .font(environment.theme.typography(.caption).font)
            .foregroundStyle(environment.theme.color(.textPrimary))
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                    .fill(environment.theme.color(.inputSurface))
            )
            .overlay(
                RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                    .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
            )
    }

    @ViewBuilder
    private func dragEnabledContent<Content: View>(
        @ViewBuilder _ content: () -> Content
    ) -> some View {
        if let dragPayload {
            content()
                .onDrag {
                    NSItemProvider(object: NSString(string: dragPayload))
                }
        } else {
            content()
        }
    }
}
