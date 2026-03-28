import Foundation
import BuilderFoundation
import BuilderReferenceExamples

private struct ComponentSeed {
    let name: String
    let category: ComponentCategory
    let previewGroup: ComponentPreviewGroup
    let status: ComponentStatus
}

private let componentSeeds: [ComponentSeed] = [
    .init(name: "Alert", category: .feedbackOverlay, previewGroup: .feedback, status: .implemented),
    .init(name: "Anchor navigation", category: .shellNavigation, previewGroup: .navigation, status: .implemented),
    .init(name: "Area chart", category: .specialized, previewGroup: .data, status: .implemented),
    .init(name: "App layout", category: .shellNavigation, previewGroup: .shell, status: .calibrated),
    .init(name: "App layout toolbar", category: .shellNavigation, previewGroup: .toolbar, status: .calibrated),
    .init(name: "Attribute editor", category: .specialized, previewGroup: .specialized, status: .implemented),
    .init(name: "Autosuggest", category: .inputSelection, previewGroup: .form, status: .implemented),
    .init(name: "Avatar", category: .specialized, previewGroup: .ai, status: .implemented),
    .init(name: "Badge", category: .feedbackOverlay, previewGroup: .feedback, status: .implemented),
    .init(name: "Bar chart", category: .specialized, previewGroup: .data, status: .implemented),
    .init(name: "Board", category: .collectionContent, previewGroup: .content, status: .implemented),
    .init(name: "Board item", category: .collectionContent, previewGroup: .content, status: .implemented),
    .init(name: "Box", category: .shellNavigation, previewGroup: .content, status: .implemented),
    .init(name: "Breadcrumb group", category: .shellNavigation, previewGroup: .navigation, status: .implemented),
    .init(name: "Button", category: .inputSelection, previewGroup: .selection, status: .calibrated),
    .init(name: "Button dropdown", category: .inputSelection, previewGroup: .selection, status: .implemented),
    .init(name: "Button group", category: .inputSelection, previewGroup: .selection, status: .implemented),
    .init(name: "Calendar", category: .specialized, previewGroup: .tutorial, status: .implemented),
    .init(name: "Cards", category: .collectionContent, previewGroup: .content, status: .calibrated),
    .init(name: "Chat bubble", category: .specialized, previewGroup: .ai, status: .implemented),
    .init(name: "Charts", category: .specialized, previewGroup: .data, status: .implemented),
    .init(name: "Checkbox", category: .inputSelection, previewGroup: .selection, status: .implemented),
    .init(name: "Code editor", category: .collectionContent, previewGroup: .utility, status: .implemented),
    .init(name: "Code view", category: .collectionContent, previewGroup: .utility, status: .implemented),
    .init(name: "View preferences", category: .inputSelection, previewGroup: .form, status: .implemented),
    .init(name: "Filter select", category: .inputSelection, previewGroup: .selection, status: .implemented),
    .init(name: "Column layout", category: .shellNavigation, previewGroup: .content, status: .implemented),
    .init(name: "Container", category: .shellNavigation, previewGroup: .content, status: .implemented),
    .init(name: "Content layout", category: .shellNavigation, previewGroup: .content, status: .implemented),
    .init(name: "Copy to clipboard", category: .collectionContent, previewGroup: .utility, status: .implemented),
    .init(name: "Date input", category: .inputSelection, previewGroup: .form, status: .implemented),
    .init(name: "Date picker", category: .inputSelection, previewGroup: .form, status: .implemented),
    .init(name: "Date range picker", category: .inputSelection, previewGroup: .form, status: .implemented),
    .init(name: "Donut chart", category: .specialized, previewGroup: .data, status: .implemented),
    .init(name: "Drawer", category: .feedbackOverlay, previewGroup: .overlay, status: .calibrated),
    .init(name: "Empty state", category: .feedbackOverlay, previewGroup: .feedback, status: .implemented),
    .init(name: "Error boundary", category: .feedbackOverlay, previewGroup: .feedback, status: .implemented),
    .init(name: "Expandable section", category: .collectionContent, previewGroup: .content, status: .implemented),
    .init(name: "File picker button", category: .specialized, previewGroup: .specialized, status: .implemented),
    .init(name: "File token group", category: .specialized, previewGroup: .specialized, status: .implemented),
    .init(name: "File upload field", category: .specialized, previewGroup: .specialized, status: .implemented),
    .init(name: "File uploading components", category: .specialized, previewGroup: .specialized, status: .implemented),
    .init(name: "Notice stack", category: .feedbackOverlay, previewGroup: .feedback, status: .implemented),
    .init(name: "Form", category: .inputSelection, previewGroup: .form, status: .implemented),
    .init(name: "Form field", category: .inputSelection, previewGroup: .form, status: .implemented),
    .init(name: "Generative AI components", category: .specialized, previewGroup: .ai, status: .calibrated),
    .init(name: "Grid", category: .shellNavigation, previewGroup: .content, status: .implemented),
    .init(name: "Header", category: .shellNavigation, previewGroup: .toolbar, status: .calibrated),
    .init(name: "Help panel", category: .specialized, previewGroup: .specialized, status: .implemented),
    .init(name: "Context panel", category: .specialized, previewGroup: .specialized, status: .implemented),
    .init(name: "Icon", category: .collectionContent, previewGroup: .utility, status: .implemented),
    .init(name: "Input", category: .inputSelection, previewGroup: .form, status: .calibrated),
    .init(name: "Items palette", category: .collectionContent, previewGroup: .content, status: .implemented),
    .init(name: "Key-value pairs", category: .collectionContent, previewGroup: .content, status: .implemented),
    .init(name: "Line chart", category: .specialized, previewGroup: .data, status: .implemented),
    .init(name: "Link", category: .collectionContent, previewGroup: .utility, status: .implemented),
    .init(name: "List", category: .collectionContent, previewGroup: .content, status: .implemented),
    .init(name: "Live region", category: .feedbackOverlay, previewGroup: .feedback, status: .implemented),
    .init(name: "Loading bar", category: .feedbackOverlay, previewGroup: .feedback, status: .implemented),
    .init(name: "Modal", category: .feedbackOverlay, previewGroup: .overlay, status: .implemented),
    .init(name: "Mixed chart", category: .specialized, previewGroup: .data, status: .implemented),
    .init(name: "Multiselect", category: .inputSelection, previewGroup: .selection, status: .implemented),
    .init(name: "Pagination", category: .collectionContent, previewGroup: .content, status: .implemented),
    .init(name: "Panel layout", category: .shellNavigation, previewGroup: .shell, status: .calibrated),
    .init(name: "Popover", category: .feedbackOverlay, previewGroup: .overlay, status: .implemented),
    .init(name: "Progress bar", category: .feedbackOverlay, previewGroup: .feedback, status: .implemented),
    .init(name: "Prompt input", category: .specialized, previewGroup: .ai, status: .implemented),
    .init(name: "Property filter", category: .inputSelection, previewGroup: .selection, status: .implemented),
    .init(name: "Radio group", category: .inputSelection, previewGroup: .selection, status: .implemented),
    .init(name: "Resource selector", category: .specialized, previewGroup: .specialized, status: .implemented),
    .init(name: "Segmented control", category: .inputSelection, previewGroup: .selection, status: .implemented),
    .init(name: "Select", category: .inputSelection, previewGroup: .selection, status: .calibrated),
    .init(name: "Side navigation", category: .shellNavigation, previewGroup: .navigation, status: .calibrated),
    .init(name: "Slider", category: .inputSelection, previewGroup: .selection, status: .implemented),
    .init(name: "Space between", category: .shellNavigation, previewGroup: .content, status: .implemented),
    .init(name: "Spinner", category: .feedbackOverlay, previewGroup: .feedback, status: .implemented),
    .init(name: "Split panel", category: .shellNavigation, previewGroup: .shell, status: .implemented),
    .init(name: "Status indicator", category: .feedbackOverlay, previewGroup: .feedback, status: .implemented),
    .init(name: "Steps", category: .specialized, previewGroup: .tutorial, status: .implemented),
    .init(name: "Support prompt group", category: .specialized, previewGroup: .ai, status: .implemented),
    .init(name: "Table", category: .collectionContent, previewGroup: .data, status: .implemented),
    .init(name: "Tabs", category: .collectionContent, previewGroup: .content, status: .implemented),
    .init(name: "Tag editor", category: .inputSelection, previewGroup: .selection, status: .implemented),
    .init(name: "Text content", category: .collectionContent, previewGroup: .content, status: .implemented),
    .init(name: "Text filter", category: .inputSelection, previewGroup: .form, status: .implemented),
    .init(name: "Text area", category: .inputSelection, previewGroup: .form, status: .calibrated),
    .init(name: "Tiles", category: .inputSelection, previewGroup: .selection, status: .implemented),
    .init(name: "Time input", category: .inputSelection, previewGroup: .form, status: .implemented),
    .init(name: "Toggle", category: .inputSelection, previewGroup: .selection, status: .calibrated),
    .init(name: "Toggle button", category: .inputSelection, previewGroup: .selection, status: .implemented),
    .init(name: "Token", category: .inputSelection, previewGroup: .selection, status: .implemented),
    .init(name: "Token group", category: .inputSelection, previewGroup: .selection, status: .implemented),
    .init(name: "Top navigation", category: .shellNavigation, previewGroup: .navigation, status: .implemented),
    .init(name: "Tree view", category: .collectionContent, previewGroup: .content, status: .implemented),
    .init(name: "Tutorial components", category: .specialized, previewGroup: .tutorial, status: .implemented),
    .init(name: "Tutorial panel", category: .specialized, previewGroup: .tutorial, status: .implemented),
    .init(name: "Wizard", category: .specialized, previewGroup: .tutorial, status: .implemented)
]

