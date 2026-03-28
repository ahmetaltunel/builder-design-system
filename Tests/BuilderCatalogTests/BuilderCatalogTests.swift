import Foundation
import XCTest
import BuilderFoundation
@testable import BuilderCatalog

final class BuilderCatalogTests: XCTestCase {
    func testFoundationsTaxonomyIsComplete() {
        let expected = Set([
            "Visual foundation",
            "Colors",
            "Content density",
            "Data visualization colors",
            "Design tokens",
            "Iconography",
            "Layout",
            "Materials",
            "Motion",
            "Spacing",
            "Theming",
            "Typography",
            "Visual context",
            "Visual modes",
            "Visual style"
        ])

        XCTAssertEqual(Set(CatalogContent.foundations.map(\.topic.rawValue)), expected)
    }

    func testComponentTaxonomyMatchesRequestedInventory() {
        let expected = Set([
            "Alert",
            "Anchor navigation",
            "App layout",
            "App layout toolbar",
            "Attribute editor",
            "Autosuggest",
            "Badge",
            "Board",
            "Box",
            "Breadcrumb group",
            "Button",
            "Button dropdown",
            "Button group",
            "Calendar",
            "Cards",
            "Charts",
            "Checkbox",
            "Code editor",
            "Code view",
            "View preferences",
            "Filter select",
            "Column layout",
            "Container",
            "Content layout",
            "Copy to clipboard",
            "Date input",
            "Date picker",
            "Date range picker",
            "Drawer",
            "Error boundary",
            "Expandable section",
            "File uploading components",
            "Notice stack",
            "Form",
            "Form field",
            "Generative AI components",
            "Grid",
            "Header",
            "Context panel",
            "Icon",
            "Input",
            "Key-value pairs",
            "Link",
            "List",
            "Live region",
            "Modal",
            "Multiselect",
            "Pagination",
            "Panel layout",
            "Popover",
            "Progress bar",
            "Property filter",
            "Radio group",
            "Resource selector",
            "Segmented control",
            "Select",
            "Side navigation",
            "Slider",
            "Space between",
            "Spinner",
            "Split panel",
            "Status indicator",
            "Steps",
            "Table",
            "Tabs",
            "Tag editor",
            "Text content",
            "Text filter",
            "Text area",
            "Tiles",
            "Time input",
            "Toggle",
            "Toggle button",
            "Token",
            "Token group",
            "Top navigation",
            "Tree view",
            "Tutorial components",
            "Wizard"
        ])

        XCTAssertEqual(Set(CatalogContent.components.map(\.name)), expected)
        XCTAssertEqual(CatalogContent.components.count, expected.count)
    }

    func testPatternTaxonomyMatchesRequestedInventory() {
        let expected = Set([
            "General",
            "Actions",
            "Announcing new features",
            "Announcing beta and preview features",
            "Communicating unsaved changes",
            "Data visualization",
            "Density settings",
            "Disabled and read-only states",
            "Drag-and-drop",
            "Errors",
            "Empty states",
            "Feedback mechanisms",
            "Filtering patterns",
            "Hero header",
            "Help system",
            "Image magnifier",
            "Loading and refreshing",
            "Onboarding",
            "Selection in forms",
            "Workspace navigation",
            "Workspace dashboard",
            "Secondary panels",
            "Timestamps",
            "User feedback"
        ])

        XCTAssertEqual(Set(CatalogContent.patterns.map(\.name)), expected)
        XCTAssertEqual(CatalogContent.patterns.count, expected.count)
    }

    func testCrossReferenceIsGeneratedForEveryComponent() {
        XCTAssertEqual(CatalogContent.componentCrossReference.count, CatalogContent.components.count)
        XCTAssertTrue(CatalogContent.componentCrossReference.contains { $0.catalog == "App layout" && $0.swiftUI == "AppLayoutView" })
        XCTAssertTrue(CatalogContent.componentCrossReference.contains { $0.catalog == "Generative AI components" && $0.swiftUI == "GenerativeAIComponentsView" })
    }

