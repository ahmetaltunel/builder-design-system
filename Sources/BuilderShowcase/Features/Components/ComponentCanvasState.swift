import Foundation
import BuilderDesignSystem
import BuilderCatalog

@MainActor
final class ComponentCanvasState: ObservableObject {
    enum PreviewPreset: String, CaseIterable, Identifiable {
        case live = "Live"
        case dense = "Dense"
        case contrast = "High contrast"

        var id: String { rawValue }
    }

    @Published var preset: PreviewPreset = .live
    @Published var selectedCategory: ComponentCategory? = nil
    @Published var showInspectorNotes = true
    @Published var showDisabledState = false
    @Published var showLoadingState = false
    @Published var showReadOnlyState = false
    @Published var showStateGallery = true

    var previewDensity: DensityMode {
        switch preset {
        case .live, .contrast:
            .default
        case .dense:
            .compact
        }
    }

    var previewContrast: ThemeContrast {
        preset == .contrast ? .increased : .standard
    }
}
