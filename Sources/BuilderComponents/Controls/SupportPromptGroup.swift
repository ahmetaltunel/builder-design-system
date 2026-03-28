import SwiftUI
import BuilderFoundation

public struct SupportPromptGroup: View {
    public struct Prompt: Identifiable {
        public let id: String
        public let title: String
        public let detail: String?

        public init(id: String? = nil, title: String, detail: String? = nil) {
            self.id = id ?? title
            self.title = title
            self.detail = detail
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
                        onSelect(prompt)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(prompt.title)
                                .font(environment.theme.typography(.bodyStrong).font)
                                .foregroundStyle(environment.theme.color(.textPrimary))
                                .frame(maxWidth: .infinity, alignment: .leading)

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
                                .fill(environment.theme.color(.inputSurface))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                                .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
