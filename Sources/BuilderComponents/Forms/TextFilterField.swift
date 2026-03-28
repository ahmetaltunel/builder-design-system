import SwiftUI
import BuilderFoundation

public struct TextFilterField: View {
    public let environment: DesignSystemEnvironment
    public let placeholder: String
    @Binding public var text: String

    public init(environment: DesignSystemEnvironment, placeholder: String = "Filter", text: Binding<String>) {
        self.environment = environment
        self.placeholder = placeholder
        self._text = text
    }

    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(environment.theme.color(.textMuted))

            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .font(environment.theme.typography(.body).font)
                .foregroundStyle(environment.theme.color(.textPrimary))

            if text.isEmpty == false {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(environment.theme.color(.textMuted))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 38)
        .background(
            RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                .fill(environment.theme.color(.inputSurface))
        )
        .overlay(
            RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
        )
    }
}
