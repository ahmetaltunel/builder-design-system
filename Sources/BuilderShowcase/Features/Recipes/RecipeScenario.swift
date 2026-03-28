import Foundation

enum RecipeScenario: String, CaseIterable, Identifiable {
    case launchFlow = "Launch flow"
    case settingsStudio = "Settings studio"
    case dataExplorer = "Data explorer"
    case feedbackLoop = "Feedback loop"
    case onboardingTrack = "Onboarding track"
    case contentReview = "Content review"

    var id: String { rawValue }

    var title: String { rawValue }

    var subtitle: String {
        switch self {
        case .launchFlow:
            "A focused starting surface with clear next actions."
        case .settingsStudio:
            "Grouped settings, quiet labels, and strong control rhythm."
        case .dataExplorer:
            "Filters, tables, charts, and secondary context working together."
        case .feedbackLoop:
            "Status, notices, and response states in one operating surface."
        case .onboardingTrack:
            "Structured entry points for guided setup and completion."
        case .contentReview:
            "A mixed review surface for approval, inline feedback, and content status."
        }
    }

    var recommendedLabPreset: LabPreset {
        switch self {
        case .launchFlow:
            .editorWorkspace
        case .settingsStudio:
            .settingsForm
        case .dataExplorer:
            .dataExplorer
        case .feedbackLoop:
            .contentReview
        case .onboardingTrack:
            .onboardingFlow
        case .contentReview:
            .contentReview
        }
    }
}
