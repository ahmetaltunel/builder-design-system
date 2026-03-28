import SwiftUI
import BuilderDesignSystem
import BuilderCatalog

struct ComponentsCatalogView: View {
    let env: DesignSystemEnvironment
    @EnvironmentObject private var model: ShowcaseModel
    @StateObject private var canvasState = ComponentCanvasState()
    @State private var selectedComponentID = CatalogContent.components.first?.id ?? ""

    var body: some View {
        VStack(spacing: 0) {
            ShowcaseRouteHeader(
                environment: env,
                eyebrow: "Component browser",
                title: "Browse components in a live workspace",
                subtitle: "Search the public component surface, switch preview presets, and inspect the semantic rules without leaving the canvas."
            ) {
                HStack(spacing: 10) {
                    TokenBadge(environment: env, title: "\(filteredComponents.count) results", tint: nil)
                    SystemButton(environment: env, title: "Open lab", tone: .secondary, leadingSymbol: "flask") {
                        model.route = .lab
                    }
                }
            }

            Rectangle()
                .fill(env.theme.color(.subtleBorder))
                .frame(height: 1)

            HStack(spacing: 0) {
                browserColumn

                Rectangle()
                    .fill(env.theme.color(.subtleBorder))
                    .frame(width: 1)

                canvasColumn

                Rectangle()
                    .fill(env.theme.color(.subtleBorder))
                    .frame(width: 1)

                inspectorColumn
            }
        }
        .onAppear(perform: syncSelection)
        .onChange(of: model.searchText) { _, _ in
            syncSelection()
        }
        .onChange(of: model.pendingComponentID) { _, _ in
            syncSelection()
        }
        .onChange(of: canvasState.selectedCategory?.rawValue) { _, _ in
            syncSelection()
        }
    }

    private var filteredComponents: [ComponentCatalogEntry] {
        model.filteredComponents(category: canvasState.selectedCategory)
    }

    private var selectedEntry: ComponentCatalogEntry {
        filteredComponents.first(where: { $0.id == selectedComponentID }) ?? filteredComponents.first ?? CatalogContent.components[0]
    }

    private var previewEnvironment: DesignSystemEnvironment {
        let previewContrast = canvasState.previewContrast == .increased ? ThemeContrast.increased : env.contrast
        return DesignSystemEnvironment(
            theme: AppTheme(mode: env.mode, contrast: previewContrast),
            mode: env.mode,
            contrast: previewContrast,
            density: canvasState.previewDensity,
            visualContext: .editorComposer,
            reduceMotion: env.reduceMotion,
            highContrast: env.highContrast || previewContrast == .increased
        )
    }

    private var browserColumn: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Browse")
                    .font(env.theme.typography(.labelStrong).font)
                    .foregroundStyle(env.theme.color(.textPrimary))

                SelectMenu(
                    environment: env,
                    options: [SelectMenu<ComponentCategory?>.Option(label: "All categories", value: nil)] + ComponentCategory.allCases.map {
                        .init(label: $0.rawValue, value: Optional($0))
                    },
                    selection: $canvasState.selectedCategory
                )

