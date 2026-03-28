import Foundation
import BuilderCatalog

private struct Manifest: Decodable {
    struct Tokens: Decodable {
        struct ColorEntry: Decodable {
            let `case`: String
            let raw: String
        }

        let color: [ColorEntry]
        let typography: [String]
        let spacing: [String]
        let radius: [String]
        let motion: [String]
        let motionCurve: [String]
        let elevation: [String]
        let shadow: [String]
        let material: [String]
        let icon: [String]
        let grid: [String]
    }

    struct MotionCurveEntry: Decodable {
        let name: String
        let points: [Double]
        let notes: String
    }

    struct ShadowValue: Decodable {
        let color: String
        let radius: Double
        let x: Double
        let y: Double
    }

    struct ShadowEntry: Decodable {
        let light: ShadowValue
        let dark: ShadowValue
        let description: String
    }

    struct TypographyEntry: Decodable {
        let size: Double
        let weight: String
        let tracking: Double
        let lineHeight: Double
        let monospaced: Bool
    }

    struct MaterialTranslucency: Decodable {
        let light: Bool
        let dark: Bool
    }

    struct MaterialEntry: Decodable {
        let fill: String
        let border: String
        let elevation: String
        let radius: String
        let opacity: Double
        let translucent: MaterialTranslucency
        let interactive: Bool
    }

    struct IconEntry: Decodable {
        let symbol: String
        let pointSize: Double
        let weight: String
        let semanticRole: String
    }

    struct GridEntry: Decodable {
        let columns: Int
        let gutter: Double
        let margin: Double
        let maxWidth: Double?
        let description: String
    }

    let tokens: Tokens
    let themes: [String: [String: String]]
    let spacing: [String: Double]
    let radius: [String: Double]
    let motion: [String: Double]
    let motionCurves: [String: MotionCurveEntry]
    let elevations: [String: String]
    let shadows: [String: ShadowEntry]
    let typography: [String: TypographyEntry]
    let materials: [String: MaterialEntry]
    let icons: [String: IconEntry]
    let grids: [String: GridEntry]
}

private enum GeneratorError: Error {
    case missingRoot
}

@main
struct BuilderArtifactGenerator {
    static func main() throws {
        let fileManager = FileManager.default
        let root = URL(fileURLWithPath: fileManager.currentDirectoryPath)
        guard fileManager.fileExists(atPath: root.appendingPathComponent("Package.swift").path) else {
            throw GeneratorError.missingRoot
        }

        let manifestURL = root.appendingPathComponent("DesignTokens/design-token-manifest.json")
        let manifestData = try Data(contentsOf: manifestURL)
        let manifest = try JSONDecoder().decode(Manifest.self, from: manifestData)

        try generateTokenFiles(from: manifest, root: root)
        try generateRegistry(from: manifest, root: root)
        try exportManifest(manifestData, root: root)
        try generateTokenReference(from: manifest, root: root)
        try generateFoundationDocs(from: manifest, root: root)
        try generateComponentDocs(root: root)
        try generatePatternDocs(root: root)
    }

    private static func generateTokenFiles(from manifest: Manifest, root: URL) throws {
        let tokensRoot = root.appendingPathComponent("Sources/BuilderFoundation/Tokens")

        try write(
            enumFile(
                name: "ColorToken",
                cases: manifest.tokens.color.map { ($0.case, $0.raw) }
            ),
            to: tokensRoot.appendingPathComponent("ColorToken.swift")
        )
        try write(enumFile(name: "TypographyToken", cases: manifest.tokens.typography.map { ($0, nil) }), to: tokensRoot.appendingPathComponent("TypographyToken.swift"))
        try write(enumFile(name: "SpacingToken", cases: manifest.tokens.spacing.map { ($0, nil) }), to: tokensRoot.appendingPathComponent("SpacingToken.swift"))
        try write(enumFile(name: "RadiusToken", cases: manifest.tokens.radius.map { ($0, nil) }), to: tokensRoot.appendingPathComponent("RadiusToken.swift"))
        try write(enumFile(name: "MotionToken", cases: manifest.tokens.motion.map { ($0, nil) }), to: tokensRoot.appendingPathComponent("MotionToken.swift"))
        try write(enumFile(name: "MotionCurveToken", cases: manifest.tokens.motionCurve.map { ($0, nil) }), to: tokensRoot.appendingPathComponent("MotionCurveToken.swift"))
        try write(enumFile(name: "ElevationToken", cases: manifest.tokens.elevation.map { ($0, nil) }), to: tokensRoot.appendingPathComponent("ElevationToken.swift"))
        try write(enumFile(name: "ShadowToken", cases: manifest.tokens.shadow.map { ($0, nil) }), to: tokensRoot.appendingPathComponent("ShadowToken.swift"))
        try write(enumFile(name: "MaterialToken", cases: manifest.tokens.material.map { ($0, nil) }), to: tokensRoot.appendingPathComponent("MaterialToken.swift"))
        try write(enumFile(name: "IconToken", cases: manifest.tokens.icon.map { ($0, nil) }), to: tokensRoot.appendingPathComponent("IconToken.swift"))
        try write(enumFile(name: "GridToken", cases: manifest.tokens.grid.map { ($0, nil) }), to: tokensRoot.appendingPathComponent("GridToken.swift"))
    }

