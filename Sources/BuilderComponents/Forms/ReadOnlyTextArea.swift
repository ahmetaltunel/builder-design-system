import SwiftUI
import BuilderFoundation

public struct ReadOnlyTextArea: View {
    public let environment: DesignSystemEnvironment
    public let value: String
    public let hint: String?

    public init(
        environment: DesignSystemEnvironment,
        value: String,
        hint: String? = "Preview only"
    ) {
        self.environment = environment
        self.value = value
        self.hint = hint
    }

    public var body: some View {
        let material = environment.theme.material(.inset)
        VStack(alignment: .leading, spacing: 10) {
            Text(value)
                .font(environment.theme.typography(.body).font)
                .foregroundStyle(environment.theme.color(.textSecondary))
                .fixedSize(horizontal: false, vertical: true)

            if let hint {
                Text(hint)
                    .font(environment.theme.typography(.caption).font)
                    .foregroundStyle(environment.theme.color(.textMuted))
            }
        }
        .frame(maxWidth: .infinity, minHeight: 92, alignment: .topLeading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: environment.theme.radius(material.radius), style: .continuous)
                .fill(material.fill.opacity(material.fillOpacity))
        )
        .overlay(
            RoundedRectangle(cornerRadius: environment.theme.radius(material.radius), style: .continuous)
                .stroke(material.border, lineWidth: material.borderWidth)
        )
    }
}
