import Foundation
import BuilderReferenceExamples

private struct PatternSeed {
    let name: String
    let category: PatternCategory
    let previewGroup: PatternPreviewGroup
}

private let patternSeeds: [PatternSeed] = [
    .init(name: "General", category: .general, previewGroup: .actionFlow),
    .init(name: "Actions", category: .general, previewGroup: .actionFlow),
    .init(name: "Announcing new features", category: .messaging, previewGroup: .announcement),
    .init(name: "Announcing beta and preview features", category: .messaging, previewGroup: .announcement),
    .init(name: "Communicating unsaved changes", category: .workflow, previewGroup: .unsavedChanges),
    .init(name: "Data visualization", category: .data, previewGroup: .dataVisualization),
    .init(name: "Density settings", category: .data, previewGroup: .density),
    .init(name: "Disabled and read-only states", category: .workflow, previewGroup: .stateHandling),
    .init(name: "Drag-and-drop", category: .workflow, previewGroup: .dragAndDrop),
    .init(name: "Errors", category: .workflow, previewGroup: .stateHandling),
    .init(name: "Empty states", category: .workflow, previewGroup: .stateHandling),
    .init(name: "Feedback mechanisms", category: .messaging, previewGroup: .timeAndFeedback),
    .init(name: "Filtering patterns", category: .data, previewGroup: .filtering),
    .init(name: "Hero header", category: .general, previewGroup: .hero),
    .init(name: "Help system", category: .navigation, previewGroup: .support),
    .init(name: "Image magnifier", category: .workflow, previewGroup: .support),
    .init(name: "Loading and refreshing", category: .workflow, previewGroup: .loading),
    .init(name: "Onboarding", category: .workflow, previewGroup: .onboarding),
    .init(name: "Selection in forms", category: .workflow, previewGroup: .actionFlow),
    .init(name: "Workspace navigation", category: .navigation, previewGroup: .navigation),
    .init(name: "Workspace dashboard", category: .navigation, previewGroup: .dashboard),
    .init(name: "Secondary panels", category: .navigation, previewGroup: .navigation),
    .init(name: "Timestamps", category: .messaging, previewGroup: .timeAndFeedback),
    .init(name: "User feedback", category: .messaging, previewGroup: .timeAndFeedback)
]

extension CatalogContent {
    package static let patterns: [PatternCatalogEntry] = patternSeeds.map(buildPattern)
}

private func buildPattern(_ seed: PatternSeed) -> PatternCatalogEntry {
    PatternCatalogEntry(
        id: patternSlug(seed.name),
        name: seed.name,
        category: seed.category,
        whenToUse: whenToUse(for: seed),
        requiredComponents: requiredComponents(for: seed),
        layoutRecipe: layoutRecipe(for: seed),
        copyTone: copyTone(for: seed),
        criteria: criteria(for: seed),
        configurations: configurations(for: seed),
        generalGuidelines: generalGuidelines(for: seed),
        accessibilityAndMotion: accessibilityAndMotion(for: seed),
        darkLightConsiderations: darkLightConsiderations(for: seed),
        relatedPatterns: patternRelatedPatterns(for: seed),
        screenshotLanguage: screenshotLanguage(for: seed),
        previewGroup: seed.previewGroup,
        contentGuidance: contentGuidance(for: seed),
        structuredContent: structuredContent(for: seed),
        canonicalExampleID: .init(rawValue: patternSlug(seed.name)),
        accessibilityAcceptance: accessibilityAcceptance(for: seed)
    )
}

private func accessibilityAcceptance(for seed: PatternSeed) -> AccessibilityAcceptance {
    .init(semantics: true, keyboard: true, contrast: true, motion: true, messaging: true)
}

