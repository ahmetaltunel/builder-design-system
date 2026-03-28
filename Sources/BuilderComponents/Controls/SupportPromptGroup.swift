import SwiftUI
import BuilderFoundation

public struct SupportPromptGroup: View {
    public struct Prompt: Identifiable, Hashable, Sendable {
        public let id: String
        public let title: String
        public let detail: String?
        public let isEnabled: Bool
        public let isSelected: Bool
        public let isRecommended: Bool

        public init(
            id: String? = nil,
            title: String,
            detail: String? = nil,
            isEnabled: Bool = true,
            isSelected: Bool = false,
            isRecommended: Bool = false
        ) {
            self.id = id ?? title
            self.title = title
            self.detail = detail
            self.isEnabled = isEnabled
            self.isSelected = isSelected
            self.isRecommended = isRecommended
        }

        public init(id: String? = nil, title: String, detail: String? = nil) {
            self.init(
                id: id,
                title: title,
                detail: detail,
                isEnabled: true,
                isSelected: false,
                isRecommended: false
            )
        }
    }

    public let environment: DesignSystemEnvironment
    public let title: String?
    public let prompts: [Prompt]
    public let onSelect: (Prompt) -> Void

    public init(
        environment: DesignSystemEnvironment,
        title: String? = nil,
        prompts: [Prompt],
        onSelect: @escaping (Prompt) -> Void
    ) {
        self.environment = environment
        self.title = title
        self.prompts = prompts
        self.onSelect = onSelect
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let title {
                Text(title)
                    .font(environment.theme.typography(.labelStrong).font)
                    .foregroundStyle(environment.theme.color(.textPrimary))
            }

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 10)], spacing: 10) {
                ForEach(prompts) { prompt in
                    Button {
                        guard prompt.isEnabled else { return }
                        onSelect(prompt)
                    } label: {
                        promptCard(for: prompt)
                    }
                    .buttonStyle(.plain)
                    .disabled(!prompt.isEnabled)
                    .opacity(prompt.isEnabled ? 1 : 0.55)
                    .accessibilityLabel(prompt.title)
                    .accessibilityValue(accessibilityValue(for: prompt))
                    .accessibilityHint(prompt.isEnabled ? "Select suggested prompt" : "Suggested prompt unavailable")
                }
            }
        }
    }

    private func promptCard(for prompt: Prompt) -> some View {
        let selectedMaterial = environment.theme.material(.selected)

        return VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 8) {
                Text(prompt.title)
                    .font(environment.theme.typography(.bodyStrong).font)
                    .foregroundStyle(environment.theme.color(.textPrimary))
                    .frame(maxWidth: .infinity, alignment: .leading)

                if prompt.isRecommended {
                    StatusBadge(
                        environment: environment,
                        label: "Recommended",
                        color: environment.theme.color(.accentPrimary)
                    )
                }
            }

            if let detail = prompt.detail {
                Text(detail)
                    .font(environment.theme.typography(.caption).font)
                    .foregroundStyle(environment.theme.color(.textSecondary))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                .fill(
                    prompt.isSelected
                    ? selectedMaterial.fill.opacity(selectedMaterial.fillOpacity)
                    : environment.theme.color(.inputSurface)
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                .stroke(prompt.isSelected ? environment.theme.color(.accentPrimary) : environment.theme.color(.subtleBorder), lineWidth: prompt.isSelected ? 1.5 : 1)
        )
    }

    private func accessibilityValue(for prompt: Prompt) -> String {
        var values: [String] = []

        if prompt.isSelected {
            values.append("Selected")
        }

        if prompt.isRecommended {
            values.append("Recommended")
        }

        if !prompt.isEnabled {
            values.append("Disabled")
        }

        return values.isEmpty ? "Available" : values.joined(separator: ", ")
    }
}