    func testCatalogEntriesCarryDocumentationFields() {
        for component in CatalogContent.components {
            XCTAssertFalse(component.designTokens.isEmpty, "\(component.name) is missing design token references")
            XCTAssertFalse(component.dos.isEmpty, "\(component.name) is missing do guidance")
            XCTAssertFalse(component.donts.isEmpty, "\(component.name) is missing don't guidance")
            XCTAssertFalse(component.relatedPatterns.isEmpty, "\(component.name) is missing related patterns")
            XCTAssertFalse(component.writingGuidelines.isEmpty, "\(component.name) is missing writing guidelines")
            XCTAssertFalse(component.engineeringNotes.isEmpty, "\(component.name) is missing engineering notes")
            XCTAssertFalse(component.structuredContent.actionLabels.isEmpty, "\(component.name) is missing action label guidance")
            XCTAssertFalse(component.structuredContent.localization.isEmpty, "\(component.name) is missing localization guidance")
            XCTAssertFalse(component.structuredContent.terminology.isEmpty, "\(component.name) is missing terminology guidance")
            XCTAssertTrue(component.accessibilityAcceptance.isComplete, "\(component.name) should carry a complete accessibility acceptance contract")
            XCTAssertFalse(component.canonicalExampleID.rawValue.isEmpty, "\(component.name) is missing a canonical example id")
        }

        for pattern in CatalogContent.patterns {
            XCTAssertFalse(pattern.criteria.isEmpty, "\(pattern.name) is missing criteria")
            XCTAssertFalse(pattern.configurations.isEmpty, "\(pattern.name) is missing configurations")
            XCTAssertFalse(pattern.generalGuidelines.isEmpty, "\(pattern.name) is missing general guidelines")
            XCTAssertFalse(pattern.relatedPatterns.isEmpty, "\(pattern.name) is missing related patterns")
            XCTAssertFalse(pattern.contentGuidance.isEmpty, "\(pattern.name) is missing structured content guidance")
            XCTAssertFalse(pattern.structuredContent.actionLabels.isEmpty, "\(pattern.name) is missing action label guidance")
            XCTAssertFalse(pattern.structuredContent.localization.isEmpty, "\(pattern.name) is missing localization guidance")
            XCTAssertFalse(pattern.structuredContent.terminology.isEmpty, "\(pattern.name) is missing terminology guidance")
            XCTAssertTrue(pattern.accessibilityAcceptance.isComplete, "\(pattern.name) should carry a complete accessibility acceptance contract")
            XCTAssertFalse(pattern.canonicalExampleID.rawValue.isEmpty, "\(pattern.name) is missing a canonical example id")
        }
    }

    func testCanonicalExampleIDsAreExactAndUnique() {
        let componentIDs = CatalogContent.components.map(\.canonicalExampleID.rawValue)
        XCTAssertEqual(Set(componentIDs).count, componentIDs.count, "Component canonical example ids must be unique")

        for component in CatalogContent.components {
            XCTAssertEqual(
                component.canonicalExampleID.rawValue,
                slug(for: component.name),
                "\(component.name) should use an exact slug-backed canonical example id"
            )
        }

        let patternIDs = CatalogContent.patterns.map(\.canonicalExampleID.rawValue)
        XCTAssertEqual(Set(patternIDs).count, patternIDs.count, "Pattern canonical example ids must be unique")

        for pattern in CatalogContent.patterns {
            XCTAssertEqual(
                pattern.canonicalExampleID.rawValue,
                slug(for: pattern.name),
                "\(pattern.name) should use an exact slug-backed canonical example id"
            )
        }
    }

    func testRepositorySurfaceAvoidsDeprecatedTerminology() throws {
        let root = repositoryRoot()
        let banned = [
            "BuilderStarter",
            "BuilderStarterSystem",
            "BuilderStarterDemo",
            "BuilderUIKit",
            "Cloud" + "scape",
            "Co" + "d" + "ex",
            "Reference" + " Screens",
            "New" + " thread"
        ]

        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(
            at: root,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles],
            errorHandler: nil
        )

