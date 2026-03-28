import SwiftUI
import BuilderFoundation

public struct SegmentedPicker<Selection: Hashable>: View {
    public let environment: DesignSystemEnvironment
    public let options: [(label: String, value: Selection)]
    @Binding public var selection: Selection
    public let style: SegmentedControlStyle

    public init(
        environment: DesignSystemEnvironment,
        options: [(label: String, value: Selection)],
        selection: Binding<Selection>,
        style: SegmentedControlStyle = .accent
    ) {
        self.environment = environment
        self.options = options
        self._selection = selection
        self.style = style
    }

    public var body: some View {
        let segmentHeight = max(28, 32 + environment.density.controlHeightOffset)
        let outerRadius: CGFloat = environment.density == .compact ? 12 : 14
        let innerRadius: CGFloat = environment.density == .compact ? 9 : 10

        HStack(spacing: 4) {
            ForEach(Array(options.enumerated()), id: \.offset) { _, option in
                let isSelected = option.value == selection

                Button {
                    selection = option.value
                } label: {
                    Text(option.label)
                        .font(environment.theme.typography(.bodySmallStrong).font)
                        .foregroundStyle(foreground(isSelected: isSelected))
                        .frame(maxWidth: .infinity)
                        .frame(height: segmentHeight)
                        .background(
                            RoundedRectangle(cornerRadius: innerRadius, style: .continuous)
                                .fill(background(isSelected: isSelected))
                        )
                }
                .buttonStyle(.plain)
                .contentShape(RoundedRectangle(cornerRadius: innerRadius, style: .continuous))
                .accessibilityLabel(option.label)
                .accessibilityValue(isSelected ? "Selected" : "Not selected")
                .accessibilityHint("Segment option")
            }
        }
        .padding(3)
        .background(
            RoundedRectangle(cornerRadius: outerRadius, style: .continuous)
                .fill(environment.theme.color(.inputSurface))
        )
        .overlay(
            RoundedRectangle(cornerRadius: outerRadius, style: .continuous)
                .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
        )
    }

    private func background(isSelected: Bool) -> Color {
        guard isSelected else { return .clear }

        switch style {
        case .accent:
            return environment.theme.color(.accentPrimary)
        case .neutral:
            return environment.mode == .dark ? environment.theme.color(.overlaySurface) : environment.theme.color(.sidebarSelection)
        }
    }

    private func foreground(isSelected: Bool) -> Color {
        guard isSelected else { return environment.theme.color(.textSecondary) }

        switch style {
        case .accent:
            return environment.theme.color(.textOnAccent)
        case .neutral:
            return environment.theme.color(.textPrimary)
        }
    }
}
