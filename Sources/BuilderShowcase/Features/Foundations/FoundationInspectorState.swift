import Foundation
import BuilderDesignSystem

@MainActor
final class FoundationInspectorState: ObservableObject {
    enum ThemePreviewMode: String, CaseIterable, Identifiable {
        case current = "Current"
        case compare = "Compare"

        var id: String { rawValue }
    }

    @Published var previewMode: ThemePreviewMode = .compare
    @Published var selectedMaterial: MaterialToken = .panel
    @Published var selectedTypography: TypographyToken = .pageTitle
    @Published var selectedIcon: IconToken = .navigationPrimary
    @Published var selectedGrid: GridToken = .content
    @Published var selectedShadow: ShadowToken = .raised
    @Published var selectedMotionCurve: MotionCurveToken = .standard
}