extension CatalogContent {
    package static let components: [ComponentCatalogEntry] = componentSeeds.map(buildComponent)
}

private func buildComponent(_ seed: ComponentSeed) -> ComponentCatalogEntry {
    ComponentCatalogEntry(
        id: slug(seed.name),
        name: seed.name,
        category: seed.category,
        swiftUIType: swiftUITypeName(for: seed.name),
        summary: "\(seed.name) is calibrated for the design-system shell with restrained surfaces, semantic tokens, and consistent light and dark behavior.",
        anatomy: anatomy(for: seed),
        variants: variants(for: seed),
        states: states(for: seed),
        densityBehavior: densityBehavior(for: seed),
        accessibility: accessibilityRules(for: seed),
        themingHooks: themingHooks(for: seed),
        designTokens: componentTokens(for: seed),
        dos: dos(for: seed),
        donts: donts(for: seed),
        relatedPatterns: componentRelatedPatterns(for: seed),
        writingGuidelines: writingGuidelines(for: seed),
        structuredContent: structuredContent(for: seed),
        engineeringNotes: engineeringNotes(for: seed),
        usage: usageGuidelines(for: seed),
        antiPatterns: antiPatterns(for: seed),
        macOSNotes: macNotes(for: seed),
        status: seed.status,
        previewGroup: seed.previewGroup,
        canonicalExampleID: .init(rawValue: slug(seed.name)),
        accessibilityAcceptance: accessibilityAcceptance(for: seed)
    )
}

