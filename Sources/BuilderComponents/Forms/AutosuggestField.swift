import SwiftUI
import BuilderFoundation

public struct AutosuggestField: View {
    public let environment: DesignSystemEnvironment
    public let placeholder: String
    public let suggestions: [String]
    @Binding public var text: String
    public let onCommit: ((String) -> Void)?

    public init(
        environment: DesignSystemEnvironment,
        placeholder: String = "",
        suggestions: [String],
        text: Binding<String>,
        onCommit: ((String) -> Void)? = nil
    ) {
        self.environment = environment
        self.placeholder = placeholder
        self.suggestions = suggestions
        self._text = text
        self.onCommit = onCommit
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextInputField(environment: environment, placeholder: placeholder, text: $text)

            if filteredSuggestions.isEmpty == false {
                VStack(spacing: 0) {
                    ForEach(filteredSuggestions, id: \.self) { suggestion in
                        Button {
                            text = suggestion
                            onCommit?(suggestion)
                        } label: {
                            HStack {
                                Text(suggestion)
                                Spacer()
                            }
                            .font(environment.theme.typography(.body).font)
                            .foregroundStyle(environment.theme.color(.textPrimary))
                            .padding(.horizontal, 14)
                            .frame(height: 34)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(.plain)

                        if suggestion != filteredSuggestions.last {
                            Rectangle()
                                .fill(environment.theme.color(.subtleBorder))
                                .frame(height: 1)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                        .fill(environment.theme.color(.groupedSurface))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                        .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
                )
            }
        }
    }

    private var filteredSuggestions: [String] {
        guard text.isEmpty == false else { return [] }
        return suggestions.filter { $0.localizedCaseInsensitiveContains(text) }.prefix(5).map { $0 }
    }
}
