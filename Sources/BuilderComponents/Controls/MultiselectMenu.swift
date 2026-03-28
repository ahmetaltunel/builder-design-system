import SwiftUI
import BuilderFoundation

public struct MultiselectMenu<Selection: Hashable>: View {
    public struct Option {
        public let label: String
        public let value: Selection

        public init(label: String, value: Selection) {
            self.label = label
            self.value = value
        }
    }

    public let environment: DesignSystemEnvironment
    public let options: [Option]
    @Binding public var selection: Set<Selection>
    public let width: CGFloat?
    public let placeholder: String
    public let isEnabled: Bool

    public init(
        environment: DesignSystemEnvironment,
        options: [Option],
        selection: Binding<Set<Selection>>,
        width: CGFloat? = nil,
        placeholder: String = "Choose items",
        isEnabled: Bool = true
    ) {
        self.environment = environment
        self.options = options
        self._selection = selection
        self.width = width
        self.placeholder = placeholder
        self.isEnabled = isEnabled
    }

    public var body: some View {
        Menu {
            ForEach(Array(options.enumerated()), id: \.offset) { _, option in
                Button {
                    if selection.contains(option.value) {
                        selection.remove(option.value)
                    } else {
                        selection.insert(option.value)
                    }
                } label: {
                    if selection.contains(option.value) {
                        Label(option.label, systemImage: "checkmark")
                    } else {
                        Text(option.label)
                    }
                }
            }
        } label: {
            HStack(spacing: 10) {
                Text(summaryLabel)
                    .font(environment.theme.typography(.bodySmall).font)
                    .foregroundStyle(selection.isEmpty ? environment.theme.color(.textMuted) : environment.theme.color(.textPrimary))
                    .lineLimit(1)

                Spacer(minLength: 6)

                Image(systemName: "chevron.down")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(environment.theme.color(.textSecondary))
            }
            .padding(.horizontal, 14)
            .frame(width: width, height: 38)
            .frame(maxWidth: width == nil ? .infinity : nil, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                    .fill(environment.theme.color(.inputSurface))
            )
            .overlay(
                RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                    .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
            )
            .opacity(isEnabled ? 1 : 0.55)
        }
        .menuStyle(.borderlessButton)
        .disabled(!isEnabled)
    }

    private var summaryLabel: String {
        let labels = options.filter { selection.contains($0.value) }.map(\.label)
        if labels.isEmpty { return placeholder }
        return labels.joined(separator: ", ")
    }
}
