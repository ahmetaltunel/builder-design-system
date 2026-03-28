import BuilderReferenceExamples

package extension ComponentPreviewGroup {
    var exampleFamily: ComponentExampleFamily {
        switch self {
        case .shell: .shell
        case .toolbar: .toolbar
        case .navigation: .navigation
        case .form: .form
        case .selection: .selection
        case .feedback: .feedback
        case .overlay: .overlay
        case .content: .content
        case .data: .data
        case .ai: .ai
        case .tutorial: .tutorial
        case .utility: .utility
        case .specialized: .specialized
        }
    }
}

package extension PatternPreviewGroup {
    var exampleFamily: PatternExampleFamily {
        switch self {
        case .actionFlow: .actionFlow
        case .announcement: .announcement
        case .unsavedChanges: .unsavedChanges
        case .dataVisualization: .dataVisualization
        case .density: .density
        case .stateHandling: .stateHandling
        case .dragAndDrop: .dragAndDrop
        case .filtering: .filtering
        case .hero: .hero
        case .support: .support
        case .loading: .loading
        case .onboarding: .onboarding
        case .navigation: .navigation
        case .dashboard: .dashboard
        case .timeAndFeedback: .timeAndFeedback
        }
    }
}
