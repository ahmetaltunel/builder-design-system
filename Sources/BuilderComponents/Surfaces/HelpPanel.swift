import SwiftUI
import BuilderFoundation
import BuilderBehaviors

public struct HelpPanel<Content: View, Footer: View>: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let subtitle: String?
    public let state: AsyncContentState
    public let emptyActionTitle: String?
    public let onEmptyAction: (() -> Void)?
    public let errorActionTitle: String?
    public let onErrorAction: (() -> Void)?
    public let topics: [HelpTopic]
    public let selectedTopicID: Binding<String?>?
    public let content: Content
    public let footer: Footer
    public let showsFooter: Bool

    @State private var localSelectedTopicID: String?

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        state: AsyncContentState = .ready,
        emptyActionTitle: String? = nil,
        onEmptyAction: (() -> Void)? = nil,
        errorActionTitle: String? = nil,
        onErrorAction: (() -> Void)? = nil,
        topics: [HelpTopic] = [],
        selectedTopicID: Binding<String?>? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.environment = environment
        self.title = title
        self.subtitle = subtitle
        self.state = state
        self.emptyActionTitle = emptyActionTitle
        self.onEmptyAction = onEmptyAction
        self.errorActionTitle = errorActionTitle
        self.onErrorAction = onErrorAction
        self.topics = topics
        self.selectedTopicID = selectedTopicID
        self.content = content()
        self.footer = footer()
        self.showsFooter = true
    }

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        state: AsyncContentState = .ready,
        emptyActionTitle: String? = nil,
        onEmptyAction: (() -> Void)? = nil,
        errorActionTitle: String? = nil,
        onErrorAction: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.init(
            environment: environment,
            title: title,
            subtitle: subtitle,
            state: state,
            emptyActionTitle: emptyActionTitle,
            onEmptyAction: onEmptyAction,
            errorActionTitle: errorActionTitle,
            onErrorAction: onErrorAction,
            topics: [],
            selectedTopicID: nil,
            content: content,
            footer: footer
        )
    }

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        topics: [HelpTopic] = [],
        selectedTopicID: Binding<String?>? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.init(
            environment: environment,
            title: title,
            subtitle: subtitle,
            state: .ready,
            emptyActionTitle: nil,
            onEmptyAction: nil,
            errorActionTitle: nil,
            onErrorAction: nil,
            topics: topics,
            selectedTopicID: selectedTopicID,
            content: content,
            footer: footer
        )
    }

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.init(
            environment: environment,
            title: title,
            subtitle: subtitle,
            topics: [],
            selectedTopicID: nil,
            content: content,
            footer: footer
        )
    }

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        state: AsyncContentState = .ready,
        emptyActionTitle: String? = nil,
        onEmptyAction: (() -> Void)? = nil,
        errorActionTitle: String? = nil,
        onErrorAction: (() -> Void)? = nil,
        topics: [HelpTopic] = [],
        selectedTopicID: Binding<String?>? = nil,
        @ViewBuilder content: () -> Content
    ) where Footer == EmptyView {
        self.environment = environment
        self.title = title
        self.subtitle = subtitle
        self.state = state
        self.emptyActionTitle = emptyActionTitle
        self.onEmptyAction = onEmptyAction
        self.errorActionTitle = errorActionTitle
        self.onErrorAction = onErrorAction
        self.topics = topics
        self.selectedTopicID = selectedTopicID
        self.content = content()
        self.footer = EmptyView()
        self.showsFooter = false
    }

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        state: AsyncContentState = .ready,
        emptyActionTitle: String? = nil,
        onEmptyAction: (() -> Void)? = nil,
        errorActionTitle: String? = nil,
        onErrorAction: (() -> Void)? = nil,
        navigator: HelpNavigator,
        @ViewBuilder content: () -> Content
    ) where Footer == EmptyView {
        self.init(
            environment: environment,
            title: title,
            subtitle: subtitle,
            state: state,
            emptyActionTitle: emptyActionTitle,
            onEmptyAction: onEmptyAction,
            errorActionTitle: errorActionTitle,
            onErrorAction: onErrorAction,
            topics: navigator.topics,
            selectedTopicID: Binding(
                get: { navigator.selectedTopicID },
                set: { navigator.selectTopic($0) }
            ),
            content: content
        )
    }

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        state: AsyncContentState = .ready,
        emptyActionTitle: String? = nil,
        onEmptyAction: (() -> Void)? = nil,
        errorActionTitle: String? = nil,
        onErrorAction: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) where Footer == EmptyView {
        self.init(
            environment: environment,
            title: title,
            subtitle: subtitle,
            state: state,
            emptyActionTitle: emptyActionTitle,
            onEmptyAction: onEmptyAction,
            errorActionTitle: errorActionTitle,
            onErrorAction: onErrorAction,
            topics: [],
            selectedTopicID: nil,
            content: content
        )
    }

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        topics: [HelpTopic] = [],
        selectedTopicID: Binding<String?>? = nil,
        @ViewBuilder content: () -> Content
    ) where Footer == EmptyView {
        self.init(
            environment: environment,
            title: title,
            subtitle: subtitle,
            state: .ready,
            emptyActionTitle: nil,
            onEmptyAction: nil,
            errorActionTitle: nil,
            onErrorAction: nil,
            topics: topics,
            selectedTopicID: selectedTopicID,
            content: content
        )
    }

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content
    ) where Footer == EmptyView {
        self.init(
            environment: environment,
            title: title,
            subtitle: subtitle,
            topics: [],
            selectedTopicID: nil,
            content: content
        )
    }

    public var body: some View {
        PanelSurface(environment: environment, title: title, subtitle: subtitle) {
            AsyncContentRenderer(
                environment: environment,
                state: state,
                emptyActionTitle: emptyActionTitle,
                onEmptyAction: onEmptyAction,
                errorActionTitle: errorActionTitle,
                onErrorAction: onErrorAction
            ) {
                if !topics.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Topics")
                            .font(environment.theme.typography(.captionStrong).font)
                            .foregroundStyle(environment.theme.color(.textSecondary))

                        ForEach(topics) { topic in
                            topicButton(topic)
                        }
                    }

                    Rectangle()
                        .fill(environment.theme.color(.subtleBorder))
                        .frame(height: 1)
                }

                content

                if showsFooter {
                    Rectangle()
                        .fill(environment.theme.color(.subtleBorder))
                        .frame(height: 1)

                    footer
                }
            }
        }
    }

    private var resolvedSelectedTopicID: String? {
        selectedTopicID?.wrappedValue ?? localSelectedTopicID ?? topics.first?.id
    }

    private func topicButton(_ topic: HelpTopic) -> some View {
        let isSelected = resolvedSelectedTopicID == topic.id
        let selectedMaterial = environment.theme.material(.selected)

        return Button {
            updateSelectedTopicID(topic.id)
        } label: {
            HStack(alignment: .top, spacing: 10) {
                if let symbol = topic.symbol {
                    Image(systemName: symbol)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(isSelected ? environment.theme.color(.accentPrimary) : environment.theme.color(.textSecondary))
                        .frame(width: 16)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(topic.title)
                        .font(environment.theme.typography(.bodyStrong).font)
                        .foregroundStyle(environment.theme.color(.textPrimary))

                    if let detail = topic.detail {
                        Text(detail)
                            .font(environment.theme.typography(.caption).font)
                            .foregroundStyle(environment.theme.color(.textSecondary))
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                    .fill(
                        isSelected
                        ? selectedMaterial.fill.opacity(selectedMaterial.fillOpacity)
                        : environment.theme.color(.inputSurface)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                    .stroke(isSelected ? environment.theme.color(.accentPrimary) : environment.theme.color(.subtleBorder), lineWidth: isSelected ? 1.5 : 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(topic.title)
        .accessibilityValue(isSelected ? "Selected" : "Available")
        .accessibilityHint("Open help topic")
    }

    private func updateSelectedTopicID(_ topicID: String?) {
        if let selectedTopicID {
            selectedTopicID.wrappedValue = topicID
        } else {
            localSelectedTopicID = topicID
        }
    }
}
