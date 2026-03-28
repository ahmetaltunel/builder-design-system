import SwiftUI
import BuilderDesignSystem
import BuilderCatalog
import BuilderReferenceExamples

struct RecipesCatalogView: View {
    let env: DesignSystemEnvironment
    @EnvironmentObject private var model: ShowcaseModel
    @State private var selectedPatternID = CatalogContent.patterns.first?.id ?? ""

    var body: some View {
        VStack(spacing: 0) {
            ShowcaseRouteHeader(
                environment: env,
                eyebrow: "Recipes",
                title: "Compose realistic product scenarios",
                subtitle: "Use recipes to see how navigation, forms, feedback, tables, and onboarding behave together before you drop into the lab."
            ) {
                HStack(spacing: 10) {
                    TokenBadge(environment: env, title: activeScenario.title, tint: env.theme.color(.accentPrimary))
                    SystemButton(environment: env, title: "Open in lab", tone: .secondary, leadingSymbol: "flask") {
                        model.searchText = activeScenario.recommendedLabPreset.title
                        model.route = .lab
                    }
                }
            }

            Rectangle()
                .fill(env.theme.color(.subtleBorder))
                .frame(height: 1)

            HStack(spacing: 0) {
                recipeList

                Rectangle()
                    .fill(env.theme.color(.subtleBorder))
                    .frame(width: 1)

                recipeCanvas

                Rectangle()
                    .fill(env.theme.color(.subtleBorder))
                    .frame(width: 1)

                recipeInspector
            }
        }
        .onAppear(perform: syncSelection)
        .onChange(of: model.searchText) { _, _ in
            syncSelection()
        }
        .onChange(of: model.pendingRecipeID) { _, _ in
            syncSelection()
        }
    }

    private var filteredRecipes: [PatternCatalogEntry] {
        model.filteredRecipes()
    }

    private var selectedEntry: PatternCatalogEntry {
        filteredRecipes.first(where: { $0.id == selectedPatternID }) ?? filteredRecipes.first ?? CatalogContent.patterns[0]
    }

    private var activeScenario: RecipeScenario {
        switch selectedEntry.previewGroup {
        case .actionFlow, .hero:
            .launchFlow
        case .dataVisualization, .filtering, .dashboard, .density:
            .dataExplorer
        case .announcement, .timeAndFeedback, .unsavedChanges:
            .feedbackLoop
        case .onboarding:
            .onboardingTrack
        case .support, .navigation:
            .settingsStudio
        case .stateHandling, .dragAndDrop, .loading:
            .contentReview
        }
    }

    private var recipeList: some View {
        NavigationSidebarList(
            environment: env,
            sections: recipeSections,
            selection: $selectedPatternID,
            rowHeight: 58,
            sectionHeaderHeight: 28
        ) { item, isSelected in
            RecipeBrowserRow(environment: env, item: item, isSelected: isSelected)
        }
        .padding(22)
        .frame(width: 300)
    }

    private var recipeCanvas: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HeaderBlock(environment: env, title: selectedEntry.name, subtitle: activeScenario.subtitle) {
                    StatusBadge(environment: env, label: selectedEntry.category.rawValue, color: env.theme.color(.info))
                }

                PreviewCanvasFrame(environment: env) {
                    recipeScenarioCanvas
                }

