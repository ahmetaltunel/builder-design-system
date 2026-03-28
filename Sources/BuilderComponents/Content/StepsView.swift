import SwiftUI
import BuilderFoundation

public struct StepsView: View {
    public struct Step: Identifiable, Hashable, Sendable {
        public enum Status: Hashable, Sendable {
            case upcoming
            case current
            case complete
            case warning
        }

        public let id: String
        public let title: String
        public let detail: String?
        public let status: Status
        public let isOptional: Bool

        public init(
            id: String? = nil,
            title: String,
            detail: String? = nil,
            status: Status = .upcoming,
            isOptional: Bool = false
        ) {
            self.id = id ?? title
            self.title = title
            self.detail = detail
            self.status = status
            self.isOptional = isOptional
        }

        public init(id: String? = nil, title: String, detail: String? = nil) {
            self.init(
                id: id,
                title: title,
                detail: detail,
                status: .upcoming,
                isOptional: false
            )
        }
    }

    public let environment: DesignSystemEnvironment
    public let steps: [Step]
    public let currentStepID: String?

    public init(environment: DesignSystemEnvironment, steps: [Step], currentStepID: String) {
        self.environment = environment
        self.steps = steps
        self.currentStepID = currentStepID
    }

    public init(environment: DesignSystemEnvironment, steps: [Step]) {
        self.environment = environment
        self.steps = steps
        self.currentStepID = nil
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                let status = resolvedStepStatus(for: step, steps: steps, currentStepID: currentStepID)

                HStack(alignment: .top, spacing: 12) {
                    stepIndicator(index: index, status: status)

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(alignment: .center, spacing: 8) {
                            Text(step.title)
                                .font(environment.theme.typography(.bodyStrong).font)
                                .foregroundStyle(stepTitleColor(status))

                            if step.isOptional {
                                StatusBadge(
                                    environment: environment,
                                    label: "Optional",
                                    color: environment.theme.color(.textSecondary)
                                )
                            }
                        }

                        if let detail = step.detail {
                            Text(detail)
                                .font(environment.theme.typography(.caption).font)
                                .foregroundStyle(stepDetailColor(status))
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func stepIndicator(index: Int, status: Step.Status) -> some View {
        Circle()
            .fill(indicatorBackground(status))
            .frame(width: 28, height: 28)
            .overlay(
                Group {
                    switch status {
                    case .complete:
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                    case .warning:
                        Image(systemName: "exclamationmark")
                            .font(.system(size: 12, weight: .bold))
                    case .upcoming, .current:
                        Text("\(index + 1)")
                            .font(environment.theme.typography(.caption).font.weight(.bold))
                    }
                }
                .foregroundStyle(indicatorForeground(status))
            )
    }

    private func indicatorBackground(_ status: Step.Status) -> Color {
        switch status {
        case .current:
            environment.theme.color(.accentPrimary)
        case .complete:
            environment.theme.color(.success)
        case .warning:
            environment.theme.color(.warning)
        case .upcoming:
            environment.theme.color(.inputSurface)
        }
    }

    private func indicatorForeground(_ status: Step.Status) -> Color {
        switch status {
        case .upcoming:
            environment.theme.color(.textSecondary)
        case .current, .complete, .warning:
            environment.theme.color(.textOnAccent)
        }
    }

    private func stepTitleColor(_ status: Step.Status) -> Color {
        switch status {
        case .warning:
            environment.theme.color(.warning)
        case .upcoming, .current, .complete:
            environment.theme.color(.textPrimary)
        }
    }

    private func stepDetailColor(_ status: Step.Status) -> Color {
        switch status {
        case .warning:
            environment.theme.color(.warning)
        case .upcoming:
            environment.theme.color(.textMuted)
        case .current, .complete:
            environment.theme.color(.textSecondary)
        }
    }
}

func resolvedStepStatus(
    for step: StepsView.Step,
    steps: [StepsView.Step],
    currentStepID: String?
) -> StepsView.Step.Status {
    if step.status == .warning {
        return .warning
    }

    if step.status == .current || step.status == .complete {
        return step.status
    }

    guard
        let currentStepID,
        let currentIndex = steps.firstIndex(where: { $0.id == currentStepID }),
        let stepIndex = steps.firstIndex(where: { $0.id == step.id })
    else {
        return step.status
    }

    if step.id == currentStepID {
        return .current
    }

    if stepIndex < currentIndex {
        return .complete
    }

    return .upcoming
}
