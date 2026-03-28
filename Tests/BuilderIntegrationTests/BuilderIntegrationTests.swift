import Foundation
import SwiftUI
import XCTest
import BuilderFoundation
import BuilderComponents
import BuilderDesignSystem
import BuilderCatalog
@testable import BuilderShowcase

@MainActor
final class BuilderIntegrationTests: XCTestCase {
    func testUmbrellaImportExposesFoundationAndComponents() {
        let environment = DesignSystemEnvironment(
            theme: AppTheme(mode: .dark, contrast: .standard),
            mode: .dark,
            contrast: .standard,
            density: .default,
            visualContext: .shell,
            reduceMotion: false,
            highContrast: false
        )

        let surface = PanelSurface(environment: environment, title: "Surface") {
            Text("Body")
        }
        let button = SystemButton(environment: environment, title: "Action") {}

        XCTAssertEqual(surface.title, "Surface")
        XCTAssertEqual(button.title, "Action")
    }

    func testRepositoryIncludesCurrentCoreArtifacts() {
        assertFilesExist([
            "README.md",
            "Package.swift",
            "LICENSE",
            ".gitignore",
            "DesignTokens/design-token-manifest.json",
            "Scripts/validate-design-system.sh",
            "Docs/System/Handbook.md",
            "Docs/System/QualityBar.md",
            "Docs/System/ContentGuidelines.md",
            "Docs/System/TokenReference.md",
            "Docs/Foundations/README.md",
            "Docs/Components/README.md",
            "Docs/Patterns/README.md",
            "Docs/Governance/README.md",
            "Docs/Governance/AccessibilityChecklist.md",
            "Docs/Showcase/Guide.md",
            "Exports/design-tokens.json",
            "Tests/BuilderIntegrationTests/__Snapshots__/showcase-home-dark.png",
            "Tests/BuilderIntegrationTests/__Snapshots__/showcase-components-dark.png"
        ])
    }

