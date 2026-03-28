import SwiftUI
import BuilderFoundation

public struct TutorialPanel<Content: View>: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let subtitle: String?
    public let state: AsyncContentState
    public let emptyActionTitle: String?
    public let onEmptyAction: (() -> Void)?
    public let errorActionTitle: String?
    public let onErrorAction: (() -> Void)?
    public let steps: [StepsView.Step]
    public let currentStepID: String
    public let content: Content

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        state: AsyncContentState = .ready,
        emptyActionTitle: String? = nil,
        onEmptyAction: (() -> Void)? = nil,
        errorActionTitle: String? = nil,
        onErrorAction: (() -> Void)? = nil,
        steps: [StepsView.Step],
        currentStepID: String,
        @ViewBuilder content: () -> Content
    ) {
        self.environment = environment
        self.title = title
        self.subtitle = subtitle
        self.state = state
        self.emptyActionTitle = emptyActionTitle
        self.onEmptyAction = onEmptyAction
        self.errorActionTitle = errorActionTitle
        self.onErrorAction = onErrorAction
        self.steps = steps
        self.currentStepID = currentStepID
        self.content = content()
    }

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        steps: [StepsView.Step],
        currentStepID: String,
        @ViewBuilder content: () -> Content
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
            steps: steps,
            currentStepID: currentStepID,
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
                HStack(spacing: 10) {
                    StatusBadge(
                        environment: environment,
                        label: "Step \(currentStepNumber) of \(max(steps.count, 1))",
                        color: environment.theme.color(.accentPrimary)
                    )

                    if let currentStep {
                        Text(currentStep.title)
                            .font(environment.theme.typography(.bodyStrong).font)
                            .foregroundStyle(environment.theme.color(.textPrimary))
                    }
                }

                StepsView(environment: environment, steps: steps, currentStepID: currentStepID)

                Rectangle()
                    .fill(environment.theme.color(.subtleBorder))
                    .frame(height: 1)

                content
            }
        }
    }

    private var currentStepNumber: Int {
        guard let index = steps.firstIndex(where: { $0.id == currentStepID }) else { return 1 }
        return index + 1
    }

    private var currentStep: StepsView.Step? {
        steps.first(where: { $0.id == currentStepID })
    }
}