private func accessibilityAcceptance(for seed: ComponentSeed) -> AccessibilityAcceptance {
    switch seed.previewGroup {
    case .ai:
        .init(semantics: true, keyboard: true, contrast: true, motion: true, messaging: true)
    case .overlay:
        .init(semantics: true, keyboard: true, contrast: true, motion: true, messaging: true)
    default:
        .init(semantics: true, keyboard: true, contrast: true, motion: true, messaging: true)
    }
}

private func anatomy(for seed: ComponentSeed) -> [String] {
    switch seed.previewGroup {
    case .shell:
        ["Primary shell frame", "Navigation rail or split region", "Workspace content plane", "Optional secondary panel"]
    case .toolbar:
        ["Context title", "Primary actions", "Secondary actions", "Status or segmented controls"]
    case .navigation:
        ["Hierarchical items", "Selection affordance", "Optional counters or icons", "Keyboard-friendly focus order"]
    case .form:
        ["Field label", "Control surface", "Optional description", "Validation or help text"]
    case .selection:
        ["Selectable values", "Current selection state", "Group context", "Clear action when relevant"]
    case .feedback:
        ["Semantic status cue", "Primary label", "Supporting detail", "Dismiss or follow-up action"]
    case .overlay:
        ["Overlay surface", "Entry transition", "Focused content region", "Dismiss affordance"]
    case .content:
        ["Header or label", "Primary content region", "Supporting metadata", "Optional action cluster"]
    case .data:
        ["Data frame", "Legend or headers", "Readable axis or labels", "Filtering or paging affordances"]
    case .ai:
        ["Prompt or context region", "Generated output surface", "Utility actions", "Status or attribution"]
    case .tutorial:
        ["Step structure", "Current progress", "Primary content", "Next-step action"]
    case .utility, .specialized:
        ["Primary utility surface", "Context label", "Focused interaction", "Supporting metadata"]
    }
}

