import SwiftUI
import BuilderDesignSystem

struct ShowcaseNavigationRow: View {
    let environment: DesignSystemEnvironment
    let route: ShowcaseRoute
    let isSelected: Bool

    var body: some View {
        SidebarRow(environment: environment, title: route.title, symbol: route.symbol, isSelected: isSelected)
    }
}

struct ShowcaseRouteHeader<Trailing: View>: View {
    let environment: DesignSystemEnvironment
    let eyebrow: String?
    let title: String
    let subtitle: String
    let trailing: Trailing

    init(
        environment: DesignSystemEnvironment,
        eyebrow: String? = nil,
        title: String,
        subtitle: String,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.environment = environment
        self.eyebrow = eyebrow
        self.title = title
        self.subtitle = subtitle
        self.trailing = trailing()
    }

    var body: some View {
        HeaderBlock(environment: environment, eyebrow: eyebrow, title: title, subtitle: subtitle) {
            trailing
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 18)
        .background(environment.theme.color(.workspaceBackground))
    }
}

struct ShowcaseInspectorSection<Content: View>: View {
    let environment: DesignSystemEnvironment
    let title: String
    let subtitle: String?
    let content: Content

    init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.environment = environment
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(environment.theme.typography(.labelStrong).font)
                .foregroundStyle(environment.theme.color(.textPrimary))

            if let subtitle {
                Text(subtitle)
                    .font(environment.theme.typography(.caption).font)
                    .foregroundStyle(environment.theme.color(.textSecondary))
            }

            content
        }
        .padding(.vertical, 4)
    }
}

struct ShowcaseStatStrip: View {
    let environment: DesignSystemEnvironment
    let items: [(String, String)]

    var body: some View {
        HStack(spacing: 10) {
            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.0)
                        .font(environment.theme.typography(.captionStrong).font)
                        .foregroundStyle(environment.theme.color(.textPrimary))
                    Text(item.1)
                        .font(environment.theme.typography(.caption).font)
                        .foregroundStyle(environment.theme.color(.textSecondary))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
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
        }
    }
}

struct SearchJumpResultsView: View {
    let environment: DesignSystemEnvironment
    let sections: [SearchJumpSection]
    let onSelect: (SearchJumpItem) -> Void

    var body: some View {
        SearchResultsOverlay(
            environment: environment,
            sections: sections.map { section in
                SearchResultSection(
                    title: section.title,
                    items: section.items.map { item in
                        SearchResultItem(
                            id: item.id,
                            title: item.title,
                            subtitle: item.subtitle,
                            symbol: item.symbol
                        )
                    }
                )
            }
        ) { item in
            guard let selected = sections
                .flatMap(\.items)
                .first(where: { $0.id == item.id }) else { return }
            onSelect(selected)
        }
    }
}

struct PreviewCanvasFrame<Content: View>: View {
    let environment: DesignSystemEnvironment
    let content: Content

    init(environment: DesignSystemEnvironment, @ViewBuilder content: () -> Content) {
        self.environment = environment
        self.content = content()
    }

    var body: some View {
        content
            .padding(environment.theme.spacing(.panelPadding, density: environment.density))
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                    .fill(environment.theme.color(.raisedSurface))
            )
            .overlay(
                RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                    .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
            )
    }
}

struct PreviewCanvas<Content: View>: View {
    let environment: DesignSystemEnvironment
    let content: Content

    init(env: DesignSystemEnvironment, @ViewBuilder content: () -> Content) {
        self.environment = env
        self.content = content()
    }

    var body: some View {
        PreviewCanvasFrame(environment: environment) {
            content
        }
    }
}
