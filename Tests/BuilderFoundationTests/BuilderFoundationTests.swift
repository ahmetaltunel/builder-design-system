import XCTest
@testable import BuilderFoundation

final class BuilderFoundationTests: XCTestCase {
    func testAllColorTokensResolveForBothThemes() {
        let dark = AppTheme(mode: .dark, contrast: .standard)
        let light = AppTheme(mode: .light, contrast: .standard)

        for token in ColorToken.allCases {
            _ = dark.color(token)
            _ = light.color(token)
        }

        XCTAssertEqual(ColorToken.allCases.count, 41)
    }

    func testTypographyAndMaterialsResolveAcrossThemes() {
        let dark = AppTheme(mode: .dark, contrast: .standard)
        let light = AppTheme(mode: .light, contrast: .standard)

        for token in TypographyToken.allCases {
            let darkSpec = dark.typography(token)
            let lightSpec = light.typography(token)

            XCTAssertGreaterThan(darkSpec.size, 0)
            XCTAssertGreaterThanOrEqual(darkSpec.lineHeight, darkSpec.size)
            XCTAssertGreaterThan(lightSpec.size, 0)
            XCTAssertGreaterThanOrEqual(lightSpec.lineHeight, lightSpec.size)
        }

        for token in MaterialToken.allCases {
            let darkSpec = dark.material(token)
            let lightSpec = light.material(token)

            XCTAssertGreaterThanOrEqual(darkSpec.borderWidth, 0)
            XCTAssertGreaterThan(lightSpec.fillOpacity, 0)
            XCTAssertFalse(darkSpec.radius.rawValue.isEmpty)
            XCTAssertFalse(lightSpec.radius.rawValue.isEmpty)
        }

        XCTAssertEqual(TypographyToken.allCases.count, 28)
        XCTAssertEqual(MaterialToken.allCases.count, 24)
    }

    func testDensityModesAndVisualContextsStayStable() {
        XCTAssertEqual(DensityMode.allCases.map(\.title), ["Compact", "Default", "Comfortable"])
        XCTAssertEqual(VisualContext.allCases.count, 7)
        XCTAssertEqual(VisualMode.allCases.count, 10)
    }

    func testExtendedFoundationContractsResolve() {
        let theme = AppTheme(mode: .dark, contrast: .standard)

        XCTAssertEqual(MotionCurveToken.allCases.count, 6)
        XCTAssertEqual(ShadowToken.allCases.count, 6)
        XCTAssertEqual(IconToken.allCases.count, 10)
        XCTAssertEqual(GridToken.allCases.count, 7)

        for token in MotionCurveToken.allCases {
            let curve = theme.motionCurve(token)
            XCTAssertFalse(curve.name.isEmpty)
        }

        for token in ShadowToken.allCases {
            let spec = theme.shadowTokenSpec(token)
            XCTAssertFalse(spec.description.isEmpty)
        }

        for token in IconToken.allCases {
            let spec = theme.icon(token)
            XCTAssertFalse(spec.symbol.isEmpty)
        }

        for token in GridToken.allCases {
            let spec = theme.grid(token)
            XCTAssertGreaterThan(spec.columns, 0)
        }
    }

    func testShadowHierarchyStaysRestrainedAndOverlayFocused() {
        let light = AppTheme(mode: .light, contrast: .standard)
        let dark = AppTheme(mode: .dark, contrast: .standard)

        let lightHairline = light.shadow(.hairline)
        let lightSubtle = light.shadow(.subtle)
        let lightRaised = light.shadow(.raised)
        let lightFloating = light.shadow(.floating)

        XCTAssertLessThanOrEqual(lightHairline.radius, lightSubtle.radius)
        XCTAssertLessThanOrEqual(lightSubtle.radius, lightRaised.radius)
        XCTAssertLessThanOrEqual(lightRaised.radius, lightFloating.radius)

        let darkHairline = dark.shadow(.hairline)
        let darkSubtle = dark.shadow(.subtle)
        let darkRaised = dark.shadow(.raised)
        let darkFloating = dark.shadow(.floating)

        XCTAssertLessThanOrEqual(darkHairline.radius, darkSubtle.radius)
        XCTAssertLessThanOrEqual(darkSubtle.radius, darkRaised.radius)
        XCTAssertLessThanOrEqual(darkRaised.radius, darkFloating.radius)

        XCTAssertEqual(light.material(.grouped).elevation, .flat)
        XCTAssertEqual(light.material(.panel).elevation, .flat)
        XCTAssertEqual(light.material(.card).elevation, .flat)
        XCTAssertEqual(light.material(.notice).elevation, .flat)
        XCTAssertEqual(light.material(.drawer).elevation, .flat)
        XCTAssertEqual(light.material(.menu).elevation, .raised)
        XCTAssertEqual(light.material(.popover).elevation, .floating)
        XCTAssertEqual(light.material(.modal).elevation, .floating)
        XCTAssertEqual(light.material(.overlay).elevation, .floating)
    }

    func testSemanticContrastPairsStayAccessible() throws {
        let export = try loadTokenExport()

        let dark = export["themes"]?["dark"] ?? [:]
        let light = export["themes"]?["light"] ?? [:]

        XCTAssertGreaterThanOrEqual(contrastRatio(foreground: dark["text.primary"]!, background: dark["bg.workspace"]!), 7.0)
        XCTAssertGreaterThanOrEqual(contrastRatio(foreground: light["text.primary"]!, background: light["bg.workspace"]!), 7.0)
        XCTAssertGreaterThanOrEqual(contrastRatio(foreground: dark["text.secondary"]!, background: dark["bg.workspace"]!), 4.5)
        XCTAssertGreaterThanOrEqual(contrastRatio(foreground: light["text.secondary"]!, background: light["bg.workspace"]!), 4.5)
        XCTAssertGreaterThanOrEqual(contrastRatio(foreground: dark["text.onAccent"]!, background: dark["accent.primary"]!), 3.0)
        XCTAssertGreaterThanOrEqual(contrastRatio(foreground: light["text.onAccent"]!, background: light["accent.primary"]!), 4.5)
    }

    private func loadTokenExport() throws -> [String: [String: [String: String]]] {
        let root = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        let data = try Data(contentsOf: root.appendingPathComponent("Exports/design-tokens.json"))
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let themes = json?["themes"] as? [String: [String: String]] ?? [:]
        return ["themes": themes]
    }

    private func contrastRatio(foreground: String, background: String) -> Double {
        let fg = rgbComponents(foreground)
        let bg = rgbComponents(background)
        let l1 = relativeLuminance(fg)
        let l2 = relativeLuminance(bg)
        let lighter = max(l1, l2)
        let darker = min(l1, l2)
        return (lighter + 0.05) / (darker + 0.05)
    }

    private func rgbComponents(_ hex: String) -> (Double, Double, Double) {
        let normalized = hex.replacingOccurrences(of: "#", with: "")
        let value = UInt64(normalized.prefix(6), radix: 16) ?? 0
        let red = Double((value >> 16) & 0xFF) / 255
        let green = Double((value >> 8) & 0xFF) / 255
        let blue = Double(value & 0xFF) / 255
        return (red, green, blue)
    }

    private func relativeLuminance(_ components: (Double, Double, Double)) -> Double {
        [components.0, components.1, components.2]
            .map { channel -> Double in
                if channel <= 0.03928 { return channel / 12.92 }
                return pow((channel + 0.055) / 1.055, 2.4)
            }
            .enumerated()
            .reduce(0) { partial, pair in
                let multiplier = [0.2126, 0.7152, 0.0722][pair.offset]
                return partial + pair.element * multiplier
            }
    }
}