private func whenToUse(for seed: PatternSeed) -> String {
    switch seed.previewGroup {
    case .announcement:
        "Use this pattern when the product needs to introduce capability without turning the shell into a marketing surface."
    case .unsavedChanges:
        "Use this pattern when user work is at risk and the interface must communicate state clearly without panic."
    case .dataVisualization:
        "Use this pattern for analytical or operational views that need charts to sit comfortably inside the system shell."
    case .density:
        "Use this pattern when the product lets users adapt information density while keeping the design language intact."
    case .stateHandling:
        "Use this pattern whenever the interface needs to show disabled, read-only, empty, or error conditions without losing orientation."
    case .dragAndDrop:
        "Use this pattern when rearrangement or file intake should feel spatially obvious on desktop."
    case .filtering:
        "Use this pattern when users need to narrow content with fast, composable controls."
    case .hero:
        "Use this pattern only when a strong opening state improves orientation; keep it utility-led rather than marketing-led."
    case .support:
        "Use this pattern when contextual help or inspection should sit adjacent to work instead of interrupting it."
    case .loading:
        "Use this pattern to show work-in-progress, refreshes, and incremental updates while preserving layout stability."
    case .onboarding:
        "Use this pattern when the first-run journey needs structured guidance inside the same visual system."
    case .navigation:
        "Use this pattern when the shell needs to frame multiple areas, tools, or secondary panels coherently."
    case .dashboard:
        "Use this pattern when status, charts, and lists share a common operating surface."
    case .timeAndFeedback, .actionFlow:
        "Use this pattern when the UI needs clear action sequencing, recency, or response feedback without extra ornament."
    }
}

private func requiredComponents(for seed: PatternSeed) -> [String] {
    switch seed.previewGroup {
    case .announcement:
        ["Notice stack", "Badge", "Link", "Button"]
    case .unsavedChanges:
        ["Modal", "Status indicator", "Button group", "Form"]
    case .dataVisualization:
        ["Charts", "Table", "Tabs", "Segmented control"]
    case .density:
        ["App layout toolbar", "Segmented control", "Table", "Form field"]
    case .stateHandling:
        ["Alert", "Status indicator", "Empty states", "Spinner"]
    case .dragAndDrop:
        ["Board", "File uploading components", "Tiles"]
    case .filtering:
        ["Property filter", "Text filter", "Filter select", "Table"]
    case .hero:
        ["Header", "Text content", "Button"]
    case .support:
        ["Context panel", "Popover", "Drawer"]
    case .loading:
        ["Spinner", "Progress bar", "Notice stack"]
    case .onboarding:
        ["Wizard", "Steps", "Tutorial components"]
    case .navigation:
        ["Side navigation", "Top navigation", "Split panel"]
    case .dashboard:
        ["App layout", "Charts", "Table", "Cards"]
    case .timeAndFeedback, .actionFlow:
        ["Button", "Status indicator", "Live region", "Link"]
    }
}

private func layoutRecipe(for seed: PatternSeed) -> [String] {
    [
        "Start from the shell or grouped settings surface instead of a standalone marketing-style page.",
        "Establish one dominant area of work, then add secondary context or feedback surfaces as needed.",
        "Use spacing and subtle separators to communicate structure before adding new containers."
    ]
}

private func copyTone(for seed: PatternSeed) -> String {
    switch seed.previewGroup {
    case .announcement:
        "Direct and informative. Describe what changed, who it is for, and what action is available in one short sentence."
    case .hero:
        "Orienting rather than aspirational. The opening line should explain the workspace or next action."
    default:
        "Utility-first product language. Labels, headings, and helper copy should help someone operate or decide quickly."
    }
}

private func contentGuidance(for seed: PatternSeed) -> [String] {
    switch seed.previewGroup {
    case .announcement:
        [
            "State what changed, who it affects, and what action is available.",
            "Keep announcement copy short enough to scan in a dense desktop shell."
        ]
    case .unsavedChanges:
        [
            "Name the consequence directly and pair it with save, discard, and cancel actions.",
            "Avoid language that sounds punitive or vague."
        ]
    case .filtering, .dataVisualization:
        [
            "Use explicit labels for filters, scopes, and data groupings.",
            "Summarize what the data shows before diving into dense details."
        ]
    case .hero:
        [
            "Lead with orientation and next action, not promotional language.",
            "Keep the supporting sentence operational and concise."
        ]
    default:
        [
            "Use utility-first language that explains the current state or next action.",
            "Keep feedback and helper copy short enough for repeated exposure."
        ]
    }
}