private func variants(for seed: ComponentSeed) -> [String] {
    switch seed.previewGroup {
    case .selection:
        ["Default", "Selected", "Mixed or multi-select", "Disabled"]
    case .feedback:
        ["Info", "Success", "Warning", "Error"]
    case .overlay:
        ["Inline", "Floating", "Modal context", "Docked context"]
    case .data:
        ["Default", "Dense", "Empty", "Loading"]
    case .ai:
        ["Prompting", "Streaming", "Resolved", "Review mode"]
    default:
        ["Default", "Compact", "Expanded", "Disabled where applicable"]
    }
}

private func states(for seed: ComponentSeed) -> [String] {
    switch seed.previewGroup {
    case .feedback:
        ["Normal", "Dismissed", "Inline action hover", "Persistent banner"]
    case .overlay:
        ["Closed", "Opening", "Open", "Blocked-dismiss"]
    case .data:
        ["Idle", "Sorting", "Filtered", "Loading", "Error"]
    default:
        ["Normal", "Hover", "Focused", "Selected", "Disabled", "Read-only when applicable"]
    }
}

private func densityBehavior(for seed: ComponentSeed) -> String {
    switch seed.category {
    case .shellNavigation:
        "Density adjusts row heights, panel padding, and toolbar height without changing the core shell proportions."
    case .inputSelection:
        "Density changes control height, label spacing, and supporting-text rhythm while preserving hit targets."
    case .feedbackOverlay:
        "Density tightens banner padding and overlay chrome while keeping status hierarchy readable."
    case .collectionContent:
        "Density affects rows, metadata spacing, and pagination rhythm while maintaining scanability."
    case .specialized:
        "Density adapts supporting chrome around the specialized surface rather than compressing the main interaction."
    }
}

private func accessibilityRules(for seed: ComponentSeed) -> [String] {
    var rules = [
        "Visible focus treatment must use the system focus token rather than a local highlight.",
        "VoiceOver labels should prefer the catalog name plus current value or state.",
        "Text and icons must keep contrast in both light and dark themes."
    ]

    switch seed.previewGroup {
    case .form, .selection:
        rules.append("Keyboard navigation should preserve label-to-control relationships and clear error messaging.")
    case .data:
        rules.append("Rows and charts should remain understandable without relying on color alone.")
    case .overlay:
        rules.append("Opening an overlay should move focus into the overlay and restore it predictably when dismissed.")
    default:
        break
    }

    return rules
}

private func themingHooks(for seed: ComponentSeed) -> [String] {
    [
        "Consumes semantic color roles from AppTheme rather than local literals.",
        "Respects DensityMode for spacing and sizing.",
        "Uses shared radius and elevation tokens so grouped surfaces stay visually related."
    ]
}

private func componentTokens(for seed: ComponentSeed) -> [String] {
    switch seed.previewGroup {
    case .shell, .toolbar, .navigation:
        ["bg.sidebar", "bg.workspace", "surface.grouped", "border.subtle", "radius.large", "SpacingToken.toolbarHeight"]
    case .form, .selection:
        ["surface.input", "text.primary", "text.secondary", "focus.ring", "radius.medium", "SpacingToken.rowGap"]
    case .feedback, .overlay:
        ["surface.overlay", "state.info", "state.warning", "state.danger", "ElevationToken.raised", "MotionToken.modalPresence"]
    case .content, .data:
        ["surface.grouped", "surface.raised", "text.primary", "text.secondary", "chart.blue", "chart.teal"]
    case .ai:
        ["surface.raised", "accent.primary", "text.muted", "radius.extraLarge", "SpacingToken.composerPadding"]
    case .tutorial, .utility, .specialized:
        ["surface.grouped", "surface.input", "text.primary", "text.secondary", "radius.large"]
    }
}

