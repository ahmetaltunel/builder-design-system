import SwiftUI

public struct AppTheme {
    public let mode: ThemeMode
    public let contrast: ThemeContrast

    public init(mode: ThemeMode, contrast: ThemeContrast) {
        self.mode = mode
        self.contrast = contrast
    }

    public func color(_ token: ColorToken) -> Color {
        let palette = switch mode {
        case .light: DesignTokenRegistry.lightPalette
        case .dark: DesignTokenRegistry.darkPalette
        }

        let hex = palette[token] ?? "#000000"

        if contrast == .increased {
            return adjustedContrastColor(for: token, baseHex: hex)
        }

        return Color(hex: hex)
    }

    public func typography(_ token: TypographyToken) -> TypographySpec {
        let definition = DesignTokenRegistry.typography[token] ?? .init(
            size: 15,
            weight: .regular,
            tracking: 0,
            lineHeight: 22,
            monospaced: false
        )

        let font: Font
        if definition.monospaced {
            font = .system(size: definition.size, weight: definition.weight, design: .monospaced)
        } else {
            font = .system(size: definition.size, weight: definition.weight)
        }

        return .init(
            token: token,
            font: font,
            size: definition.size,
            weight: definition.weight,
            tracking: definition.tracking,
            lineHeight: definition.lineHeight,
            isMonospaced: definition.monospaced
        )
    }

    public func spacing(_ token: SpacingToken, density: DensityMode) -> CGFloat {
        let base = DesignTokenRegistry.spacing[token] ?? 0
        return (base * density.spacingMultiplier).rounded(.toNearestOrEven)
    }

    public func radius(_ token: RadiusToken) -> CGFloat {
        DesignTokenRegistry.radius[token] ?? 0
    }

    public func motion(_ token: MotionToken, reduceMotion: Bool) -> Double {
        guard !reduceMotion else { return 0.01 }
        return DesignTokenRegistry.motion[token] ?? 0.18
    }

    public func motionCurve(_ token: MotionCurveToken, reduceMotion: Bool = false) -> MotionCurveSpec {
        if reduceMotion {
            return DesignTokenRegistry.motionCurves[.reduced] ?? .init(
                token: .reduced,
                name: "Reduced motion",
                x1: 0,
                y1: 0,
                x2: 1,
                y2: 1,
                notes: "Fallback curve for reduced motion."
            )
        }

        return DesignTokenRegistry.motionCurves[token] ?? DesignTokenRegistry.motionCurves[.standard]!
    }

    public func shadow(_ token: ShadowToken) -> ShadowSpec {
        let definition = DesignTokenRegistry.shadows[token] ?? DesignTokenRegistry.shadows[.flat]!
        return mode == .dark ? definition.dark : definition.light
    }

    public func shadowTokenSpec(_ token: ShadowToken) -> ShadowTokenSpec {
        DesignTokenRegistry.shadows[token] ?? DesignTokenRegistry.shadows[.flat]!
    }

    public func elevation(_ token: ElevationToken) -> ShadowSpec {
        let shadowToken = DesignTokenRegistry.elevationShadows[token] ?? .flat
        return shadow(shadowToken)
    }

    public func material(_ token: MaterialToken) -> MaterialSpec {
        let definition = DesignTokenRegistry.materials[token] ?? DesignTokenRegistry.materials[.shell]!
        return .init(
            token: token,
            fill: color(definition.fill),
            border: color(definition.border),
            elevation: definition.elevation,
            radius: definition.radius,
            borderWidth: token == .scrim ? 0 : 1,
            fillOpacity: definition.opacity,
            isTranslucent: mode == .dark ? definition.translucentDark : definition.translucentLight,
            isInteractive: definition.interactive
        )
    }

    public func icon(_ token: IconToken) -> IconSpec {
        DesignTokenRegistry.icons[token] ?? DesignTokenRegistry.icons[.utility]!
    }

    public func grid(_ token: GridToken) -> GridSpec {
        DesignTokenRegistry.grids[token] ?? DesignTokenRegistry.grids[.content]!
    }

    private func adjustedContrastColor(for token: ColorToken, baseHex: String) -> Color {
        switch token {
        case .textSecondary, .textMuted, .textDisabled:
            return Color(hex: mode == .dark ? "#C7C7C7" : "#484848")
        case .subtleBorder:
            return Color(hex: mode == .dark ? "#555555" : "#B8B8B8")
        default:
            return Color(hex: baseHex)
        }
    }
}
