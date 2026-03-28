public struct DesignSystemEnvironment {
    public let theme: AppTheme
    public let mode: ThemeMode
    public let contrast: ThemeContrast
    public let density: DensityMode
    public let visualContext: VisualContext
    public let reduceMotion: Bool
    public let highContrast: Bool

    public init(
        theme: AppTheme,
        mode: ThemeMode,
        contrast: ThemeContrast,
        density: DensityMode,
        visualContext: VisualContext,
        reduceMotion: Bool,
        highContrast: Bool
    ) {
        self.theme = theme
        self.mode = mode
        self.contrast = contrast
        self.density = density
        self.visualContext = visualContext
        self.reduceMotion = reduceMotion
        self.highContrast = highContrast
    }
}

public extension DesignSystemEnvironment {
    static func preview(
        _ mode: ThemeMode,
        contrast: ThemeContrast = .standard,
        density: DensityMode = .default,
        visualContext: VisualContext = .shell,
        reduceMotion: Bool = false,
        highContrast: Bool = false
    ) -> Self {
        let resolvedContrast = highContrast ? .increased : contrast

        return .init(
            theme: AppTheme(mode: mode, contrast: resolvedContrast),
            mode: mode,
            contrast: resolvedContrast,
            density: density,
            visualContext: visualContext,
            reduceMotion: reduceMotion,
            highContrast: highContrast
        )
    }
}
