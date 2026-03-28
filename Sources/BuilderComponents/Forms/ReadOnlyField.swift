import SwiftUI
import BuilderFoundation

public struct ReadOnlyField: View {
    public let environment: DesignSystemEnvironment
    public let value: String
    public let leadingSymbol: String?
    public let hint: String?

    public init(
        environment: DesignSystemEnvironment,
        value: String,
        leadingSymbol: String? = nil,
        hint: String? = "Read-only"
    ) {
        self.environment = environment
        self.value = value
        self.leadingSymbol = leadingSymbol
        self.hint = hint
    }

    public var body: some View {
        let material = environment.theme.material(.inset)
        HStack(spacing: 10) {
            if let leadingSymbol {
                Image(systemName: leadingSymbol)
                    .foregroundStyle(environment.theme.color(.textMuted))
            }

            Text(value)
                .font(environment.theme.typography(.body).font)
                .foregroundStyle(environment.theme.color(.textSecondary))

            Spacer(minLength: 8)

            if let hint {
                Text(hint)
                    .font(environment.theme.typography(.caption).font)
                    .foregroundStyle(environment.theme.color(.textMuted))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule(style: .continuous)
                            .fill(environment.theme.color(.groupedSurface))
                    )
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 40)
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
