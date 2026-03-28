import SwiftUI
import BuilderFoundation

public struct ValidationSummary: View {
    public struct Item: Identifiable, Sendable {
        public let id: String
        public let title: String
        public let detail: String
        public let status: FieldStatus

        public init(id: String, title: String, detail: String, status: FieldStatus) {
            self.id = id
            self.title = title
            self.detail = detail
            self.status = status
        }
    }

    public let environment: DesignSystemEnvironment
    public let title: String
    public let items: [Item]

    public init(environment: DesignSystemEnvironment, title: String = "Validation summary", items: [Item]) {
        self.environment = environment
        self.title = title
        self.items = items
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(environment.theme.typography(.labelStrong).font)
                .foregroundStyle(environment.theme.color(.textPrimary))

            ForEach(items) { item in
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(environment.theme.typography(.bodySmallStrong).font)
                        .foregroundStyle(environment.theme.color(.textPrimary))

                    ValidationMessage(environment: environment, status: item.status, message: item.detail)
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                .fill(environment.theme.color(.groupedSurface))
        )
        .overlay(
            RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel(title)
    }
}