private func dos(for seed: ComponentSeed) -> [String] {
    switch seed.previewGroup {
    case .shell, .navigation:
        [
            "Do keep \(seed.name.lowercased()) compact and structural so the workspace remains primary.",
            "Do use subdued backgrounds and rounded selection treatment instead of loud fills."
        ]
    case .form, .selection:
        [
            "Do pair labels, descriptions, and validation in a consistent row rhythm.",
            "Do preserve keyboard access and a visible focus treatment."
        ]
    case .feedback, .overlay:
        [
            "Do make the message or consequence immediately clear.",
            "Do use semantic status color as support, not as the only signal."
        ]
    default:
        [
            "Do let spacing and hierarchy communicate structure before adding more containers.",
            "Do keep the component visually tied to the calibrated shell."
        ]
    }
}

private func donts(for seed: ComponentSeed) -> [String] {
    switch seed.previewGroup {
    case .shell, .navigation:
        [
            "Don't turn \(seed.name.lowercased()) into a marketing-style hero surface.",
            "Don't add extra shadows or gradients just to create emphasis."
        ]
    case .form, .selection:
        [
            "Don't rely on placeholder text as the primary label.",
            "Don't compress density so far that controls lose clarity."
        ]
    case .feedback, .overlay:
        [
            "Don't hide destructive consequences behind vague labels.",
            "Don't force users to parse color alone to understand status."
        ]
    default:
        [
            "Don't wrap \(seed.name.lowercased()) in redundant cards.",
            "Don't drift away from the calibrated neutral palette."
        ]
    }
}

private func componentRelatedPatterns(for seed: ComponentSeed) -> [String] {
    switch seed.category {
    case .shellNavigation:
        ["Workspace navigation", "Secondary panels", "Hero header"]
    case .inputSelection:
        ["Selection in forms", "Filtering patterns", "Communicating unsaved changes"]
    case .feedbackOverlay:
        ["User feedback", "Errors", "Announcing new features"]
    case .collectionContent:
        ["Workspace dashboard", "Data visualization", "Loading and refreshing"]
    case .specialized:
        ["Help system", "Onboarding", "Drag-and-drop"]
    }
}

private func writingGuidelines(for seed: ComponentSeed) -> [String] {
    [
        "Prefer direct labels and short supporting text.",
        "Keep action labels verb-led and specific.",
        "Use calm, operational language that matches a desktop work environment."
    ]
}

private func engineeringNotes(for seed: ComponentSeed) -> [String] {
    [
        "Use semantic tokens instead of view-local literals.",
        "Favor composable SwiftUI primitives so density and theme changes flow through the tree.",
        "Keep previews and production usage on the same component contract."
    ]
}

private func usageGuidelines(for seed: ComponentSeed) -> [UsageGuideline] {
    [
        .init(
            title: "Primary usage",
            body: "Use \(seed.name.lowercased()) when the interaction benefits from the design-system shell language instead of standalone card styling."
        ),
        .init(
            title: "Composition",
            body: "Prefer grouping \(seed.name.lowercased()) inside long-form panels, structured lists, or shell regions so it inherits the product hierarchy."
        ),
        .init(
            title: "Copy tone",
            body: "Keep labels and helper text practical and operational rather than promotional."
        )
    ]
}

private func antiPatterns(for seed: ComponentSeed) -> [String] {
    [
        "Do not restyle \(seed.name.lowercased()) with decorative gradients or loud shadows.",
        "Do not introduce a second accent color to compensate for weak hierarchy.",
        "Do not wrap \(seed.name.lowercased()) in an extra card if grouping or spacing already solves the layout."
    ]
}

private func macNotes(for seed: ComponentSeed) -> [String] {
    switch seed.previewGroup {
    case .shell, .toolbar, .navigation:
        ["Align with macOS desktop expectations: dense navigation, precise selection affordances, and restrained window-like framing."]
    case .form, .selection:
        ["Favor desktop-ready control sizing, keyboard access, and right-aligned control placement where settings-style layouts call for it."]
    case .utility, .data:
        ["Use monospaced and metadata treatments sparingly so utility surfaces feel native to the shell rather than like imported inspectors."]
    default:
        ["Preserve the macOS desktop tone by keeping interactions direct, low-chrome, and fast."]
    }
}