    private static func generateRegistry(from manifest: Manifest, root: URL) throws {
        let output = root.appendingPathComponent("Sources/BuilderFoundation/Generated/DesignTokenRegistry.generated.swift")
        try write(renderRegistry(manifest), to: output)
    }

    private static func exportManifest(_ manifestData: Data, root: URL) throws {
        let object = try JSONSerialization.jsonObject(with: manifestData)
        let exported = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys])
        let exportURL = root.appendingPathComponent("Exports/design-tokens.json")
        try exported.write(to: exportURL)
    }

    private static func generateTokenReference(from manifest: Manifest, root: URL) throws {
        let body = """
        # Token Reference

        This file is generated from `DesignTokens/design-token-manifest.json`.

        ## Token counts

        - Colors: \(manifest.tokens.color.count)
        - Typography: \(manifest.tokens.typography.count)
        - Spacing: \(manifest.tokens.spacing.count)
        - Radius: \(manifest.tokens.radius.count)
        - Motion durations: \(manifest.tokens.motion.count)
        - Motion curves: \(manifest.tokens.motionCurve.count)
        - Elevation roles: \(manifest.tokens.elevation.count)
        - Shadow roles: \(manifest.tokens.shadow.count)
        - Material roles: \(manifest.tokens.material.count)
        - Icon roles: \(manifest.tokens.icon.count)
        - Grid roles: \(manifest.tokens.grid.count)

        ## Colors

        | Token | Raw value |
        | --- | --- |
        \(manifest.tokens.color.map { "| `\($0.case)` | `\($0.raw)` |" }.joined(separator: "\n"))

        ## Typography

        | Token | Size | Weight | Line height |
        | --- | --- | --- | --- |
        \(manifest.tokens.typography.map { token in
            let spec = manifest.typography[token]!
            return "| `\(token)` | \(Int(spec.size)) | \(spec.weight) | \(Int(spec.lineHeight)) |"
        }.joined(separator: "\n"))

        ## Materials

        | Token | Fill | Border | Elevation | Radius |
        | --- | --- | --- | --- | --- |
        \(manifest.tokens.material.map { token in
            let spec = manifest.materials[token]!
            return "| `\(token)` | `\(spec.fill)` | `\(spec.border)` | `\(spec.elevation)` | `\(spec.radius)` |"
        }.joined(separator: "\n"))

        ## Shadows

        | Token | Description |
        | --- | --- |
        \(manifest.tokens.shadow.map { token in
            let spec = manifest.shadows[token]!
            return "| `\(token)` | \(spec.description) |"
        }.joined(separator: "\n"))

        ## Elevation relationships

        | Elevation | Shadow token |
        | --- | --- |
        \(manifest.tokens.elevation.map { token in
            let shadow = manifest.elevations[token]!
            return "| `\(token)` | `\(shadow)` |"
        }.joined(separator: "\n"))

        ## Motion curves

        | Token | Curve | Notes |
        | --- | --- | --- |
        \(manifest.tokens.motionCurve.map { token in
            let spec = manifest.motionCurves[token]!
            let points = spec.points.map { String(format: "%.2f", $0) }.joined(separator: ", ")
            return "| `\(token)` | `[\(points)]` | \(escapePipes(spec.notes)) |"
        }.joined(separator: "\n"))

        ## Icon roles

        | Token | Symbol | Point size | Role |
        | --- | --- | --- | --- |
        \(manifest.tokens.icon.map { token in
            let spec = manifest.icons[token]!
            return "| `\(token)` | `\(spec.symbol)` | \(Int(spec.pointSize)) | \(escapePipes(spec.semanticRole)) |"
        }.joined(separator: "\n"))

        ## Grid specs

        | Token | Columns | Gutter | Margin | Max width |
        | --- | --- | --- | --- | --- |
        \(manifest.tokens.grid.map { token in
            let spec = manifest.grids[token]!
            let maxWidth = spec.maxWidth.map { String(Int($0)) } ?? "Flexible"
            return "| `\(token)` | \(spec.columns) | \(Int(spec.gutter)) | \(Int(spec.margin)) | \(maxWidth) |"
        }.joined(separator: "\n"))
        """

        try write(body + "\n", to: root.appendingPathComponent("Docs/System/TokenReference.md"))
    }

    private static func generateFoundationDocs(from manifest: Manifest, root: URL) throws {
        try ensureDirectory(root.appendingPathComponent("Docs/Foundations"))

        let index = """
        # Foundations

        Generated foundation reference pages. These documents are produced from the catalog and token manifest so the handbook, exports, and showcase stay aligned.

        \(CatalogContent.foundations.map { "- [\($0.topic.rawValue)](\(slug($0.topic.rawValue)).md)" }.joined(separator: "\n"))
        """
        try write(index + "\n", to: root.appendingPathComponent("Docs/Foundations/README.md"))

        for detail in CatalogContent.foundations {
            let page = """
            # \(detail.topic.rawValue)

            \(detail.summary)

            ## Calibration Notes

            \(detail.calibrationNotes.map { "- \($0)" }.joined(separator: "\n"))

            ## Implementation Guidelines

            \(detail.implementationGuidelines.map { "- \($0)" }.joined(separator: "\n"))

            ## Token References

            \(detail.tokenReferences.map { "- `\($0)`" }.joined(separator: "\n"))

            \(foundationAppendix(for: detail.topic, manifest: manifest))
            """
            try write(page + "\n", to: root.appendingPathComponent("Docs/Foundations/\(slug(detail.topic.rawValue)).md"))
        }
    }

    private static func generateComponentDocs(root: URL) throws {
        try ensureDirectory(root.appendingPathComponent("Docs/Components"))

        let index = """
        # Components

        Generated component reference pages sourced from `BuilderCatalog`.

        \(CatalogContent.components.map { "- [\($0.name)](\($0.id).md)" }.joined(separator: "\n"))
        """
        try write(index + "\n", to: root.appendingPathComponent("Docs/Components/README.md"))

        for entry in CatalogContent.components {
            let snippet = CatalogSnippetRegistry.componentSnippet(for: entry)
            let page = """
            # \(entry.name)

            \(entry.summary)

            ## When To Use

            \(entry.usage.map { "- **\($0.title):** \($0.body)" }.joined(separator: "\n"))

            ## Anatomy

            \(entry.anatomy.map { "- \($0)" }.joined(separator: "\n"))

            ## Variants

            \(entry.variants.map { "- \($0)" }.joined(separator: "\n"))

            ## States

            \(entry.states.map { "- \($0)" }.joined(separator: "\n"))

            ## Density Behavior

            \(entry.densityBehavior)

            ## Accessibility

            \(entry.accessibility.map { "- \($0)" }.joined(separator: "\n"))

            ## Accessibility Acceptance

            - Semantics: \(entry.accessibilityAcceptance.semantics ? "Pass" : "Pending")
            - Keyboard: \(entry.accessibilityAcceptance.keyboard ? "Pass" : "Pending")
            - Contrast: \(entry.accessibilityAcceptance.contrast ? "Pass" : "Pending")
            - Motion: \(entry.accessibilityAcceptance.motion ? "Pass" : "Pending")
            - Messaging: \(entry.accessibilityAcceptance.messaging ? "Pass" : "Pending")

            ## Content Guidance

            \(entry.writingGuidelines.map { "- \($0)" }.joined(separator: "\n"))

            \(renderStructuredContent(entry.structuredContent))

            ## Tokens

            \(entry.designTokens.map { "- `\($0)`" }.joined(separator: "\n"))

            ## Platform Notes

            \(entry.macOSNotes.map { "- \($0)" }.joined(separator: "\n"))

            ## Do

            \(entry.dos.map { "- \($0)" }.joined(separator: "\n"))

            ## Don't

            \(entry.donts.map { "- \($0)" }.joined(separator: "\n"))

            ## SwiftUI Example

            **\(snippet.title)**  
            \(snippet.summary)

            ```swift
            \(snippet.code)
            ```
            """
            try write(page + "\n", to: root.appendingPathComponent("Docs/Components/\(entry.id).md"))
        }
    }

    private static func generatePatternDocs(root: URL) throws {
        try ensureDirectory(root.appendingPathComponent("Docs/Patterns"))

        let index = """
        # Patterns

        Generated pattern reference pages sourced from `BuilderCatalog`.

        \(CatalogContent.patterns.map { "- [\($0.name)](\($0.id).md)" }.joined(separator: "\n"))
        """
        try write(index + "\n", to: root.appendingPathComponent("Docs/Patterns/README.md"))

        for entry in CatalogContent.patterns {
            let snippet = CatalogSnippetRegistry.patternSnippet(for: entry)
            let page = """
            # \(entry.name)

            ## Problem

            \(entry.whenToUse)

            ## When To Use

            \(entry.criteria.map { "- \($0)" }.joined(separator: "\n"))

            ## Required Components

            \(entry.requiredComponents.map { "- \($0)" }.joined(separator: "\n"))

            ## Layout Recipe

            \(entry.layoutRecipe.map { "- \($0)" }.joined(separator: "\n"))

            ## Accessibility & Motion

            \(entry.accessibilityAndMotion.map { "- \($0)" }.joined(separator: "\n"))

            ## Copy Tone

            \(entry.copyTone)

            ## Content Guidance

            \(entry.contentGuidance.map { "- \($0)" }.joined(separator: "\n"))

            \(renderStructuredContent(entry.structuredContent))

            ## Configurations

            \(entry.configurations.map { "- \($0)" }.joined(separator: "\n"))

            ## Related Patterns

            \(entry.relatedPatterns.map { "- \($0)" }.joined(separator: "\n"))

            ## Accessibility Acceptance

            - Semantics: \(entry.accessibilityAcceptance.semantics ? "Pass" : "Pending")
            - Keyboard: \(entry.accessibilityAcceptance.keyboard ? "Pass" : "Pending")
            - Contrast: \(entry.accessibilityAcceptance.contrast ? "Pass" : "Pending")
            - Motion: \(entry.accessibilityAcceptance.motion ? "Pass" : "Pending")
            - Messaging: \(entry.accessibilityAcceptance.messaging ? "Pass" : "Pending")

            ## SwiftUI Example

            **\(snippet.title)**  
            \(snippet.summary)

            ```swift
            \(snippet.code)
            ```
            """
            try write(page + "\n", to: root.appendingPathComponent("Docs/Patterns/\(entry.id).md"))
        }
    }

    private static func enumFile(name: String, cases: [(String, String?)]) -> String {
        let body = cases.map { entry in
            if let raw = entry.1 {
                return "    case \(entry.0) = \"\(raw)\""
            }
            return "    case \(entry.0)"
        }.joined(separator: "\n")

        return """
        // Generated by BuilderArtifactGenerator. Do not edit by hand.

        public enum \(name): String, CaseIterable, Identifiable, Sendable {
        \(body)

            public var id: String { rawValue }
        }
        """
    }

    private static func foundationAppendix(for topic: FoundationTopic, manifest: Manifest) -> String {
        switch topic {
        case .iconography:
            return """

            ## Generated Icon Roles

            | Token | Symbol | Point size | Role |
            | --- | --- | --- | --- |
            \(manifest.tokens.icon.map { token in
                let spec = manifest.icons[token]!
                return "| `\(token)` | `\(spec.symbol)` | \(Int(spec.pointSize)) | \(escapePipes(spec.semanticRole)) |"
            }.joined(separator: "\n"))
            """
        case .layout:
            return """

            ## Generated Grid Specs

            | Token | Columns | Gutter | Margin | Max width |
            | --- | --- | --- | --- | --- |
            \(manifest.tokens.grid.map { token in
                let spec = manifest.grids[token]!
                let maxWidth = spec.maxWidth.map { String(Int($0)) } ?? "Flexible"
                return "| `\(token)` | \(spec.columns) | \(Int(spec.gutter)) | \(Int(spec.margin)) | \(maxWidth) |"
            }.joined(separator: "\n"))
            """
        case .motion:
            return """

            ## Generated Motion Durations

            | Token | Duration |
            | --- | --- |
            \(manifest.tokens.motion.map { token in
                let duration = manifest.motion[token]!
                return "| `\(token)` | `\(String(format: "%.2fs", duration))` |"
            }.joined(separator: "\n"))

            ## Generated Motion Curves

            | Token | Curve | Notes |
            | --- | --- | --- |
            \(manifest.tokens.motionCurve.map { token in
                let spec = manifest.motionCurves[token]!
                let points = spec.points.map { String(format: "%.2f", $0) }.joined(separator: ", ")
                return "| `\(token)` | `[\(points)]` | \(escapePipes(spec.notes)) |"
            }.joined(separator: "\n"))
            """
        case .visualFoundation, .materials:
            return """

            ## Elevation And Shadow Relationships

            | Elevation | Shadow token | Description |
            | --- | --- | --- |
            \(manifest.tokens.elevation.map { token in
                let shadowToken = manifest.elevations[token]!
                let description = manifest.shadows[shadowToken]?.description ?? ""
                return "| `\(token)` | `\(shadowToken)` | \(escapePipes(description)) |"
            }.joined(separator: "\n"))
            """
        case .designTokens:
            return """

            ## Generated Token Coverage

            - Colors: \(manifest.tokens.color.count)
            - Typography: \(manifest.tokens.typography.count)
            - Spacing: \(manifest.tokens.spacing.count)
            - Radius: \(manifest.tokens.radius.count)
            - Motion durations: \(manifest.tokens.motion.count)
            - Motion curves: \(manifest.tokens.motionCurve.count)
            - Elevation roles: \(manifest.tokens.elevation.count)
            - Shadow roles: \(manifest.tokens.shadow.count)
            - Material roles: \(manifest.tokens.material.count)
            - Icon roles: \(manifest.tokens.icon.count)
            - Grid roles: \(manifest.tokens.grid.count)
            """
        default:
            return ""
        }
    }

    private static func renderStructuredContent(_ content: StructuredContentGuidance) -> String {
        let sections: [(String, [String])] = [
            ("Action labels", content.actionLabels),
            ("Helper text", content.helperText),
            ("Validation copy", content.validationCopy),
            ("Error copy", content.errorCopy),
            ("Confirmations", content.confirmations),
            ("Destructive actions", content.destructiveActions),
            ("Empty states", content.emptyStates),
            ("Announcements", content.announcements),
            ("Localization", content.localization),
            ("Terminology", content.terminology),
            ("AI and generated content", content.aiGeneratedContent)
        ]

        return sections.map { title, items in
            """
            ### \(title)

            \(items.map { "- \($0)" }.joined(separator: "\n"))
            """
        }.joined(separator: "\n\n")
    }

    private static func renderRegistry(_ manifest: Manifest) -> String {
        let darkPalette = renderColorPalette(named: "darkPalette", colors: manifest.themes["dark"]!, manifest: manifest)
        let lightPalette = renderColorPalette(named: "lightPalette", colors: manifest.themes["light"]!, manifest: manifest)
        let spacing = renderCGFloatDictionary(named: "spacing", tokens: manifest.tokens.spacing, values: manifest.spacing, tokenType: "SpacingToken")
        let radius = renderCGFloatDictionary(named: "radius", tokens: manifest.tokens.radius, values: manifest.radius, tokenType: "RadiusToken")
        let motion = renderDoubleDictionary(named: "motion", tokens: manifest.tokens.motion, values: manifest.motion, tokenType: "MotionToken")
        let elevationShadows = renderElevationShadowMap(manifest)
        let motionCurves = renderMotionCurves(manifest)
        let shadows = renderShadows(manifest)
        let typography = renderTypography(manifest)
        let materials = renderMaterials(manifest)
        let icons = renderIcons(manifest)
        let grids = renderGrids(manifest)

        return """
        // Generated by BuilderArtifactGenerator. Do not edit by hand.

        import SwiftUI

        struct GeneratedTypographyDefinition {
            let size: CGFloat
            let weight: Font.Weight
            let tracking: CGFloat
            let lineHeight: CGFloat
            let monospaced: Bool
        }

        struct GeneratedMaterialDefinition {
            let fill: ColorToken
            let border: ColorToken
            let elevation: ElevationToken
            let radius: RadiusToken
            let opacity: Double
            let translucentLight: Bool
            let translucentDark: Bool
            let interactive: Bool
        }

        enum DesignTokenRegistry {
        \(indent(darkPalette, by: 1))

        \(indent(lightPalette, by: 1))

        \(indent(spacing, by: 1))

        \(indent(radius, by: 1))

        \(indent(motion, by: 1))

        \(indent(elevationShadows, by: 1))

        \(indent(motionCurves, by: 1))

        \(indent(shadows, by: 1))

        \(indent(typography, by: 1))

        \(indent(materials, by: 1))

        \(indent(icons, by: 1))

        \(indent(grids, by: 1))
        }
        """
    }

    private static func renderColorPalette(named: String, colors: [String: String], manifest: Manifest) -> String {
        let lines = manifest.tokens.color.map { entry in
            "    .\(entry.case): \"\(colors[entry.raw]!)\""
        }.joined(separator: ",\n")

        return """
        static let \(named): [ColorToken: String] = [
        \(lines)
        ]
        """
    }

    private static func renderCGFloatDictionary(named: String, tokens: [String], values: [String: Double], tokenType: String) -> String {
        let lines = tokens.map { "    .\($0): \(formatNumber(values[$0]!))" }.joined(separator: ",\n")
        return """
        static let \(named): [\(tokenType): CGFloat] = [
        \(lines)
        ]
        """
    }

    private static func renderDoubleDictionary(named: String, tokens: [String], values: [String: Double], tokenType: String) -> String {
        let lines = tokens.map { "    .\($0): \(formatNumber(values[$0]!))" }.joined(separator: ",\n")
        return """
        static let \(named): [\(tokenType): Double] = [
        \(lines)
        ]
        """
    }

    private static func renderElevationShadowMap(_ manifest: Manifest) -> String {
        let lines = manifest.tokens.elevation.map { "    .\($0): .\(manifest.elevations[$0]!)" }.joined(separator: ",\n")
        return """
        static let elevationShadows: [ElevationToken: ShadowToken] = [
        \(lines)
        ]
        """
    }

    private static func renderMotionCurves(_ manifest: Manifest) -> String {
        let lines = manifest.tokens.motionCurve.map { token in
            let curve = manifest.motionCurves[token]!
            return """
                .\(token): .init(
                    token: .\(token),
                    name: "\(escapeQuotes(curve.name))",
                    x1: \(formatNumber(curve.points[0])),
                    y1: \(formatNumber(curve.points[1])),
                    x2: \(formatNumber(curve.points[2])),
                    y2: \(formatNumber(curve.points[3])),
                    notes: "\(escapeQuotes(curve.notes))"
                )
            """
        }.joined(separator: ",\n")

        return """
        static let motionCurves: [MotionCurveToken: MotionCurveSpec] = [
        \(lines)
        ]
        """
    }

    private static func renderShadows(_ manifest: Manifest) -> String {
        let lines = manifest.tokens.shadow.map { token in
            let shadow = manifest.shadows[token]!
            return """
                .\(token): .init(
                    token: .\(token),
                    light: .init(color: Color(hex: "\(shadow.light.color)"), radius: \(formatNumber(shadow.light.radius)), x: \(formatNumber(shadow.light.x)), y: \(formatNumber(shadow.light.y))),
                    dark: .init(color: Color(hex: "\(shadow.dark.color)"), radius: \(formatNumber(shadow.dark.radius)), x: \(formatNumber(shadow.dark.x)), y: \(formatNumber(shadow.dark.y))),
                    description: "\(escapeQuotes(shadow.description))"
                )
            """
        }.joined(separator: ",\n")

        return """
        static let shadows: [ShadowToken: ShadowTokenSpec] = [
        \(lines)
        ]
        """
    }

    private static func renderTypography(_ manifest: Manifest) -> String {
        let lines = manifest.tokens.typography.map { token in
            let spec = manifest.typography[token]!
            return """
                .\(token): .init(
                    size: \(formatNumber(spec.size)),
                    weight: .\(spec.weight),
                    tracking: \(formatNumber(spec.tracking)),
                    lineHeight: \(formatNumber(spec.lineHeight)),
                    monospaced: \(spec.monospaced)
                )
            """
        }.joined(separator: ",\n")

        return """
        static let typography: [TypographyToken: GeneratedTypographyDefinition] = [
        \(lines)
        ]
        """
    }

    private static func renderMaterials(_ manifest: Manifest) -> String {
        let lines = manifest.tokens.material.map { token in
            let spec = manifest.materials[token]!
            return """
                .\(token): .init(
                    fill: .\(colorCase(forRawValue: spec.fill, manifest: manifest)),
                    border: .\(colorCase(forRawValue: spec.border, manifest: manifest)),
                    elevation: .\(spec.elevation),
                    radius: .\(spec.radius),
                    opacity: \(formatNumber(spec.opacity)),
                    translucentLight: \(spec.translucent.light),
                    translucentDark: \(spec.translucent.dark),
                    interactive: \(spec.interactive)
                )
            """
        }.joined(separator: ",\n")

        return """
        static let materials: [MaterialToken: GeneratedMaterialDefinition] = [
        \(lines)
        ]
        """
    }

    private static func renderIcons(_ manifest: Manifest) -> String {
        let lines = manifest.tokens.icon.map { token in
            let spec = manifest.icons[token]!
            return """
                .\(token): .init(
                    token: .\(token),
                    symbol: "\(spec.symbol)",
                    pointSize: \(formatNumber(spec.pointSize)),
                    weight: .\(spec.weight),
                    semanticRole: "\(escapeQuotes(spec.semanticRole))"
                )
            """
        }.joined(separator: ",\n")

        return """
        static let icons: [IconToken: IconSpec] = [
        \(lines)
        ]
        """
    }

    private static func renderGrids(_ manifest: Manifest) -> String {
        let lines = manifest.tokens.grid.map { token in
            let spec = manifest.grids[token]!
            let maxWidth = spec.maxWidth.map(formatNumber) ?? "nil"
            return """
                .\(token): .init(
                    token: .\(token),
                    columns: \(spec.columns),
                    gutter: \(formatNumber(spec.gutter)),
                    margin: \(formatNumber(spec.margin)),
                    maxWidth: \(maxWidth),
                    description: "\(escapeQuotes(spec.description))"
                )
            """
        }.joined(separator: ",\n")

        return """
        static let grids: [GridToken: GridSpec] = [
        \(lines)
        ]
        """
    }

    private static func colorCase(forRawValue rawValue: String, manifest: Manifest) -> String {
        manifest.tokens.color.first(where: { $0.raw == rawValue })?.case ?? "appBackground"
    }

    private static func slug(_ value: String) -> String {
        value
            .lowercased()
            .replacingOccurrences(of: " & ", with: " and ")
            .replacingOccurrences(of: "/", with: "-")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: " ", with: "-")
    }

    private static func formatNumber(_ value: Double) -> String {
        if value.rounded() == value {
            return String(Int(value))
        }

        return String(format: "%.2f", value)
            .replacingOccurrences(of: #"(\.\d*?)0+$"#, with: "$1", options: .regularExpression)
            .replacingOccurrences(of: #"\.$"#, with: "", options: .regularExpression)
    }

    private static func escapeQuotes(_ string: String) -> String {
        string.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\"")
    }

    private static func escapePipes(_ string: String) -> String {
        string.replacingOccurrences(of: "|", with: "\\|")
    }

    private static func indent(_ string: String, by level: Int) -> String {
        let prefix = String(repeating: "    ", count: level)
        return string.split(separator: "\n", omittingEmptySubsequences: false).map { prefix + $0 }.joined(separator: "\n")
    }

    private static func ensureDirectory(_ url: URL) throws {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    }

    private static func write(_ contents: String, to url: URL) throws {
        try ensureDirectory(url.deletingLastPathComponent())
        try contents.write(to: url, atomically: true, encoding: .utf8)
    }
}
