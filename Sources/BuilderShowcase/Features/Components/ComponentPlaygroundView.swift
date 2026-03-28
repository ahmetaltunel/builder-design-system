import SwiftUI
import BuilderDesignSystem
import BuilderCatalog
import BuilderReferenceExamples

struct ComponentPlaygroundView: View {
    let entry: ComponentCatalogEntry
    let env: DesignSystemEnvironment
    let canvasState: ComponentCanvasState?

    var body: some View {
        BuilderReferenceExamples.componentPreview(
            id: entry.canonicalExampleID,
            displayName: entry.name,
            family: entry.previewGroup.exampleFamily,
            environment: env,
            options: .init(
                showDisabledState: canvasState?.showDisabledState ?? false,
                showLoadingState: canvasState?.showLoadingState ?? false,
                showReadOnlyState: canvasState?.showReadOnlyState ?? false
            )
        )
    }
}
