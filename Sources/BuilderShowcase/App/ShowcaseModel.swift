import Foundation
import SwiftUI
import BuilderDesignSystem
import BuilderCatalog

enum SearchDestination {
    case route(ShowcaseRoute)
    case foundation(FoundationTopic)
    case component(String)
    case recipe(String)
    case settings(SettingsSection)
}

struct SearchJumpItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let symbol: String
    let destination: SearchDestination
}

struct SearchJumpSection: Identifiable {
    let title: String
    let items: [SearchJumpItem]

    var id: String { title }
}

@MainActor
final class ShowcaseModel: ObservableObject {
    @Published var route: ShowcaseRoute = .home
    @Published var themeMode: ThemeMode = .dark
    @Published var themeContrast: ThemeContrast = .standard
    @Published var densityMode: DensityMode = .compact
    @Published var searchText = ""
    @Published var pendingFoundationTopic: FoundationTopic?
    @Published var pendingComponentID: String?
    @Published var pendingRecipeID: String?
    @Published var selectedSettingsSection: SettingsSection = .appearance
    @Published var reduceMotion = false
    @Published var highContrast = false

    var environment: DesignSystemEnvironment {
        DesignSystemEnvironment(
            theme: AppTheme(mode: themeMode, contrast: effectiveContrast),
            mode: themeMode,
            contrast: effectiveContrast,
            density: densityMode,
            visualContext: visualContext,
            reduceMotion: reduceMotion,
            highContrast: highContrast
        )
    }

    var effectiveContrast: ThemeContrast {
        highContrast ? .increased : themeContrast
    }

    var visualContext: VisualContext {
        switch route {
        case .home:
            .shell
        case .components:
            .editorComposer
        case .recipes:
            .dashboard
        case .foundations:
            .settings
        case .lab:
            .editorComposer
        case .settings:
            .settings
        }
    }

    func filteredComponents(category: ComponentCategory? = nil) -> [ComponentCatalogEntry] {
        let base = filter(items: CatalogContent.components) { component in
            component.name.localizedCaseInsensitiveContains(searchText) ||
            component.category.rawValue.localizedCaseInsensitiveContains(searchText) ||
            component.swiftUIType.localizedCaseInsensitiveContains(searchText)
        }

        guard let category else { return base }
        return base.filter { $0.category == category }
    }

    func filteredRecipes(category: PatternCategory? = nil) -> [PatternCatalogEntry] {
        let base = filter(items: CatalogContent.patterns) { pattern in
            pattern.name.localizedCaseInsensitiveContains(searchText) ||
            pattern.category.rawValue.localizedCaseInsensitiveContains(searchText) ||
            pattern.whenToUse.localizedCaseInsensitiveContains(searchText)
        }

        guard let category else { return base }
        return base.filter { $0.category == category }
    }

    func filteredFoundations() -> [FoundationDetail] {
        filter(items: CatalogContent.foundations) { detail in
            detail.topic.rawValue.localizedCaseInsensitiveContains(searchText) ||
            detail.summary.localizedCaseInsensitiveContains(searchText)
        }
    }

    var searchSections: [SearchJumpSection] {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }

        let routeMatches = ShowcaseRoute.primaryRoutes
            .filter { $0.title.localizedCaseInsensitiveContains(trimmed) }
            .map {
                SearchJumpItem(
                    id: "route-\($0.rawValue)",
                    title: $0.title,
                    subtitle: routeSubtitle(for: $0),
                    symbol: $0.symbol,
                    destination: .route($0)
                )
            }

        let foundationMatches = filteredFoundations().prefix(4).map {
            SearchJumpItem(
                id: "foundation-\($0.topic.id)",
                title: $0.topic.rawValue,
                subtitle: $0.summary,
                symbol: "square.stack.3d.up",
                destination: .foundation($0.topic)
            )
        }

        let componentMatches = filteredComponents().prefix(5).map {
            SearchJumpItem(
                id: "component-\($0.id)",
                title: $0.name,
                subtitle: $0.swiftUIType,
                symbol: "square.grid.3x3",
                destination: .component($0.id)
            )
        }

        let recipeMatches = filteredRecipes().prefix(4).map {
            SearchJumpItem(
                id: "recipe-\($0.id)",
                title: $0.name,
                subtitle: $0.category.rawValue,
                symbol: "square.on.square.squareshape.controlhandles",
                destination: .recipe($0.id)
            )
        }

        let settingsMatches = SettingsSection.allCases
            .filter { $0.title.localizedCaseInsensitiveContains(trimmed) || "settings".localizedCaseInsensitiveContains(trimmed) }
            .map {
                SearchJumpItem(
                    id: "settings-\($0.id)",
                    title: $0.title,
                    subtitle: "Open \(String(describing: $0.title).lowercased()) controls",
                    symbol: $0.symbol,
                    destination: .settings($0)
                )
            }

        return [
            SearchJumpSection(title: "Routes", items: routeMatches),
            SearchJumpSection(title: "Foundations", items: Array(foundationMatches)),
            SearchJumpSection(title: "Components", items: Array(componentMatches)),
            SearchJumpSection(title: "Recipes", items: Array(recipeMatches)),
            SearchJumpSection(title: "Settings", items: settingsMatches)
        ].filter { !$0.items.isEmpty }
    }

    func open(_ item: SearchJumpItem) {
        switch item.destination {
        case .route(let route):
            self.route = route
            searchText = ""
        case .foundation(let topic):
            pendingFoundationTopic = topic
            route = .foundations
            searchText = ""
        case .component(let id):
            pendingComponentID = id
            route = .components
            searchText = ""
        case .recipe(let id):
            pendingRecipeID = id
            route = .recipes
            searchText = ""
        case .settings(let section):
            selectedSettingsSection = section
            route = .settings
            searchText = ""
        }
    }

    private func filter<T>(items: [T], matches: (T) -> Bool) -> [T] {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return items }
        return items.filter(matches)
    }

    private func routeSubtitle(for route: ShowcaseRoute) -> String {
        switch route {
        case .home:
            "Launch and orient builders"
        case .components:
            "Browse components with a live canvas"
        case .recipes:
            "See composed application scenarios"
        case .foundations:
            "Inspect tokens, type, and materials"
        case .lab:
            "Compose product surfaces freely"
        case .settings:
            "Appearance, accessibility, and tokens"
        }
    }
}