private func structuredContent(for seed: ComponentSeed) -> StructuredContentGuidance {
    let operationalLabel = seed.name.lowercased()

    return .init(
        actionLabels: [
            "Prefer direct labels that describe the user outcome for \(operationalLabel) rather than implementation jargon.",
            "Use verb-led labels when \(operationalLabel) performs work and noun-led labels only when it is a destination or mode."
        ],
        helperText: [
            "Use helper text to explain what \(operationalLabel) affects before the user makes a mistake.",
            "Keep helper text short enough to scan in compact density."
        ],
        validationCopy: [
            "Tie validation to the specific \(operationalLabel) state that needs to change.",
            "Name the fix directly instead of describing a generic failure."
        ],
        errorCopy: [
            "State what blocked \(operationalLabel) and what the user can do next.",
            "Avoid vague errors that do not name the affected surface or field."
        ],
        confirmations: [
            "Confirm the outcome of \(operationalLabel) with factual language such as Saved, Applied, or Updated.",
            "Include a next step only when the user still needs to act."
        ],
        destructiveActions: [
            "Use destructive wording only when \(operationalLabel) can remove, reset, or disconnect real data or state.",
            "Name the consequence explicitly."
        ],
        emptyStates: [
            "If \(operationalLabel) can render empty, explain why nothing is shown and offer one clear next step.",
            "Keep the title short and operational."
        ],
        announcements: [
            "Announcements involving \(operationalLabel) should say what changed, who it affects, and what action is available.",
            "Keep live status concise enough for repeated exposure."
        ],
        localization: [
            "Avoid idioms and unstable shorthand in \(operationalLabel) labels and supporting copy.",
            "Keep status language easy to localize."
        ],
        terminology: [
            "Use one canonical term for the main \(operationalLabel) concept across the docs, code examples, and showcase.",
            "Do not switch between overlapping nouns unless the product meaning changes."
        ],
        aiGeneratedContent: [
            "If \(operationalLabel) presents machine-generated output, distinguish prompt, generated content, and next-step actions clearly.",
            "Do not imply certainty when content is draft or model-generated."
        ]
    )
}

private func slug(_ value: String) -> String {
    value
        .lowercased()
        .replacingOccurrences(of: "(", with: "")
        .replacingOccurrences(of: ")", with: "")
        .replacingOccurrences(of: "-", with: "")
        .replacingOccurrences(of: " ", with: "-")
}

private func swiftUITypeName(for name: String) -> String {
    let specialCases: [String: String] = [
        "Area chart": "AreaChartPanel",
        "File uploading components": "FileUploadingComponentsView",
        "File picker button": "FilePickerButton",
        "File token group": "FileTokenGroup",
        "File upload field": "FileUploadField",
        "Generative AI components": "GenerativeAIComponentsView",
        "Resource selector": "ResourceSelectorView",
        "Copy to clipboard": "CopyToClipboardView",
        "Help panel": "HelpPanel",
        "Loading bar": "LoadingBar",
        "Key-value pairs": "KeyValuePairsView",
        "Empty state": "EmptyStateView",
        "Text area": "TextAreaView",
        "Text filter": "TextFilterView",
        "Top navigation": "TopNavigationView",
        "Side navigation": "SideNavigationView",
        "App layout": "AppLayoutView",
        "App layout toolbar": "AppLayoutToolbarView",
        "Avatar": "AvatarView",
        "Bar chart": "BarChartPanel",
        "Board": "BoardView",
        "Board item": "BoardItemView",
        "Chat bubble": "ChatBubble",
        "Donut chart": "DonutChartPanel",
        "Items palette": "ItemsPalette",
        "Line chart": "LineChartPanel",
        "Mixed chart": "MixedChartPanel",
        "Prompt input": "PromptInput",
        "Support prompt group": "SupportPromptGroup",
        "Tutorial components": "TutorialComponentsView",
        "Tutorial panel": "TutorialPanel"
    ]

    if let specialCase = specialCases[name] {
        return specialCase
    }

    let joined = name
        .replacingOccurrences(of: "(", with: "")
        .replacingOccurrences(of: ")", with: "")
        .split(separator: " ")
        .map { $0.prefix(1).uppercased() + $0.dropFirst() }
        .joined()

    return "\(joined)View"
}