    func testDesignTokenExportParsesAndIncludesExpectedSections() throws {
        let data = try Data(contentsOf: repositoryRoot().appendingPathComponent("Exports/design-tokens.json"))
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])

        XCTAssertNotNil(json["themes"])
        XCTAssertNotNil(json["spacing"])
        XCTAssertNotNil(json["radius"])
        XCTAssertNotNil(json["motion"])
        XCTAssertNotNil(json["motionCurves"])
        XCTAssertNotNil(json["shadows"])
        XCTAssertNotNil(json["icons"])
        XCTAssertNotNil(json["grids"])
        XCTAssertNotNil(json["tokens"])
    }

    func testPackageManifestUsesNewStructure() throws {
        let packageContents = try String(contentsOf: repositoryRoot().appendingPathComponent("Package.swift"), encoding: .utf8)

        for expected in ["BuilderFoundation", "BuilderComponents", "BuilderDesignSystem", "BuilderReferenceExamples", "BuilderCatalog", "BuilderShowcase"] {
            XCTAssertTrue(packageContents.contains(expected), "Package.swift is missing \(expected)")
        }

        XCTAssertFalse(packageContents.contains(".library(\n            name: \"BuilderFoundation\""), "BuilderFoundation should remain an internal module boundary, not a published package product")
        XCTAssertFalse(packageContents.contains(".library(\n            name: \"BuilderComponents\""), "BuilderComponents should remain an internal module boundary, not a published package product")

        for forbidden in ["BuilderStarterSystem", "BuilderStarterDemo", "BuilderStarterTests"] {
            XCTAssertFalse(packageContents.contains(forbidden), "Package.swift still references \(forbidden)")
        }
    }

    func testLegacyFoldersAreRemoved() {
        let root = repositoryRoot()
        XCTAssertFalse(FileManager.default.fileExists(atPath: root.appendingPathComponent("Sources/BuilderStarterSystem").path))
        XCTAssertFalse(FileManager.default.fileExists(atPath: root.appendingPathComponent("Sources/BuilderStarterDemo").path))
        XCTAssertFalse(FileManager.default.fileExists(atPath: root.appendingPathComponent("Tests/BuilderStarterTests").path))
    }

    func testBuilderComponentsSurfaceIsBroadAndStructured() throws {
        let root = repositoryRoot().appendingPathComponent("Sources/BuilderComponents")
        let fileManager = FileManager.default

        let files = try fileManager.subpathsOfDirectory(atPath: root.path)
            .filter { $0.hasSuffix(".swift") }

        XCTAssertGreaterThanOrEqual(files.count, 80)

        for required in [
            "Surfaces/AppLayout.swift",
            "Surfaces/AppLayoutToolbar.swift",
            "Navigation/NavigationItem.swift",
            "Navigation/NavigationSection.swift",
            "Navigation/NavigationBrowserList.swift",
            "Navigation/NavigationSidebarList.swift",
            "Navigation/Tabs.swift",
            "Controls/Checkbox.swift",
            "Controls/MultiselectMenu.swift",
            "Controls/CopyToClipboardButton.swift",
            "Forms/TextAreaField.swift",
            "Forms/AttributeEditor.swift",
            "Feedback/AlertBanner.swift",
            "Content/DataTable.swift",
            "Content/ChartPanel.swift",
            "Content/Board.swift"
        ] {
            XCTAssertTrue(files.contains(required), "Missing expected BuilderComponents file: \(required)")
        }
    }

    func testShowcaseRouteModelMatchesBuilderSandboxIA() {
        XCTAssertEqual(ShowcaseRoute.primaryRoutes.map(\.rawValue), ["home", "components", "recipes", "foundations", "lab"])
        XCTAssertEqual(ShowcaseRoute.primaryRoutes.map(\.title), ["Home", "Components", "Recipes", "Foundations", "Lab"])
        XCTAssertFalse(ShowcaseRoute.primaryRoutes.contains(.settings))
    }

    func testShowcaseNavigationUsesNativeListsInsteadOfPanelLevelMoveCommands() throws {
        let root = repositoryRoot()
        let files = [
            "Sources/BuilderShowcase/App/ShowcaseRootView.swift",
            "Sources/BuilderShowcase/Features/Components/ComponentsCatalogView.swift",
            "Sources/BuilderShowcase/Features/Recipes/RecipesCatalogView.swift",
            "Sources/BuilderShowcase/Features/Foundations/FoundationsCatalogView.swift",
            "Sources/BuilderShowcase/Features/Settings/SettingsCatalogView.swift"
        ]

        for file in files {
            let contents = try String(contentsOf: root.appendingPathComponent(file), encoding: .utf8)
            XCTAssertFalse(contents.contains(".focusable()"), "\(file) should not use panel-level focusable navigation")
            XCTAssertFalse(contents.contains(".onMoveCommand"), "\(file) should not use panel-level move command handlers")
        }
    }

    func testPrimarySidebarUsesExplicitActivationPath() throws {
        let contents = try String(
            contentsOf: repositoryRoot().appendingPathComponent("Sources/BuilderShowcase/App/ShowcaseRootView.swift"),
            encoding: .utf8
        )

        XCTAssertTrue(contents.contains("NavigationSidebarList("))
        XCTAssertTrue(contents.contains("onActivate:"), "Primary sidebar should commit route changes through explicit activation, not only selection drift")
        XCTAssertTrue(contents.contains("activatePrimaryRoute"), "Primary sidebar activation should route through the shared route activation helper")
        XCTAssertTrue(contents.contains("Binding<ShowcaseRoute?>"), "Primary sidebar selection should allow no selection while Settings is active")
        XCTAssertTrue(contents.contains("sidebarFocusRequest += 1"), "Showcase should hand initial focus to the main sidebar instead of leaving focus in the search field")
    }

    func testValidationScriptRunsGeneratorBuildAndTests() throws {
        let contents = try String(
            contentsOf: repositoryRoot().appendingPathComponent("Scripts/validate-design-system.sh"),
            encoding: .utf8
        )

        XCTAssertTrue(contents.contains("swift run BuilderArtifactGenerator"))
        XCTAssertTrue(contents.contains("swift build"))
        XCTAssertTrue(contents.contains("swift test"))
    }

    func testSettingsSectionsUseUtilityLanguage() {
        XCTAssertEqual(SettingsSection.allCases.map(\.rawValue), ["appearance", "accessibility", "themeTokens"])
        XCTAssertEqual(SettingsSection.allCases.map(\.title), ["Appearance", "Accessibility", "Theme & tokens"])
    }

    func testShowcaseAppIconFactoryProducesImage() {
        let image = ShowcaseAppIcon.makeIcon(size: 256)
        XCTAssertEqual(image.size.width, 256)
        XCTAssertEqual(image.size.height, 256)
    }

    func testSearchJumpOpenNavigatesToComponentRoute() {
        let model = ShowcaseModel()
        let firstComponent = CatalogContent.components[0]

        model.open(
            SearchJumpItem(
                id: "component-\(firstComponent.id)",
                title: firstComponent.name,
                subtitle: firstComponent.swiftUIType,
                symbol: "square.grid.3x3",
                destination: .component(firstComponent.id)
            )
        )

        XCTAssertEqual(model.route, .components)
        XCTAssertEqual(model.pendingComponentID, firstComponent.id)
        XCTAssertEqual(model.searchText, "")
    }

    func testSearchSectionsReturnResultsForTextQuery() {
        let model = ShowcaseModel()
        model.searchText = "text"

        let sections = model.searchSections

        XCTAssertFalse(sections.isEmpty)
        XCTAssertTrue(
            sections.contains { section in
                section.title == "Components" && section.items.contains { $0.title.localizedCaseInsensitiveContains("Text") }
            },
            "Search should surface text-related component matches in the overlay"
        )
    }

    func testSearchJumpOpenNavigatesToSettingsSection() {
        let model = ShowcaseModel()

        model.open(
            SearchJumpItem(
                id: "settings-themeTokens",
                title: "Theme & tokens",
                subtitle: "Open theme inspection controls",
                symbol: "paintpalette",
                destination: .settings(.themeTokens)
            )
        )

        XCTAssertEqual(model.route, .settings)
        XCTAssertEqual(model.selectedSettingsSection, .themeTokens)
    }

    func testSearchJumpOpenNavigatesToFoundationTopicWithoutKeepingSidebarSearchOpen() {
        let model = ShowcaseModel()
        let topic = CatalogContent.foundations[0].topic

        model.open(
            SearchJumpItem(
                id: "foundation-\(topic.id)",
                title: topic.rawValue,
                subtitle: "Foundation topic",
                symbol: "square.stack.3d.up",
                destination: .foundation(topic)
            )
        )

        XCTAssertEqual(model.route, .foundations)
        XCTAssertEqual(model.pendingFoundationTopic, topic)
        XCTAssertEqual(model.searchText, "")
    }

    func testShowcaseViewsRenderAcrossPrimaryRoutesAndThemes() {
        let dark = ShowcaseModel()
        dark.themeMode = .dark

        let light = ShowcaseModel()
        light.themeMode = .light

        XCTAssertNotNil(renderedImage(for: HomeView(env: dark.environment).environmentObject(dark), size: CGSize(width: 1280, height: 900)))
        XCTAssertNotNil(renderedImage(for: ComponentsCatalogView(env: dark.environment).environmentObject(dark), size: CGSize(width: 1400, height: 900)))
        XCTAssertNotNil(renderedImage(for: FoundationsCatalogView(env: dark.environment).environmentObject(dark), size: CGSize(width: 1400, height: 900)))
        XCTAssertNotNil(renderedImage(for: SettingsCatalogView(env: dark.environment).environmentObject(dark), size: CGSize(width: 1400, height: 900)))

        light.selectedSettingsSection = .themeTokens
        XCTAssertNotNil(renderedImage(for: HomeView(env: light.environment).environmentObject(light), size: CGSize(width: 1280, height: 900)))
        XCTAssertNotNil(renderedImage(for: ComponentsCatalogView(env: light.environment).environmentObject(light), size: CGSize(width: 1400, height: 900)))
        XCTAssertNotNil(renderedImage(for: FoundationsCatalogView(env: light.environment).environmentObject(light), size: CGSize(width: 1400, height: 900)))
        XCTAssertNotNil(renderedImage(for: SettingsCatalogView(env: light.environment).environmentObject(light), size: CGSize(width: 1400, height: 900)))
    }

    private func repositoryRoot() -> URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }

    private func assertFilesExist(
        _ relativePaths: [String],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let root = repositoryRoot()
        let fileManager = FileManager.default

        for relativePath in relativePaths {
            let path = root.appendingPathComponent(relativePath).path
            XCTAssertTrue(fileManager.fileExists(atPath: path), "Missing required repo artifact: \(relativePath)", file: file, line: line)
        }
    }

    private func renderedImage<V: View>(for view: V, size: CGSize) -> NSImage? {
        let renderer = ImageRenderer(content: view.frame(width: size.width, height: size.height))
        renderer.scale = 1
        renderer.proposedSize = .init(size)
        return renderer.nsImage
    }
}
