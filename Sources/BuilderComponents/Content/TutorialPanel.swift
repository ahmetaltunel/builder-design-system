import SwiftUI
import BuilderFoundation
import BuilderBehaviors

public struct TutorialPanel<Content: View>: View {
    public typealias StepAnnouncement = (StepsView.Step, Int, Int) -> String

    public let environment: DesignSystemEnvironment
    public let title: String
    public let subtitle: String?
    public let state: AsyncContentState
    public let emptyActionTitle: String?
    public let onEmptyAction: (() -> Void)?
    public let errorActionTitle: String?
    public let onErrorAction: (() -> Void)?
    public let steps: [StepsView.Step]
    public let completedStepIDs: Set<String>
    public let stepChangeAnnouncement: StepAnnouncement?
    public let content: Content
    public let primaryActions: AnyView?
    public let secondaryActions: AnyView?
    public let showsPrimaryActions: Bool
    public let showsSecondaryActions: Bool

    private let initialCurrentStepID: String
    public let currentStepIDBinding: Binding<String>?

    @State private var liveAnnouncement: String?

    public var currentStepID: String {
        currentStepIDBinding?.wrappedValue ?? initialCurrentStepID
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
        self.completedStepIDs = []
        self.stepChangeAnnouncement = nil
        self.content = content()
        self.primaryActions = nil
        self.secondaryActions = nil
        self.showsPrimaryActions = false
        self.showsSecondaryActions = false
        self.initialCurrentStepID = currentStepID
        self.currentStepIDBinding = nil
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
        currentStepID: Binding<String>,
        completedStepIDs: Set<String> = [],
        stepChangeAnnouncement: StepAnnouncement? = nil,
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
        self.completedStepIDs = completedStepIDs
        self.stepChangeAnnouncement = stepChangeAnnouncement
        self.content = content()
        self.primaryActions = nil
        self.secondaryActions = nil
        self.showsPrimaryActions = false
        self.showsSecondaryActions = false
        self.initialCurrentStepID = currentStepID.wrappedValue
        self.currentStepIDBinding = currentStepID
    }

    public init<PrimaryActions: View, SecondaryActions: View>(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        state: AsyncContentState = .ready,
        emptyActionTitle: String? = nil,
        onEmptyAction: (() -> Void)? = nil,
        errorActionTitle: String? = nil,
        onErrorAction: (() -> Void)? = nil,
        steps: [StepsView.Step],
        currentStepID: Binding<String>,
        completedStepIDs: Set<String> = [],
        stepChangeAnnouncement: StepAnnouncement? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder primaryActions: () -> PrimaryActions,
        @ViewBuilder secondaryActions: () -> SecondaryActions
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
        self.completedStepIDs = completedStepIDs
        self.stepChangeAnnouncement = stepChangeAnnouncement
        self.content = content()
        self.primaryActions = AnyView(primaryActions())
        self.secondaryActions = AnyView(secondaryActions())
        self.showsPrimaryActions = true
        self.showsSecondaryActions = true
        self.initialCurrentStepID = currentStepID.wrappedValue
        self.currentStepIDBinding = currentStepID
    }

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        state: AsyncContentState = .ready,
        controller: TutorialFlowController,
        emptyActionTitle: String? = nil,
        onEmptyAction: (() -> Void)? = nil,
        errorActionTitle: String? = nil,
        onErrorAction: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
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
            steps: controller.steps.map(Self.step(for:)),
            currentStepID: Binding(
                get: { controller.currentStepID },
                set: { controller.selectStep($0) }
            ),
            completedStepIDs: controller.completedStepIDs,
            stepChangeAnnouncement: nil,
            content: content
        )
    }

    public init<PrimaryActions: View, SecondaryActions: View>(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        state: AsyncContentState = .ready,
        controller: TutorialFlowController,
        emptyActionTitle: String? = nil,
        onEmptyAction: (() -> Void)? = nil,
        errorActionTitle: String? = nil,
        onErrorAction: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder primaryActions: () -> PrimaryActions,
        @ViewBuilder secondaryActions: () -> SecondaryActions
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
            steps: controller.steps.map(Self.step(for:)),
            currentStepID: Binding(
                get: { controller.currentStepID },
                set: { controller.selectStep($0) }
            ),
            completedStepIDs: controller.completedStepIDs,
            stepChangeAnnouncement: nil,
            content: content,
            primaryActions: primaryActions,
            secondaryActions: secondaryActions
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

                StepsView(environment: environment, steps: presentedSteps)

                Rectangle()
                    .fill(environment.theme.color(.subtleBorder))
                    .frame(height: 1)

                content

                if showsPrimaryActions || showsSecondaryActions {
                    Rectangle()
                        .fill(environment.theme.color(.subtleBorder))
                        .frame(height: 1)

                    HStack(alignment: .center, spacing: 10) {
                        if showsSecondaryActions, let secondaryActions {
                            secondaryActions
                        }

                        Spacer(minLength: 0)

                        if showsPrimaryActions, let primaryActions {
                            primaryActions
                        }
                    }
                }

                if let liveAnnouncement, !liveAnnouncement.isEmpty {
                    AccessibilityAnnouncementRegion(message: liveAnnouncement)
                }
            }
        }
        .onChange(of: currentStepID) { _, _ in
            announceCurrentStepChange()
        }
    }

    private static func step(for tutorialStep: TutorialStep) -> StepsView.Step {
        StepsView.Step(
            id: tutorialStep.id,
            title: tutorialStep.title,
            detail: tutorialStep.detail,
            status: {
                switch tutorialStep.status {
                case .upcoming:
                    .upcoming
                case .current:
                    .current
                case .complete:
                    .complete
                case .warning:
                    .warning
                }
            }(),
            isOptional: tutorialStep.isOptional
        )
    }

    private var presentedSteps: [StepsView.Step] {
        steps.map { step in
            StepsView.Step(
                id: step.id,
                title: step.title,
                detail: step.detail,
                status: resolvedTutorialStepStatus(for: step),
                isOptional: step.isOptional
            )
        }
    }

    private var currentStepNumber: Int {
        guard let index = steps.firstIndex(where: { $0.id == currentStepID }) else { return 1 }
        return index + 1
    }

    private var currentStep: StepsView.Step? {
        steps.first(where: { $0.id == currentStepID }) ?? steps.first
    }

    private func resolvedTutorialStepStatus(for step: StepsView.Step) -> StepsView.Step.Status {
        if step.status == .warning {
            return .warning
        }

        if step.id == currentStepID {
            return .current
        }

        if completedStepIDs.contains(step.id) {
            return .complete
        }

        return resolvedStepStatus(for: step, steps: steps, currentStepID: currentStepID)
    }

    private func announceCurrentStepChange() {
        guard state.isReady, let currentStep else { return }

        let message = stepChangeAnnouncement?(
            currentStep,
            currentStepNumber,
            max(steps.count, 1)
        ) ?? "Step \(currentStepNumber) of \(max(steps.count, 1)). \(currentStep.title)."

        liveAnnouncement = message
        postAccessibilityAnnouncement(message)
    }
}