        while let file = enumerator?.nextObject() as? URL {
            guard ["swift", "md", "json"].contains(file.pathExtension) else { continue }
            guard !file.path.contains("/.build/") else { continue }
            guard !file.path.contains("/Tests/") else { continue }

            let contents = try String(contentsOf: file, encoding: .utf8)
            for term in banned {
                XCTAssertFalse(contents.contains(term), "Found banned term '\(term)' in \(file.path)")
            }
        }
    }

    func testGeneratedReferenceDocsExistForEveryCatalogEntry() {
        let root = repositoryRoot()
        let fileManager = FileManager.default

        XCTAssertTrue(fileManager.fileExists(atPath: root.appendingPathComponent("Docs/System/TokenReference.md").path))
        XCTAssertTrue(fileManager.fileExists(atPath: root.appendingPathComponent("Docs/Foundations/README.md").path))
        XCTAssertTrue(fileManager.fileExists(atPath: root.appendingPathComponent("Docs/Components/README.md").path))
        XCTAssertTrue(fileManager.fileExists(atPath: root.appendingPathComponent("Docs/Patterns/README.md").path))

        for foundation in CatalogContent.foundations {
            let path = root.appendingPathComponent("Docs/Foundations/\(slug(for: foundation.topic.rawValue)).md").path
            XCTAssertTrue(fileManager.fileExists(atPath: path), "Missing generated foundation doc for \(foundation.topic.rawValue)")
        }

        for component in CatalogContent.components {
            let path = root.appendingPathComponent("Docs/Components/\(slug(for: component.name)).md").path
            XCTAssertTrue(fileManager.fileExists(atPath: path), "Missing generated component doc for \(component.name)")
        }

        for pattern in CatalogContent.patterns {
            let path = root.appendingPathComponent("Docs/Patterns/\(slug(for: pattern.name)).md").path
            XCTAssertTrue(fileManager.fileExists(atPath: path), "Missing generated pattern doc for \(pattern.name)")
        }
    }

    func testCatalogSnippetRegistryProvidesCanonicalExamples() {
        for component in CatalogContent.components {
            let snippet = CatalogSnippetRegistry.componentSnippet(for: component)
            XCTAssertFalse(snippet.title.isEmpty, "\(component.name) is missing snippet title")
            XCTAssertFalse(snippet.summary.isEmpty, "\(component.name) is missing snippet summary")
            XCTAssertTrue(snippet.title.localizedCaseInsensitiveContains(component.name), "\(component.name) snippet title should be component specific")
            XCTAssertTrue(snippet.code.contains("DesignSystemEnvironment.preview"), "\(component.name) snippet should use preview environment")
            XCTAssertTrue(snippet.code.contains("environment:"), "\(component.name) snippet should demonstrate environment injection")
            XCTAssertTrue(snippet.code.contains("Canonical example for \(component.name)"), "\(component.name) snippet should be sourced from the exact canonical example")
        }

        for pattern in CatalogContent.patterns {
            let snippet = CatalogSnippetRegistry.patternSnippet(for: pattern)
            XCTAssertFalse(snippet.title.isEmpty, "\(pattern.name) is missing snippet title")
            XCTAssertFalse(snippet.summary.isEmpty, "\(pattern.name) is missing snippet summary")
            XCTAssertTrue(snippet.title.localizedCaseInsensitiveContains(pattern.name), "\(pattern.name) pattern snippet title should be pattern specific")
            XCTAssertTrue(snippet.code.contains("environment"), "\(pattern.name) pattern snippet should demonstrate environment-backed composition")
            XCTAssertTrue(snippet.code.contains("Canonical example for \(pattern.name)"), "\(pattern.name) pattern snippet should be sourced from the exact canonical example")
        }
    }

    func testGeneratedDocsIncludeCanonicalExampleSections() throws {
        let root = repositoryRoot()

        for component in CatalogContent.components.prefix(5) {
            let contents = try String(
                contentsOf: root.appendingPathComponent("Docs/Components/\(slug(for: component.name)).md"),
                encoding: .utf8
            )
            XCTAssertTrue(contents.contains("## SwiftUI Example"), "\(component.name) doc should include a SwiftUI example section")
            XCTAssertTrue(contents.contains("## Accessibility Acceptance"), "\(component.name) doc should include accessibility acceptance")
            XCTAssertTrue(contents.contains("### Action labels"), "\(component.name) doc should include structured action label guidance")
            XCTAssertTrue(contents.contains("### Localization"), "\(component.name) doc should include structured localization guidance")
        }

        for pattern in CatalogContent.patterns.prefix(5) {
            let contents = try String(
                contentsOf: root.appendingPathComponent("Docs/Patterns/\(slug(for: pattern.name)).md"),
                encoding: .utf8
            )
            XCTAssertTrue(contents.contains("## Content Guidance"), "\(pattern.name) doc should include content guidance")
            XCTAssertTrue(contents.contains("## Accessibility Acceptance"), "\(pattern.name) doc should include accessibility acceptance")
            XCTAssertTrue(contents.contains("### Action labels"), "\(pattern.name) doc should include structured action label guidance")
            XCTAssertTrue(contents.contains("### Localization"), "\(pattern.name) doc should include structured localization guidance")
        }
    }

    func testGeneratedFoundationDocsCarryDeepGeneratedReferenceSections() throws {
        let root = repositoryRoot()

        let iconography = try String(
            contentsOf: root.appendingPathComponent("Docs/Foundations/iconography.md"),
            encoding: .utf8
        )
        XCTAssertTrue(iconography.contains("## Generated Icon Roles"))

        let layout = try String(
            contentsOf: root.appendingPathComponent("Docs/Foundations/layout.md"),
            encoding: .utf8
        )
        XCTAssertTrue(layout.contains("## Generated Grid Specs"))

        let motion = try String(
            contentsOf: root.appendingPathComponent("Docs/Foundations/motion.md"),
            encoding: .utf8
        )
        XCTAssertTrue(motion.contains("## Generated Motion Curves"))

        let materials = try String(
            contentsOf: root.appendingPathComponent("Docs/Foundations/materials.md"),
            encoding: .utf8
        )
        XCTAssertTrue(materials.contains("## Elevation And Shadow Relationships"))
    }

    func testGeneratedDocsUseExactCanonicalSnippetsInsteadOfFamilyFallbacks() throws {
        let root = repositoryRoot()

        let button = try String(
            contentsOf: root.appendingPathComponent("Docs/Components/button.md"),
            encoding: .utf8
        )
        XCTAssertTrue(button.contains("SystemButton(environment: environment"))
        XCTAssertFalse(button.contains("Checkbox(environment: environment"))

        let checkbox = try String(
            contentsOf: root.appendingPathComponent("Docs/Components/checkbox.md"),
            encoding: .utf8
        )
        XCTAssertTrue(checkbox.contains("Checkbox(environment: environment"))

        let workspaceNavigation = try String(
            contentsOf: root.appendingPathComponent("Docs/Patterns/workspace-navigation.md"),
            encoding: .utf8
        )
        XCTAssertTrue(workspaceNavigation.contains("NavigationSidebarList(environment: environment"))
        XCTAssertTrue(workspaceNavigation.contains("SplitPanel(environment: environment)"))

        let densitySettings = try String(
            contentsOf: root.appendingPathComponent("Docs/Patterns/density-settings.md"),
            encoding: .utf8
        )
        XCTAssertTrue(densitySettings.contains("SegmentedPicker(environment: environment"))
    }

    private func repositoryRoot() -> URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }

    private func slug(for text: String) -> String {
        text.lowercased()
            .replacingOccurrences(of: "&", with: "and")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "/", with: "-")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "-")
    }
}