                AlertBanner(
                    environment: env,
                    title: "Adapt this recipe",
                    message: "Use the live scenario as a compositional reference, then push the relevant preset into Lab when you want to adjust states, data, and density.",
                    tone: .info,
                    actionTitle: "Open in lab"
                ) {
                    model.searchText = activeScenario.recommendedLabPreset.title
                    model.route = .lab
                }
            }
            .padding(28)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    @ViewBuilder
    private var recipeScenarioCanvas: some View {
        BuilderReferenceExamples.patternPreview(
            id: selectedEntry.canonicalExampleID,
            displayName: selectedEntry.name,
            family: selectedEntry.previewGroup.exampleFamily,
            environment: env
        )
    }

    private var recipeInspector: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                ShowcaseInspectorSection(environment: env, title: "Scenario overview", subtitle: activeScenario.subtitle) {
                    Text(selectedEntry.whenToUse)
                        .font(env.theme.typography(.body).font)
                        .foregroundStyle(env.theme.color(.textSecondary))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Divider()
                    .overlay(env.theme.color(.subtleBorder))

                ShowcaseInspectorSection(environment: env, title: "Required components") {
                    BulletList(environment: env, items: selectedEntry.requiredComponents)
                }

                Divider()
                    .overlay(env.theme.color(.subtleBorder))

                ShowcaseInspectorSection(environment: env, title: "Adaptation notes") {
                    VStack(alignment: .leading, spacing: 12) {
                        BulletList(environment: env, items: Array(selectedEntry.criteria.prefix(3)))
                        BulletList(environment: env, items: Array(selectedEntry.configurations.prefix(3)))
                    }
                }

                Divider()
                    .overlay(env.theme.color(.subtleBorder))

                ShowcaseInspectorSection(environment: env, title: "Accessibility & tone") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(selectedEntry.copyTone)
                            .font(env.theme.typography(.body).font)
                            .foregroundStyle(env.theme.color(.textSecondary))
                        BulletList(environment: env, items: Array(selectedEntry.accessibilityAndMotion.prefix(3)))
                    }
                }

                Divider()
                    .overlay(env.theme.color(.subtleBorder))

                ShowcaseInspectorSection(
                    environment: env,
                    title: "SwiftUI example",
                    subtitle: CatalogSnippetRegistry.patternSnippet(for: selectedEntry).summary
                ) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        Text(CatalogSnippetRegistry.patternSnippet(for: selectedEntry).code)
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
            .padding(22)
        }
        .frame(width: 330, alignment: .topLeading)
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .background(env.theme.color(.groupedSurface))
    }

    private func recipeCard(title: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(env.theme.typography(.labelStrong).font)
                .foregroundStyle(env.theme.color(.textPrimary))
            Text(detail)
                .font(env.theme.typography(.body).font)
                .foregroundStyle(env.theme.color(.textSecondary))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: env.theme.radius(.large), style: .continuous)
                .fill(env.theme.color(.groupedSurface))
        )
        .overlay(
            RoundedRectangle(cornerRadius: env.theme.radius(.large), style: .continuous)
                .stroke(env.theme.color(.subtleBorder), lineWidth: 1)
        )
    }

    private func settingsRow<Content: View>(title: String, detail: String, @ViewBuilder content: () -> Content) -> some View {
        SettingsRow(environment: env, title: title, detail: detail) {
            content()
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(env.theme.color(.subtleBorder))
            .frame(height: 1)
    }

    private func scenarioSubtitle(for entry: PatternCatalogEntry) -> String {
        let scenario = activeScenarioFor(entry)
        return scenario.subtitle
    }

    private func activeScenarioFor(_ entry: PatternCatalogEntry) -> RecipeScenario {
        switch entry.previewGroup {
        case .actionFlow, .hero:
            .launchFlow
        case .dataVisualization, .filtering, .dashboard, .density:
            .dataExplorer
        case .announcement, .timeAndFeedback, .unsavedChanges:
            .feedbackLoop
        case .onboarding:
            .onboardingTrack
        case .support, .navigation:
            .settingsStudio
        case .stateHandling, .dragAndDrop, .loading:
            .contentReview
        }
    }

    private func syncSelection() {
        guard !filteredRecipes.isEmpty else {
            selectedPatternID = CatalogContent.patterns[0].id
            return
        }

        if let pendingID = model.pendingRecipeID,
           filteredRecipes.contains(where: { $0.id == pendingID }) {
            selectedPatternID = pendingID
            model.pendingRecipeID = nil
            return
        }

        if !filteredRecipes.contains(where: { $0.id == selectedPatternID }) {
            selectedPatternID = filteredRecipes[0].id
        }
    }

    private var recipeSections: [NavigationSection<String>] {
        let grouped = Dictionary(grouping: filteredRecipes, by: \.category)
        return PatternCategory.allCases.compactMap { category in
            guard let items = grouped[category], !items.isEmpty else { return nil }

            return NavigationSection(
                id: category.id,
                title: category.rawValue,
                items: items.map {
                    NavigationItem(
                        id: $0.id,
                        title: $0.name,
                        subtitle: scenarioSubtitle(for: $0)
                    )
                }
            )
        }
    }
}

private struct RecipeBrowserRow: View {
    let environment: DesignSystemEnvironment
    let item: NavigationItem<String>
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
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
