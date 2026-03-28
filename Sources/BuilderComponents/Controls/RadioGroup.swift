import SwiftUI
import BuilderFoundation

public struct RadioGroup<Selection: Hashable>: View {
    public struct Option {
        public let label: String
        public let detail: String?
        public let value: Selection
        public let isEnabled: Bool

        public init(label: String, detail: String? = nil, value: Selection, isEnabled: Bool = true) {
            self.label = label
            self.detail = detail
            self.value = value
            self.isEnabled = isEnabled
        }
    }

    public let environment: DesignSystemEnvironment
    public let options: [Option]
    @Binding public var selection: Selection

    public init(
        environment: DesignSystemEnvironment,
        options: [Option],
        selection: Binding<Selection>
    ) {
        self.environment = environment
        self.options = options
        self._selection = selection
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(options.enumerated()), id: \.offset) { _, option in
                Button {
                    guard option.isEnabled else { return }
                    selection = option.value
                } label: {
                    HStack(alignment: .top, spacing: 12) {
                        let selected = option.value == selection

                        Circle()
                            .fill(selected ? environment.theme.color(.accentPrimary) : .clear)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Circle()
                                    .stroke(selected ? environment.theme.color(.accentPrimary) : environment.theme.color(.subtleBorder), lineWidth: 1.5)
                            )
                            .overlay {
                                if selected {
                                    Circle()
                                        .fill(environment.theme.color(.textOnAccent))
                                        .frame(width: 7, height: 7)
                                }
                            }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(option.label)
                                .font(environment.theme.typography(.bodyStrong).font)
                                .foregroundStyle(environment.theme.color(.textPrimary))

                            if let detail = option.detail {
                                Text(detail)
                                    .font(environment.theme.typography(.helper).font)
                                    .foregroundStyle(environment.theme.color(.textSecondary))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }

                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                            .fill(option.value == selection ? environment.theme.color(.selectedSurface) : .clear)
                    )
                    .opacity(option.isEnabled ? 1 : 0.55)
                    .contentShape(RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous))
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
                .accessibilityLabel(option.label)
                .accessibilityValue(option.value == selection ? "Selected" : "Not selected")
                .accessibilityHint(option.isEnabled ? "Radio option" : "Disabled radio option")
            }
        }
    }
}
