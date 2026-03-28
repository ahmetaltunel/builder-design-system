import SwiftUI
import BuilderFoundation

public struct ExpandableSection<Content: View>: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let subtitle: String?
    @Binding public var isExpanded: Bool
    public let content: Content

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        isExpanded: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) {
        self.environment = environment
        self.title = title
        self.subtitle = subtitle
        self._isExpanded = isExpanded
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                isExpanded.toggle()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(environment.theme.typography(.bodyStrong).font)
                            .foregroundStyle(environment.theme.color(.textPrimary))
                        if let subtitle {
                            Text(subtitle)
                                .font(environment.theme.typography(.caption).font)
                                .foregroundStyle(environment.theme.color(.textSecondary))
                        }
                    }
                    Spacer()
                }
                .padding(14)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isExpanded {
                Rectangle()
                    .fill(environment.theme.color(.subtleBorder))
                    .frame(height: 1)

                content
                    .padding(14)
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