private func structuredContent(for seed: PatternSeed) -> StructuredContentGuidance {
    let patternName = seed.name.lowercased()

    return .init(
        actionLabels: [
            "Keep action labels inside the \(patternName) pattern direct and role-specific.",
            "Let the primary action read as the next obvious step."
        ],
        helperText: [
            "Use helper text to orient the user inside the \(patternName) flow before friction appears.",
            "Keep supporting guidance tied to the current step or state."
        ],
        validationCopy: [
            "Validation in the \(patternName) pattern should explain the exact recovery path.",
            "Connect validation text to the local field or grouped summary that needs attention."
        ],
        errorCopy: [
            "Error copy for \(patternName) should name the issue and preserve orientation.",
            "Avoid generic failure language that does not say what to do next."
        ],
        confirmations: [
            "Use confirmations to state what changed inside the \(patternName) flow and whether follow-up is still required.",
            "Keep confirmations factual and short."
        ],
        destructiveActions: [
            "Reserve destructive wording for actions in \(patternName) that truly remove work, data, or access.",
            "Make the consequence explicit before the action is taken."
        ],
        emptyStates: [
            "If the \(patternName) pattern can render empty or no-result states, explain why and suggest one recovery action.",
            "Do not let empty-state copy become decorative filler."
        ],
        announcements: [
            "Announcements related to \(patternName) should describe the state change and what it means for the current workflow.",
            "Keep announcement copy operational rather than promotional."
        ],
        localization: [
            "Keep the \(patternName) pattern free of idioms and unstable shorthand.",
            "Use date, time, and status language that can be localized cleanly."
        ],
        terminology: [
            "Use the same nouns for the same concepts throughout the \(patternName) recipe, docs, and examples.",
            "Avoid switching between synonyms that blur the workflow."
        ],
        aiGeneratedContent: [
            "If the \(patternName) flow includes generated content, clearly separate authored input, generated output, and review actions.",
            "Make certainty and ownership explicit."
        ]
    )
}

private func accessibilityAndMotion(for seed: PatternSeed) -> [String] {
    [
        "Respect reduced motion by simplifying transitions to fades or no-op changes.",
        "Do not communicate critical state through color alone.",
        "Preserve keyboard traversal across all participating components."
    ]
}

private func darkLightConsiderations(for seed: PatternSeed) -> [String] {
    [
        "Keep hierarchy identical between themes so the pattern feels like the same product in different lighting.",
        "Tune border and muted-text contrast per theme instead of reworking the layout."
    ]
}

private func criteria(for seed: PatternSeed) -> [String] {
    switch seed.previewGroup {
    case .navigation:
        ["Structural navigation must stay persistent and predictable.", "Global utilities should remain discoverable without crowding the workspace."]
    case .dataVisualization, .dashboard:
        ["At-a-glance status should be readable before drilling into detail.", "Charts and tables must share the same token system."]
    case .onboarding, .actionFlow:
        ["The next action should always be obvious.", "Step or state progression must stay visible."]
    default:
        ["The pattern should reduce decision friction.", "The layout should preserve the shell's calm hierarchy."]
    }
}

private func configurations(for seed: PatternSeed) -> [String] {
    switch seed.previewGroup {
    case .navigation:
        ["Top + side navigation", "Side navigation only", "Top navigation only"]
    case .support:
        ["Inline help", "Popover help", "Persistent help panel"]
    case .loading:
        ["Inline refresh", "Blocking loading state", "Background progress state"]
    case .announcement:
        ["Inline announcement", "Dismissible banner", "Badge-linked entry point"]
    default:
        ["Primary configuration", "Dense variant", "Secondary-context variant"]
    }
}

private func generalGuidelines(for seed: PatternSeed) -> [String] {
    [
        "Keep one dominant area of work and use secondary regions sparingly.",
        "Use grouped surfaces and spacing before introducing additional chrome.",
        "Keep copy utility-first and aligned with the calibrated screenshot language."
    ]
}

private func patternRelatedPatterns(for seed: PatternSeed) -> [String] {
    switch seed.previewGroup {
    case .navigation:
        ["Secondary panels", "Help system", "Hero header"]
    case .dataVisualization, .dashboard:
        ["Workspace dashboard", "Filtering patterns", "Loading and refreshing"]
    case .announcement, .timeAndFeedback:
        ["User feedback", "Announcing beta and preview features", "Timestamps"]
    case .actionFlow, .onboarding:
        ["Selection in forms", "Communicating unsaved changes", "Actions"]
    default:
        ["General", "User feedback", "Loading and refreshing"]
    }
}

private func screenshotLanguage(for seed: PatternSeed) -> [String] {
    [
        "Stay aligned with the screenshots' low-chrome shell and restrained blue accent.",
        "Prefer grouped panels, long-form rows, and calm empty space over generic dashboard cards."
    ]
}

private func patternSlug(_ value: String) -> String {
    value
        .lowercased()
        .replacingOccurrences(of: "(", with: "")
        .replacingOccurrences(of: ")", with: "")
        .replacingOccurrences(of: "-", with: "")
        .replacingOccurrences(of: " ", with: "-")
}
