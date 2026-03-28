import Foundation
import BuilderFoundation

extension CatalogContent {
    package static let foundations: [FoundationDetail] = [
        .init(
            topic: .visualFoundation,
            summary: "The app is calibrated around a quiet editor-like shell: translucent sidebar, charcoal workspace, rounded grouped panels, and restrained elevation.",
            calibrationNotes: [
                "Use the screenshots as literal composition references before introducing any new component styling.",
                "Keep the shell low-chrome, with the strongest emphasis on hierarchy, spacing, and muted contrast rather than decorative effects.",
                "Reserve elevated surfaces for the composer, suggestion tiles, and grouped settings panels."
            ],
            implementationGuidelines: [
                "Build all base surfaces from semantic tokens rather than local view colors.",
                "Match the screenshots' dark shell proportions before refining component-level details.",
                "Use rounded geometry consistently so custom views feel like siblings."
            ],
            tokenReferences: ["bg.app", "bg.sidebar", "surface.grouped", "surface.raised", "border.subtle", "radius.large", "radius.extraLarge", "ShadowToken.raised", "GridToken.content"]
        ),
        .init(
            topic: .colors,
            summary: "The system uses one primary blue accent, neutrals for hierarchy, and restrained status hues that never compete with the core shell.",
            calibrationNotes: [
                "Dark accent is sampled close to #339CFF and light accent close to #0169CC.",
                "The dark workspace sits close to #181818 while the sidebar carries a blue-gray cast.",
                "Muted text should remain legible without turning silver or flat white."
            ],
            implementationGuidelines: [
                "Map every UI element to a semantic color role.",
                "Avoid extra brand colors in general product UI.",
                "Keep status colors available but secondary to the main accent."
            ],
            tokenReferences: ColorToken.allCases.map(\.rawValue)
        ),
        .init(
            topic: .contentDensity,
            summary: "Density is desktop-first and information-rich without becoming cramped, using consistent row heights and grouped surface rhythm.",
            calibrationNotes: [
                "Sidebar rows feel compact but not compressed.",
                "Settings rows balance generous labels with tight, right-aligned controls.",
                "The composer remains roomy even when the rest of the UI is dense."
            ],
            implementationGuidelines: [
                "Support compact, default, and comfortable modes with token multipliers.",
                "Adjust row heights and padding through density tokens instead of component-specific overrides.",
                "Keep tables, forms, and navigation in sync when density changes."
            ],
            tokenReferences: ["DensityMode", "SpacingToken.rowGap", "SpacingToken.toolbarHeight", "SpacingToken.panelPadding"]
        ),
        .init(
            topic: .dataVisualizationColors,
            summary: "Data visualization colors inherit the accent-led palette: blue as primary, with teal, amber, red, purple, green, and neutral supporting series.",
            calibrationNotes: [
                "Charts should feel at home inside the shell rather than imported from a dashboard library.",
                "The palette should read clearly in both dark and light modes."
            ],
            implementationGuidelines: [
                "Use categorical, sequential, and diverging subsets from the same theme palette.",
                "Keep chart gridlines and labels low contrast.",
                "Avoid neon saturation that breaks the calm shell."
            ],
            tokenReferences: ["chart.blue", "chart.teal", "chart.amber", "chart.red", "chart.purple", "chart.green", "chart.neutral"]
        ),
        .init(
            topic: .designTokens,
            summary: "The system is token-first: semantic roles drive every screen, and the showcase surfaces the taxonomy openly in the foundations browser.",
            calibrationNotes: [
                "Template layouts and catalog examples must share the same token source.",
                "Token names should describe responsibility, not raw appearance."
            ],
            implementationGuidelines: [
                "Expose colors, typography, spacing, radii, motion, and elevation through enums and theme accessors.",
                "Keep token names stable across light and dark modes.",
                "Document token purpose in both code and docs."
            ],
            tokenReferences: ["AppTheme", "ColorToken", "TypographyToken", "SpacingToken", "RadiusToken", "MotionToken", "MotionCurveToken", "ElevationToken", "ShadowToken", "IconToken", "GridToken", "MaterialToken"]
        ),
        .init(
            topic: .iconography,
            summary: "Iconography is SF Symbols-based, thin-lined, and used to improve scanning rather than decorate empty space.",
            calibrationNotes: [
                "Icons in the screenshots are small, precise, and never visually louder than labels.",
                "Weight and scale should match nearby text."
            ],
            implementationGuidelines: [
                "Default to SF Symbols with regular or medium weight.",
                "Avoid large icon badges unless the icon anchors a hero state.",
                "Keep icon color tied to text tiers or semantic status."
            ],
            tokenReferences: IconToken.allCases.map(\.rawValue)
        ),
        .init(
            topic: .layout,
            summary: "Layout is built around a left navigation rail, a dominant workspace, and optional secondary panels or settings content columns.",
            calibrationNotes: [
                "The sidebar is visually distinct but not visually heavy.",
                "Content remains centered and calm even in large windows.",
                "Settings pages use long grouped panels with controlled max width."
            ],
            implementationGuidelines: [
                "Use shell tokens for sidebar width, content width, and panel sizing.",
                "Avoid dashboard mosaics; prefer a primary working region.",
                "Support split and panel patterns without breaking the main shell rhythm."
            ],
            tokenReferences: GridToken.allCases.map(\.rawValue)
        ),
        .init(
            topic: .materials,
            summary: "Materials define how shell, panel, card, input, menu, and overlay surfaces differ through fill, border, radius, elevation, opacity, translucency, and interactivity.",
            calibrationNotes: [
                "Dark mode materials should feel graphite and calm rather than glossy.",
                "Light mode materials should stay warm and soft instead of bright white stacks of cards.",
                "Overlay roles like popovers, modals, and drawers should feel related but still distinct."
            ],
            implementationGuidelines: [
                "Assign every surface to a named material role before styling it locally.",
                "Treat radius, fill opacity, and translucency as part of the material contract, not one-off view tweaks.",
                "Use material distinctions to create hierarchy before reaching for louder color or shadow changes."
            ],
            tokenReferences: MaterialToken.allCases.map(\.rawValue)
        ),
        .init(
            topic: .motion,
            summary: "Motion is fast, restrained, and functional: hover, focus, selection, and presence transitions only.",
            calibrationNotes: [
                "Nothing in the screenshots suggests ornamental animation.",
                "The system should still feel alive through selection and presence changes."
            ],
            implementationGuidelines: [
                "Use quick and regular timings by default.",
                "Respect reduced motion globally.",
                "Avoid spring-heavy, playful motion curves."
            ],
            tokenReferences: MotionToken.allCases.map(\.rawValue) + MotionCurveToken.allCases.map(\.rawValue)
        ),
        .init(
            topic: .spacing,
            summary: "Spacing follows a disciplined 4-based scale with a few shell-specific steps for rows, panels, and the composer.",
            calibrationNotes: [
                "Spacing consistency is one of the strongest screenshot signals.",
                "The system should feel roomy without becoming sparse."
            ],
            implementationGuidelines: [
                "Drive all insets and gaps through spacing tokens.",
                "Keep grouped settings rows and preview panels on the same rhythm.",
                "Reserve extra-large spacing for primary page composition and hero layouts."
            ],
            tokenReferences: SpacingToken.allCases.map(\.rawValue)
        ),
        .init(
            topic: .theming,
            summary: "Light and dark themes are equal-parity siblings, sharing the same hierarchy, density, and semantic roles.",
            calibrationNotes: [
                "Dark mode is the emotional baseline, but light mode should feel clearly related rather than generic.",
                "Accent and status colors should preserve identity across modes."
            ],
            implementationGuidelines: [
                "Keep token names identical between modes.",
                "Verify all core surfaces, controls, and charts in both themes.",
                "Use contrast mode as a global refinement layer, not a separate theme."
            ],
            tokenReferences: ["ThemeMode", "ThemeContrast", "AppTheme"]
        ),
        .init(
            topic: .typography,
            summary: "Typography relies on SF system UI with strong page titles, muted supporting copy, and monospaced treatment only for code-like content.",
            calibrationNotes: [
                "The hero headline is bold but not oversized for the shell.",
                "Settings labels and descriptions use a compact, practical rhythm.",
                "Monospaced typography appears only in code preview surfaces."
            ],
            implementationGuidelines: [
                "Limit the system to the platform UI font and one monospaced companion.",
                "Use semantic type roles instead of local font declarations.",
                "Let spacing and weight do more work than color."
            ],
            tokenReferences: TypographyToken.allCases.map(\.rawValue)
        ),
        .init(
            topic: .visualContext,
            summary: "Visual context keeps the same token system feeling appropriate across shell, settings, editor, dashboard, onboarding, and AI output surfaces.",
            calibrationNotes: [
                "The same button should feel at home in a modal, settings page, or AI composer.",
                "Context affects layout and density more than it affects base styling."
            ],
            implementationGuidelines: [
                "Model context explicitly in the environment.",
                "Use context to tune spacing, emphasis, and grouping rules.",
                "Keep underlying primitives consistent."
            ],
            tokenReferences: VisualContext.allCases.map(\.rawValue)
        ),
        .init(
            topic: .visualModes,
            summary: "Visual modes define how components shift across selected, focused, disabled, read-only, loading, and status-bearing states.",
            calibrationNotes: [
                "Selection is soft and rounded, not a harsh background fill.",
                "Disabled surfaces should remain visible and still feel native to the shell."
            ],
            implementationGuidelines: [
                "Model state visuals explicitly so previews can render a state matrix.",
                "Use opacity changes sparingly; pair them with border, fill, or label changes.",
                "Make focus visible without turning controls into bright outlines."
            ],
            tokenReferences: VisualMode.allCases.map(\.rawValue)
        ),
        .init(
            topic: .visualStyle,
            summary: "The visual style is professional, precise, and calm: no decorative gradients, no loud glassmorphism, and no generic SaaS card carpets.",
            calibrationNotes: [
                "The shell feels like a desktop tool, not a marketing site.",
                "Rounded panels and pill controls carry most of the personality."
            ],
            implementationGuidelines: [
                "Use grouped surfaces instead of ornamental framing.",
                "Keep accent usage purposeful and sparse.",
                "If a region works without a card, remove the card."
            ],
            tokenReferences: ["surface.grouped", "surface.raised", "accent.primary", "border.subtle"]
        )
    ]
}
