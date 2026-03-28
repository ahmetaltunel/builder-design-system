import SwiftUI
import BuilderFoundation

public struct WizardLayout<Content: View>: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let steps: [StepsView.Step]
    public let currentStepID: String
    public let content: Content

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        steps: [StepsView.Step],
        currentStepID: String,
        @ViewBuilder content: () -> Content
    ) {
        self.environment = environment
        self.title = title
        self.steps = steps
        self.currentStepID = currentStepID
        self.content = content()
    }

    public var body: some View {
        ColumnLayout(environment: environment, secondaryWidth: 260) {
            PanelSurface(environment: environment, title: title) {
                content
            }
        } secondary: {
            PanelSurface(environment: environment, title: "Steps") {
                StepsView(environment: environment, steps: steps, currentStepID: currentStepID)
            }
        }
    }
}
