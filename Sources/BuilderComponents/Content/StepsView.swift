import SwiftUI
import BuilderFoundation

public struct StepsView: View {
    public struct Step: Identifiable, Hashable {
        public let id: String
        public let title: String
        public let detail: String?

        public init(id: String? = nil, title: String, detail: String? = nil) {
            self.id = id ?? title
            self.title = title
            self.detail = detail
        }
    }

    public let environment: DesignSystemEnvironment
    public let steps: [Step]
    public let currentStepID: String

    public init(environment: DesignSystemEnvironment, steps: [Step], currentStepID: String) {
        self.environment = environment
        self.steps = steps
        self.currentStepID = currentStepID
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                HStack(alignment: .top, spacing: 12) {
                    Circle()
                        .fill(step.id == currentStepID ? environment.theme.color(.accentPrimary) : environment.theme.color(.inputSurface))
                        .frame(width: 28, height: 28)
                        .overlay(
                            Text("\(index + 1)")
                                .font(environment.theme.typography(.caption).font.weight(.bold))
                                .foregroundStyle(step.id == currentStepID ? environment.theme.color(.textOnAccent) : environment.theme.color(.textSecondary))
                        )

                    VStack(alignment: .leading, spacing: 4) {
                        Text(step.title)
                            .font(environment.theme.typography(.bodyStrong).font)
                            .foregroundStyle(environment.theme.color(.textPrimary))
                        if let detail = step.detail {
                            Text(detail)
                                .font(environment.theme.typography(.caption).font)
                                .foregroundStyle(environment.theme.color(.textSecondary))
                        }
                    }
                }
            }
        }
    }
}