                Text(model.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Use the sidebar search to jump directly to a component." : "Filtered by \"\(model.searchText)\".")
                    .font(env.theme.typography(.caption).font)
                    .foregroundStyle(env.theme.color(.textMuted))
            }

            if filteredComponents.isEmpty {
                EmptyStateView(
                    environment: env,
                    title: "No components found",
                    message: "Clear the search or broaden the category filter to restore the full component surface.",
                    symbol: "square.grid.3x3",
                    actionTitle: "Clear filters"
                ) {
                    model.searchText = ""
                    canvasState.selectedCategory = nil
                }
            } else {
                NavigationBrowserList(
                    environment: env,
                    items: browserItems,
                    selection: $selectedComponentID,
                    rowHeight: 76
                ) { item, isSelected in
                    ComponentBrowserRow(environment: env, item: item, isSelected: isSelected)
                }
            }
        }
        .padding(22)
        .frame(width: 294)
    }

    private var canvasColumn: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HeaderBlock(environment: env, title: selectedEntry.name, subtitle: selectedEntry.summary) {
                    HStack(spacing: 10) {
                        StatusBadge(environment: env, label: selectedEntry.status.rawValue, color: statusColor(selectedEntry.status))
                        TokenBadge(environment: env, title: selectedEntry.category.rawValue, tint: nil)
                    }
                }

                HStack(spacing: 12) {
                    SegmentedPicker(
                        environment: env,
                        options: ComponentCanvasState.PreviewPreset.allCases.map { ($0.rawValue, $0) },
                        selection: $canvasState.preset,
                        style: .neutral
                    )
                    .frame(width: 260)

                    SystemButton(environment: env, title: "Inspect tokens", tone: .secondary, leadingSymbol: "paintpalette") {
                        model.selectedSettingsSection = .themeTokens
                        model.route = .settings
                    }
                }

                stateToolbar

                PreviewCanvasFrame(environment: previewEnvironment) {
                    ComponentPlaygroundView(entry: selectedEntry, env: previewEnvironment, canvasState: canvasState)
                }

                ShowcaseStatStrip(
                    environment: env,
                    items: [
                        ("States", "\(selectedEntry.states.count) documented"),
                        ("Tokens", "\(selectedEntry.designTokens.count) linked"),
                        ("Recipes", "\(selectedEntry.relatedPatterns.count) related")
                    ]
                )

                stateExercisePanel

                usagePanels
            }
            .padding(28)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private var inspectorColumn: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                ShowcaseInspectorSection(environment: env, title: "Anatomy") {
                    BulletList(environment: env, items: selectedEntry.anatomy)
                }

                Divider()
                    .overlay(env.theme.color(.subtleBorder))

                ShowcaseInspectorSection(environment: env, title: "Tokens") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 8)], spacing: 8) {
                        ForEach(selectedEntry.designTokens.prefix(10), id: \.self) { token in
                            TokenBadge(environment: env, title: token, tint: token.contains("accent") ? env.theme.color(.accentPrimary) : nil)
                        }
                    }
                }

                Divider()
                    .overlay(env.theme.color(.subtleBorder))

                ShowcaseInspectorSection(environment: env, title: "Accessibility", subtitle: selectedEntry.densityBehavior) {
                    BulletList(environment: env, items: selectedEntry.accessibility)
                }

                Divider()
                    .overlay(env.theme.color(.subtleBorder))

                ShowcaseInspectorSection(
                    environment: env,
                    title: "SwiftUI example",
                    subtitle: CatalogSnippetRegistry.componentSnippet(for: selectedEntry).summary
                ) {
                    snippetCard(CatalogSnippetRegistry.componentSnippet(for: selectedEntry).code)
                }

                Divider()
                    .overlay(env.theme.color(.subtleBorder))

                ShowcaseInspectorSection(environment: env, title: "Variants & states") {
                    VStack(alignment: .leading, spacing: 12) {
                        BulletList(environment: env, items: Array(selectedEntry.variants.prefix(4)))
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 112), spacing: 8)], spacing: 8) {
                            ForEach(selectedEntry.states, id: \.self) { state in
                                TokenBadge(environment: env, title: state, tint: tintForState(state))
                            }
                        }
                    }
                }

                Divider()
                    .overlay(env.theme.color(.subtleBorder))

                ShowcaseInspectorSection(environment: env, title: "Use carefully") {
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Do")
                                .font(env.theme.typography(.captionStrong).font)
                                .foregroundStyle(env.theme.color(.success))
                            BulletList(environment: env, items: Array(selectedEntry.dos.prefix(3)))
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Don't")
                                .font(env.theme.typography(.captionStrong).font)
                                .foregroundStyle(env.theme.color(.danger))
                            BulletList(environment: env, items: Array(selectedEntry.donts.prefix(3)))
                        }
                    }
                }

                if canvasState.showInspectorNotes {
                    Divider()
                        .overlay(env.theme.color(.subtleBorder))

                    ShowcaseInspectorSection(environment: env, title: "Implementation notes") {
                        BulletList(environment: env, items: Array(selectedEntry.engineeringNotes.prefix(4)))
                    }
                }

                Divider()
                    .overlay(env.theme.color(.subtleBorder))

                ShowcaseInspectorSection(environment: env, title: "Writing & platform notes") {
                    VStack(alignment: .leading, spacing: 12) {
                        BulletList(environment: env, items: Array(selectedEntry.writingGuidelines.prefix(3)))
                        BulletList(environment: env, items: Array(selectedEntry.macOSNotes.prefix(3)))
                    }
                }
            }
            .padding(22)
        }
        .frame(width: 330, alignment: .topLeading)
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .background(env.theme.color(.groupedSurface))
    }

    private func statusColor(_ status: ComponentStatus) -> Color {
        switch status {
        case .calibrated:
            env.theme.color(.accentPrimary)
        case .implemented:
            env.theme.color(.success)
        case .systemized:
            env.theme.color(.info)
        }
    }

    private func syncSelection() {
        guard !filteredComponents.isEmpty else {
            selectedComponentID = CatalogContent.components[0].id
            return
        }

        if let pendingID = model.pendingComponentID,
           filteredComponents.contains(where: { $0.id == pendingID }) {
            selectedComponentID = pendingID
            model.pendingComponentID = nil
            return
        }

        if !filteredComponents.contains(where: { $0.id == selectedComponentID }) {
            selectedComponentID = filteredComponents[0].id
        }
    }

    private var browserItems: [NavigationItem<String>] {
        filteredComponents.map {
            NavigationItem(
                id: $0.id,
                title: $0.name,
                subtitle: $0.swiftUIType
            )
        }
    }

    private var stateToolbar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ToggleButton(environment: env, title: "Disabled", isOn: $canvasState.showDisabledState)
                    .frame(width: 132)
                ToggleButton(environment: env, title: "Loading", isOn: $canvasState.showLoadingState)
                    .frame(width: 132)
                ToggleButton(environment: env, title: "Read-only", isOn: $canvasState.showReadOnlyState)
                    .frame(width: 142)
                ToggleButton(environment: env, title: "Docs notes", isOn: $canvasState.showInspectorNotes)
                    .frame(width: 138)
            }
        }
    }

    private var stateExercisePanel: some View {
        PanelSurface(
            environment: env,
            title: "State exercise",
            subtitle: "Check disabled, loading, and read-only behavior before treating the component as production ready."
        ) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 12) {
                    SystemButton(environment: env, title: "Primary action", tone: .primary, isEnabled: !canvasState.showDisabledState, isLoading: canvasState.showLoadingState) {}
                    SystemButton(environment: env, title: "Secondary action", tone: .secondary, isEnabled: !canvasState.showDisabledState) {}
                }

                TextInputField(
                    environment: env,
                    placeholder: "Component field",
                    text: .constant("Desktop builder surface"),
                    status: canvasState.showDisabledState ? .error : .normal,
                    message: canvasState.showDisabledState ? "Resolve validation before continuing." : "Fields should remain legible across states.",
                    isReadOnly: canvasState.showReadOnlyState,
                    isEnabled: !canvasState.showDisabledState
                )

                HStack(spacing: 12) {
                    SelectMenu(
                        environment: env,
                        options: [
                            .init(label: "Automatic", value: "automatic"),
                            .init(label: "Pinned", value: "pinned")
                        ],
                        selection: .constant("automatic"),
                        isEnabled: !canvasState.showDisabledState
                    )

                    ToggleSwitch(
                        environment: env,
                        title: "Keep inspector open",
                        isOn: .constant(true),
                        isEnabled: !canvasState.showDisabledState,
                        isLoading: canvasState.showLoadingState
                    )
                }

                if selectedEntry.category == .feedbackOverlay {
                    AlertBanner(
                        environment: env,
                        title: "Review required",
                        message: "Feedback components should keep action, dismissal, and status legible under stress.",
                        tone: canvasState.showDisabledState ? .warning : .info,
                        actionTitle: "Open details",
                        action: {},
                        isDismissible: true,
                        onDismiss: {}
                    )
                }

                ValidationSummary(
                    environment: env,
                    items: [
                        .init(id: "focus", title: "Focus visibility", detail: "Focused controls should remain visible in compact density.", status: canvasState.showDisabledState ? .warning : .success),
                        .init(id: "validation", title: "Validation clarity", detail: "Validation and helper messages should stay concise and tied to the control they explain.", status: canvasState.showReadOnlyState ? .warning : .success),
                        .init(id: "loading", title: "Loading continuity", detail: "Loading states should preserve layout and keep the primary action discoverable.", status: canvasState.showLoadingState ? .warning : .success)
                    ]
                )
            }
        }
    }

    private var usagePanels: some View {
        HStack(alignment: .top, spacing: 18) {
            PanelSurface(environment: env, title: "Usage guidance", subtitle: "The highest-value advice for applying this component in a desktop product.") {
                VStack(alignment: .leading, spacing: 14) {
                    ForEach(Array(selectedEntry.usage.prefix(3)), id: \.id) { guideline in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(guideline.title)
                                .font(env.theme.typography(.labelStrong).font)
                                .foregroundStyle(env.theme.color(.textPrimary))
                            Text(guideline.body)
                                .font(env.theme.typography(.body).font)
                                .foregroundStyle(env.theme.color(.textSecondary))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }

            PanelSurface(environment: env, title: "Related recipes", subtitle: "Composed scenarios where this component should show up naturally.") {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(selectedEntry.relatedPatterns, id: \.self) { pattern in
                        HStack(spacing: 10) {
                            Circle()
                                .fill(env.theme.color(.accentPrimary))
                                .frame(width: 6, height: 6)
                            Text(pattern)
                                .font(env.theme.typography(.body).font)
                                .foregroundStyle(env.theme.color(.textSecondary))
                            Spacer()
                        }
                    }
                }
            }
            .frame(maxWidth: 360)
        }
    }

    private func tintForState(_ state: String) -> Color? {
        let lower = state.lowercased()
        if lower.contains("error") || lower.contains("danger") { return env.theme.color(.danger) }
        if lower.contains("success") || lower.contains("ready") { return env.theme.color(.success) }
        if lower.contains("warning") { return env.theme.color(.warning) }
        if lower.contains("focus") || lower.contains("selected") || lower.contains("loading") { return env.theme.color(.accentPrimary) }
        return nil
    }

    private func snippetCard(_ code: String) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(code)
                .font(env.theme.typography(.monoCaption).font)
                .foregroundStyle(env.theme.color(.textSecondary))
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: env.theme.radius(.medium), style: .continuous)
                        .fill(env.theme.color(.insetSurface))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: env.theme.radius(.medium), style: .continuous)
                        .stroke(env.theme.color(.subtleBorder), lineWidth: 1)
                )
        }
    }
}

private struct ComponentBrowserRow: View {
    let environment: DesignSystemEnvironment
    let item: NavigationItem<String>
    let isSelected: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(isSelected ? environment.theme.color(.accentPrimary) : environment.theme.color(.textMuted))
                .frame(width: 8, height: 8)
                .padding(.top, 7)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(environment.theme.typography(.bodyStrong).font)
                    .foregroundStyle(environment.theme.color(.textPrimary))

                if let subtitle = item.subtitle {
                    Text(subtitle)
                        .font(environment.theme.typography(.caption).font)
                        .foregroundStyle(environment.theme.color(.textSecondary))
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                .fill(isSelected ? environment.theme.color(.selectedSurface) : .clear)
        )
        .contentShape(RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous))
    }
}
