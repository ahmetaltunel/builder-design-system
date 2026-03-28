import Foundation
import BuilderDesignSystem

enum LabPreset: String, CaseIterable, Identifiable {
    case settingsForm = "Settings form"
    case dataExplorer = "Data explorer"
    case editorWorkspace = "Editor workspace"
    case onboardingFlow = "Onboarding flow"
    case contentReview = "Content review"

    var id: String { rawValue }

    var title: String { rawValue }

    var subtitle: String {
        switch self {
        case .settingsForm:
            "Test grouped settings rows and control alignment."
        case .dataExplorer:
            "Stress charts, tables, filters, and inspector context."
        case .editorWorkspace:
            "Exercise shell, content editor, and secondary actions."
        case .onboardingFlow:
            "Try step-by-step progress, guidance, and confirmation states."
        case .contentReview:
            "Mix feedback, lists, and approval actions in one screen."
        }
    }

    var visualContext: VisualContext {
        switch self {
        case .settingsForm:
            .settings
        case .dataExplorer:
            .dataTable
        case .editorWorkspace:
            .editorComposer
        case .onboardingFlow:
            .onboarding
        case .contentReview:
            .dashboard
        }
    }

    var symbol: String {
        switch self {
        case .settingsForm:
            "slider.horizontal.3"
        case .dataExplorer:
            "chart.bar.xaxis"
        case .editorWorkspace:
            "sidebar.left"
        case .onboardingFlow:
            "list.number"
        case .contentReview:
            "checklist"
        }
    }
}
