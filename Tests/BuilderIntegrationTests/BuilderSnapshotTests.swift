import SwiftUI
import UniformTypeIdentifiers
import XCTest
import BuilderFoundation
import BuilderComponents
@testable import BuilderShowcase

@MainActor
final class BuilderSnapshotTests: XCTestCase {
    func testShowcaseRouteSnapshots() {
        let dark = ShowcaseModel()
        dark.themeMode = .dark

        let light = ShowcaseModel()
        light.themeMode = .light

        SnapshotTestSupport.assertSnapshot(
            matching: HomeView(env: dark.environment).environmentObject(dark),
            named: "showcase-home-dark",
            size: CGSize(width: 1280, height: 900)
        )
        SnapshotTestSupport.assertSnapshot(
            matching: ComponentsCatalogView(env: dark.environment).environmentObject(dark),
            named: "showcase-components-dark",
            size: CGSize(width: 1400, height: 900)
        )
        SnapshotTestSupport.assertSnapshot(
            matching: FoundationsCatalogView(env: dark.environment).environmentObject(dark),
            named: "showcase-foundations-dark",
            size: CGSize(width: 1400, height: 900)
        )
        SnapshotTestSupport.assertSnapshot(
            matching: SettingsCatalogView(env: dark.environment).environmentObject(dark),
            named: "showcase-settings-dark",
            size: CGSize(width: 1400, height: 900)
        )

        SnapshotTestSupport.assertSnapshot(
            matching: HomeView(env: light.environment).environmentObject(light),
            named: "showcase-home-light",
            size: CGSize(width: 1280, height: 900)
        )
        SnapshotTestSupport.assertSnapshot(
            matching: ComponentsCatalogView(env: light.environment).environmentObject(light),
            named: "showcase-components-light",
            size: CGSize(width: 1400, height: 900)
        )
        SnapshotTestSupport.assertSnapshot(
            matching: FoundationsCatalogView(env: light.environment).environmentObject(light),
            named: "showcase-foundations-light",
            size: CGSize(width: 1400, height: 900)
        )
        light.selectedSettingsSection = .themeTokens
        SnapshotTestSupport.assertSnapshot(
            matching: SettingsCatalogView(env: light.environment).environmentObject(light),
            named: "showcase-settings-light",
            size: CGSize(width: 1400, height: 900)
        )
    }

    func testComponentStateGallerySnapshots() {
        let darkEnvironment = DesignSystemEnvironment(
            theme: AppTheme(mode: .dark, contrast: .standard),
            mode: .dark,
            contrast: .standard,
            density: .compact,
            visualContext: .editorComposer,
            reduceMotion: false,
            highContrast: false
        )
        let lightEnvironment = DesignSystemEnvironment(
            theme: AppTheme(mode: .light, contrast: .standard),
            mode: .light,
            contrast: .standard,
            density: .compact,
            visualContext: .editorComposer,
            reduceMotion: false,
            highContrast: false
        )

        SnapshotTestSupport.assertSnapshot(
            matching: ComponentStateGallery(environment: darkEnvironment),
            named: "component-state-gallery-dark",
            size: CGSize(width: 960, height: 420)
        )
        SnapshotTestSupport.assertSnapshot(
            matching: ComponentStateGallery(environment: lightEnvironment),
            named: "component-state-gallery-light",
            size: CGSize(width: 960, height: 420)
        )
    }

    func testAdvancedComponentGallerySnapshots() {
        let darkEnvironment = DesignSystemEnvironment.preview(
            .dark,
            density: .compact,
            visualContext: .editorComposer,
            reduceMotion: true
        )
        let lightEnvironment = DesignSystemEnvironment.preview(
            .light,
            density: .default,
            visualContext: .editorComposer,
            reduceMotion: true
        )

        SnapshotTestSupport.assertSnapshot(
            matching: AdvancedComponentGallery(environment: darkEnvironment),
            named: "component-advanced-gallery-dark",
            size: CGSize(width: 1400, height: 1220)
        )
        SnapshotTestSupport.assertSnapshot(
            matching: AdvancedComponentGallery(environment: lightEnvironment),
            named: "component-advanced-gallery-light",
            size: CGSize(width: 1400, height: 1220)
        )
    }

    func testChartBehaviorSnapshots() {
        let darkEnvironment = DesignSystemEnvironment.preview(
            .dark,
            density: .compact,
            visualContext: .editorComposer,
            reduceMotion: true
        )
        let lightEnvironment = DesignSystemEnvironment.preview(
            .light,
            density: .default,
            visualContext: .editorComposer,
            reduceMotion: true
        )

        SnapshotTestSupport.assertSnapshot(
            matching: ChartBehaviorGallery(environment: darkEnvironment),
            named: "component-chart-behavior-dark",
            size: CGSize(width: 1400, height: 760)
        )
        SnapshotTestSupport.assertSnapshot(
            matching: ChartBehaviorGallery(environment: lightEnvironment),
            named: "component-chart-behavior-light",
            size: CGSize(width: 1400, height: 760)
        )
    }

    func testCollectionBehaviorSnapshots() {
        let darkEnvironment = DesignSystemEnvironment.preview(
            .dark,
            density: .compact,
            visualContext: .editorComposer,
            reduceMotion: true
        )
        let lightEnvironment = DesignSystemEnvironment.preview(
            .light,
            density: .default,
            visualContext: .editorComposer,
            reduceMotion: true
        )

        SnapshotTestSupport.assertSnapshot(
            matching: CollectionBehaviorGallery(environment: darkEnvironment),
            named: "component-collection-behavior-dark",
            size: CGSize(width: 1400, height: 900)
        )
        SnapshotTestSupport.assertSnapshot(
            matching: CollectionBehaviorGallery(environment: lightEnvironment),
            named: "component-collection-behavior-light",
            size: CGSize(width: 1400, height: 900)
        )
    }

    func testGuidedBehaviorSnapshots() {
        let darkEnvironment = DesignSystemEnvironment.preview(
            .dark,
            density: .compact,
            visualContext: .editorComposer,
            reduceMotion: true
        )
        let lightEnvironment = DesignSystemEnvironment.preview(
            .light,
            density: .default,
            visualContext: .editorComposer,
            reduceMotion: true
        )

        SnapshotTestSupport.assertSnapshot(
            matching: GuidedBehaviorGallery(environment: darkEnvironment),
            named: "component-guided-behavior-dark",
            size: CGSize(width: 1400, height: 920)
        )
        SnapshotTestSupport.assertSnapshot(
            matching: GuidedBehaviorGallery(environment: lightEnvironment),
            named: "component-guided-behavior-light",
            size: CGSize(width: 1400, height: 920)
        )
    }
}

private struct ComponentStateGallery: View {
    let environment: DesignSystemEnvironment
    @State private var text = "Builder workspace"
    @State private var notes = "Read-only draft"
    @State private var choice = "automatic"

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 12) {
                SystemButton(environment: environment, title: "Primary", tone: .primary) {}
                SystemButton(environment: environment, title: "Loading", tone: .primary, isLoading: true) {}
                SystemButton(environment: environment, title: "Disabled", tone: .secondary, isEnabled: false) {}
            }

            TextInputField(
                environment: environment,
                placeholder: "Name",
                text: $text,
                status: .error,
                message: "Resolve the field before continuing."
            )

            TextAreaField(
                environment: environment,
                placeholder: "Notes",
                text: $notes,
                status: .warning,
                message: "This content is currently locked.",
                isReadOnly: true,
                isEnabled: false
            )

            HStack(spacing: 12) {
                ToggleSwitch(environment: environment, title: "Background sync", isOn: .constant(true), isLoading: true)
                Checkbox(environment: environment, title: "Apply to all", isOn: .constant(false), isMixed: true, isEnabled: false)
            }

            SelectMenu(
                environment: environment,
                options: [
                    .init(label: "Automatic", value: "automatic"),
                    .init(label: "Pinned", value: "pinned")
                ],
                selection: $choice,
                isEnabled: false
            )

            AlertBanner(
                environment: environment,
                title: "Needs review",
                message: "Dismiss and action affordances should coexist clearly.",
                tone: .warning,
                actionTitle: "Inspect",
                action: {},
                isDismissible: true,
                onDismiss: {}
            )
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(environment.theme.color(.workspaceBackground))
    }
}

private struct AdvancedComponentGallery: View {
    let environment: DesignSystemEnvironment
    @State private var prompt = "Summarize the latest system changes."
    @State private var selectedHelpTopicID: String? = "context"
    @State private var currentTutorialStepID = "build"
    @State private var selectedBoardItemID: String? = "alert"
    @State private var selectedPaletteItemID: String? = "metric-card"
    @State private var isUploadTargeted = false

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 18) {
                BarChartPanel(
                    environment: environment,
                    title: "Coverage",
                    series: [
                        .init(title: "Coverage", color: environment.theme.color(.chartBlue), points: [
                            .init(label: "Tokens", value: 82),
                            .init(label: "Components", value: 80),
                            .init(label: "Patterns", value: 24)
                        ])
                    ]
                )
                .frame(maxWidth: .infinity)

                LineChartPanel(
                    environment: environment,
                    title: "Adoption trend",
                    series: [
                        .init(title: "Adoption", color: environment.theme.color(.chartTeal), points: [
                            .init(label: "Mon", value: 42),
                            .init(label: "Tue", value: 48),
                            .init(label: "Wed", value: 55),
                            .init(label: "Thu", value: 61)
                        ])
                    ]
                )
                .frame(maxWidth: .infinity)
            }

            HStack(alignment: .top, spacing: 18) {
                DonutChartPanel(
                    environment: environment,
                    title: "Status mix",
                    slices: [
                        .init(title: "Ready", value: 18, color: environment.theme.color(.chartGreen)),
                        .init(title: "Review", value: 7, color: environment.theme.color(.chartAmber)),
                        .init(title: "Blocked", value: 3, color: environment.theme.color(.chartRed))
                    ]
                )
                .frame(width: 320)

                MixedChartPanel(
                    environment: environment,
                    title: "Coverage vs target",
                    barSeries: [
                        .init(title: "Coverage", color: environment.theme.color(.chartPurple), points: [
                            .init(label: "Tokens", value: 82),
                            .init(label: "Docs", value: 74),
                            .init(label: "Patterns", value: 24)
                        ])
                    ],
                    lineSeries: [
                        .init(title: "Target", color: environment.theme.color(.chartTeal), points: [
                            .init(label: "Tokens", value: 90),
                            .init(label: "Docs", value: 85),
                            .init(label: "Patterns", value: 48)
                        ])
                    ]
                )
                .frame(maxWidth: .infinity)
            }

            HStack(alignment: .top, spacing: 18) {
                VStack(alignment: .leading, spacing: 14) {
                    HelpPanel(
                        environment: environment,
                        title: "Guidance",
                        subtitle: "Keep help adjacent to the active task.",
                        topics: guidedHelpTopics,
                        selectedTopicID: $selectedHelpTopicID
                    ) {
                        Text(guidedHelpCopy(selectedHelpTopicID))
                            .font(environment.theme.typography(.body).font)
                            .foregroundStyle(environment.theme.color(.textSecondary))
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        LoadingBar(environment: environment, label: "Indexing references", detail: "Duration is not yet known.")
                        ProgressBar(environment: environment, value: 0.66, label: "Publishing docs")
                        EmptyStateView(
                            environment: environment,
                            title: "No matching surfaces",
                            message: "Clear the current filter to restore the full library."
                        )
                    }
                }
                .frame(maxWidth: .infinity)

                FileUploadField(
                    environment: environment,
                    title: "Attach release notes",
                    subtitle: "Presentation belongs to the system; drop handling and item state stay with the consumer.",
                    dropTitle: "Drop release notes",
                    dropDetail: "Accept Markdown, PDF, and image files.",
                    items: collectionUploadItems,
                    acceptedContentTypes: [.plainText, .pdf, .image],
                    isTargeted: $isUploadTargeted,
                    onDropURLs: { _ in },
                    onPick: {},
                    onRetry: { _ in }
                ) { _ in }
                .frame(maxWidth: .infinity)
            }

            HStack(alignment: .top, spacing: 18) {
                Board(
                    environment: environment,
                    columns: advancedBoardColumns(environment: environment),
                    selectedItemID: $selectedBoardItemID,
                    onActivateItem: { item in
                        selectedBoardItemID = item.id
                    },
                    onMoveItem: { itemID, _, _ in
                        selectedBoardItemID = itemID
                    }
                )
                .frame(maxWidth: .infinity)

                ItemsPalette(
                    environment: environment,
                    items: collectionPaletteItems(environment: environment),
                    selectedItemID: $selectedPaletteItemID,
                    insertDestinations: advancedInsertDestinations(environment: environment),
                    onActivateItem: { item in
                        selectedPaletteItemID = item.id
                    },
                    onInsertItem: { item, _, _ in
                        selectedPaletteItemID = item.id
                    }
                )
                .frame(width: 320)
            }

            HStack(alignment: .top, spacing: 18) {
                PanelSurface(environment: environment, title: "AI review", subtitle: "Keep prompt, output, and follow-up actions explicit.") {
                    PromptInput(
                        environment: environment,
                        prompt: $prompt,
                        actionTitle: "Draft",
                        supportingText: "Command-Return submits. Keep authored input visible while the draft is generating.",
                        isSubmitting: true,
                        isMultiline: true,
                        submitShortcutBehavior: .commandReturn,
                        secondaryActionTitle: "Clear",
                        secondaryActionSymbol: "xmark",
                        onSecondaryAction: {
                            prompt = ""
                        }
                    ) {}
                    SupportPromptGroup(
                        environment: environment,
                        prompts: [
                            .init(id: "summarize", title: "Summarize", detail: "Condense the latest changes.", isSelected: true, isRecommended: true),
                            .init(id: "find-gaps", title: "Find gaps", detail: "Inspect missing inventory."),
                            .init(id: "compare", title: "Explain tradeoffs", detail: "Compare candidate APIs.", isEnabled: false)
                        ]
                    ) { selected in
                        prompt = selected.title
                    }
                    ChatBubble(
                        environment: environment,
                        role: .assistant,
                        author: "Builder assistant",
                        message: "The design system now covers metrics, status, help, file upload, AI, and tutorial surfaces.",
                        detail: "Draft output is still streaming into the review surface.",
                        state: .streaming,
                        footerMetadata: [
                            .init(label: "Model", value: "Builder review"),
                            .init(label: "Updated", value: "Now")
                        ],
                        showsCopyAction: true
                    )
                }
                .frame(maxWidth: .infinity)

                TutorialPanel(
                    environment: environment,
                    title: "Rollout guidance",
                    subtitle: "Keep progression visible without leaving the current workflow.",
                    steps: [
                        .init(id: "audit", title: "Audit", detail: "Review API shape."),
                        .init(id: "build", title: "Build", detail: "Add reusable surfaces."),
                        .init(id: "verify", title: "Verify", detail: "Run validation.", status: .warning, isOptional: true)
                    ],
                    currentStepID: $currentTutorialStepID,
                    completedStepIDs: ["audit"]
                ) {
                    Text("Guide teams into the system without changing the shell language.")
                        .font(environment.theme.typography(.body).font)
                        .foregroundStyle(environment.theme.color(.textSecondary))
                } primaryActions: {
                    SystemButton(environment: environment, title: "Continue", tone: .primary) {}
                } secondaryActions: {
                    SystemButton(environment: environment, title: "Back", tone: .secondary) {}
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(environment.theme.color(.workspaceBackground))
    }
}

private struct CollectionBehaviorGallery: View {
    let environment: DesignSystemEnvironment
    @State private var isTargeted = true
    @State private var selectedBoardItemID: String? = "review-docs"
    @State private var selectedPaletteItemID: String? = "metric-card"

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 18) {
                FileDropZone(
                    environment: environment,
                    title: "Drop release notes",
                    detail: "Accept Markdown, PDF, and image files.",
                    state: .ready,
                    acceptedContentTypes: [.plainText, .pdf, .image],
                    isTargeted: $isTargeted,
                    onDropURLs: { _ in },
                    actionTitle: "Browse",
                    action: {}
                )
                .frame(maxWidth: .infinity)

                FileUploadField(
                    environment: environment,
                    title: "Attach release notes",
                    subtitle: "Keep upload logic in the consumer while the system presents status, retry, and removal states.",
                    dropTitle: "Drop release notes",
                    dropDetail: "Or browse from disk.",
                    items: collectionUploadItems,
                    state: .ready,
                    acceptedContentTypes: [.plainText, .pdf, .image],
                    isTargeted: .constant(false),
                    onDropURLs: { _ in },
                    onPick: {},
                    onRetry: { _ in },
                    onRemove: { _ in }
                )
                .frame(maxWidth: .infinity)
            }

            HStack(alignment: .top, spacing: 18) {
                Board(
                    environment: environment,
                    columns: collectionBoardColumns(environment: environment),
                    selectedItemID: $selectedBoardItemID,
                    onActivateItem: { item in
                        selectedBoardItemID = item.id
                    },
                    onMoveItem: { itemID, _, _ in
                        selectedBoardItemID = itemID
                    }
                )
                .frame(maxWidth: .infinity)

                ItemsPalette(
                    environment: environment,
                    title: "Insert items",
                    subtitle: "Explicit insert actions avoid hidden drag-only workflows.",
                    items: collectionPaletteItems(environment: environment),
                    selectedItemID: $selectedPaletteItemID,
                    insertDestinations: collectionInsertDestinations(environment: environment),
                    onActivateItem: { item in
                        selectedPaletteItemID = item.id
                    },
                    onInsertItem: { item, _, _ in
                        selectedPaletteItemID = item.id
                    }
                )
                .frame(width: 320)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(environment.theme.color(.workspaceBackground))
    }
}

private struct GuidedBehaviorGallery: View {
    let environment: DesignSystemEnvironment
    @State private var prompt = "Summarize the rollout risks and note any missing behavior depth."
    @State private var selectedHelpTopicID: String? = "recovery"
    @State private var currentStepID = "verify"

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 18) {
                PanelSurface(environment: environment, title: "Prompt composer", subtitle: "Submitting state and secondary actions should remain visible.") {
                    PromptInput(
                        environment: environment,
                        prompt: $prompt,
                        actionTitle: "Draft",
                        supportingText: "Command-Return submits. Keep authored input visible while the draft is generating.",
                        isSubmitting: true,
                        isMultiline: true,
                        submitShortcutBehavior: .commandReturn,
                        secondaryActionTitle: "Clear",
                        secondaryActionSymbol: "xmark",
                        onSecondaryAction: {
                            prompt = ""
                        }
                    ) {}

                    SupportPromptGroup(
                        environment: environment,
                        title: "Suggested prompts",
                        prompts: [
                            .init(id: "summarize", title: "Summarize", detail: "Condense the latest changes.", isSelected: true, isRecommended: true),
                            .init(id: "find-gaps", title: "Find gaps", detail: "Inspect missing inventory."),
                            .init(id: "compare", title: "Explain tradeoffs", detail: "Compare candidate APIs.", isEnabled: false)
                        ]
                    ) { selected in
                        prompt = selected.title
                    }
                }
                .frame(maxWidth: .infinity)

                PanelSurface(environment: environment, title: "Conversation state", subtitle: "Streaming and retry states should feel like first-class system surfaces.") {
                    ChatBubble(
                        environment: environment,
                        role: .assistant,
                        author: "Builder assistant",
                        message: "The rollout summary is still streaming into the review surface.",
                        detail: "Draft output is still streaming.",
                        state: .streaming,
                        footerMetadata: [
                            .init(label: "Model", value: "Builder review"),
                            .init(label: "Updated", value: "Now")
                        ],
                        showsCopyAction: true
                    )
                    ChatBubble(
                        environment: environment,
                        role: .assistant,
                        author: "Builder assistant",
                        message: "The token export summary could not load.",
                        detail: "Retry after the export job finishes.",
                        state: .error,
                        footerMetadata: [
                            .init(label: "Source", value: "Token export"),
                            .init(label: "Status", value: "Unavailable")
                        ],
                        onRetry: {}
                    )
                }
                .frame(maxWidth: .infinity)
            }

            HStack(alignment: .top, spacing: 18) {
                HelpPanel(
                    environment: environment,
                    title: "Guidance",
                    subtitle: "Topics should stay navigable without turning into a product-specific help center.",
                    topics: guidedHelpTopics,
                    selectedTopicID: $selectedHelpTopicID
                ) {
                    Text(guidedHelpCopy(selectedHelpTopicID))
                        .font(environment.theme.typography(.body).font)
                        .foregroundStyle(environment.theme.color(.textSecondary))
                }
                .frame(maxWidth: .infinity)

                TutorialPanel(
                    environment: environment,
                    title: "Rollout guidance",
                    subtitle: "Current step, completed work, and warning states should remain visible together.",
                    steps: [
                        .init(id: "audit", title: "Audit", detail: "Review API shape."),
                        .init(id: "build", title: "Build", detail: "Add reusable surfaces."),
                        .init(id: "verify", title: "Verify", detail: "Run validation before release.", status: .warning, isOptional: true)
                    ],
                    currentStepID: $currentStepID,
                    completedStepIDs: ["audit", "build"],
                    stepChangeAnnouncement: { step, index, total in
                        "Tutorial progress updated. Step \(index) of \(total): \(step.title)."
                    }
                ) {
                    Text("Guide teams into the system without changing the shell language.")
                        .font(environment.theme.typography(.body).font)
                        .foregroundStyle(environment.theme.color(.textSecondary))
                } primaryActions: {
                    SystemButton(environment: environment, title: "Continue", tone: .primary) {}
                } secondaryActions: {
                    SystemButton(environment: environment, title: "Back", tone: .secondary) {}
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(environment.theme.color(.workspaceBackground))
    }
}

private struct ChartBehaviorGallery: View {
    let environment: DesignSystemEnvironment
    @State private var selectedMetric: MetricSelection? = MetricSelection(
        kind: .point,
        seriesID: "Coverage",
        seriesTitle: "Coverage",
        datumID: "Tokens",
        label: "Tokens",
        value: 82,
        formattedValue: "82%"
    )
    @State private var visibleSeriesIDs: Set<String> = ["Coverage"]

    private var selectedPairs: [KeyValuePairs.Pair] {
        guard let selectedMetric else {
            return [
                .init(key: "Series", value: "Coverage"),
                .init(key: "Metric", value: "Tokens"),
                .init(key: "Value", value: "82%")
            ]
        }

        return [
            .init(key: "Series", value: selectedMetric.seriesTitle),
            .init(key: "Metric", value: selectedMetric.label),
            .init(key: "Value", value: selectedMetric.formattedValue)
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 18) {
                MixedChartPanel(
                    environment: environment,
                    title: "Coverage and target",
                    subtitle: "Pinned selection and legend filtering stay synchronized.",
                    state: .ready,
                    barSeries: [
                        .init(title: "Coverage", color: environment.theme.color(.chartBlue), points: [
                            .init(label: "Tokens", value: 82),
                            .init(label: "Docs", value: 74),
                            .init(label: "Patterns", value: 24)
                        ])
                    ],
                    lineSeries: [
                        .init(title: "Target", color: environment.theme.color(.chartTeal), points: [
                            .init(label: "Tokens", value: 90),
                            .init(label: "Docs", value: 85),
                            .init(label: "Patterns", value: 48)
                        ])
                    ],
                    selection: $selectedMetric,
                    visibleSeriesIDs: $visibleSeriesIDs,
                    valueFormatter: { value in "\(Int(value))%" }
                )
                .frame(maxWidth: .infinity)

                KeyValuePairs(environment: environment, pairs: selectedPairs)
                    .frame(width: 280)
            }

            HStack(alignment: .top, spacing: 18) {
                BarChartPanel(
                    environment: environment,
                    title: "Loading",
                    subtitle: "Async data state uses the shared contract.",
                    state: .loading(.init(label: "Refreshing coverage", detail: "Legend and layout remain stable.")),
                    series: [
                        .init(title: "Coverage", color: environment.theme.color(.chartPurple), points: [
                            .init(label: "Dashboards", value: 74),
                            .init(label: "Forms", value: 61),
                            .init(label: "Feedback", value: 89)
                        ])
                    ],
                    valueFormatter: { value in "\(Int(value))%" },
                    height: 180
                )
                .frame(maxWidth: .infinity)

                AreaChartPanel(
                    environment: environment,
                    title: "Empty",
                    subtitle: "No series are currently visible after filtering.",
                    state: .empty(.init(title: "No trend available", message: "Adjust the current filter to restore the chart.", symbol: "line.3.horizontal.decrease.circle")),
                    series: [
                        .init(title: "Coverage", color: environment.theme.color(.chartBlue), points: [
                            .init(label: "Mon", value: 42),
                            .init(label: "Tue", value: 48)
                        ])
                    ],
                    valueFormatter: { value in "\(Int(value))%" },
                    height: 180
                )
                .frame(maxWidth: .infinity)

                DonutChartPanel(
                    environment: environment,
                    title: "Error",
                    subtitle: "The chart shell stays calm while retry messaging appears.",
                    state: .error(.init(title: "Unable to load status mix", message: "Retry after the dataset refresh completes.")),
                    slices: [
                        .init(title: "Ready", value: 18, color: environment.theme.color(.chartGreen)),
                        .init(title: "Review", value: 7, color: environment.theme.color(.chartAmber))
                    ],
                    valueFormatter: { value in "\(Int(value)) items" },
                    height: 180
                )
                .frame(maxWidth: .infinity)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(environment.theme.color(.workspaceBackground))
    }
}

private let collectionUploadItems: [FileUploadItem] = [
    .init(id: "release-notes", title: "release-notes.md", detail: "18 KB", status: .success, message: "Uploaded successfully.", symbol: "doc.text"),
    .init(id: "screenshots", title: "screenshots.zip", detail: "2 files", status: .uploading, progress: 0.64, message: "Uploading archive...", symbol: "archivebox"),
    .init(id: "hero-image", title: "hero.png", detail: "4.2 MB", status: .error, message: "The file exceeds the current size limit.", symbol: "photo", canRetry: true)
]

private func collectionBoardColumns(environment: DesignSystemEnvironment) -> [Board.Column] {
    [
        .init(id: "incoming", title: "Incoming", items: [
            .init(id: "review-docs", title: "Review docs", detail: "Match snippets to the real API.", status: "Review", statusColor: environment.theme.color(.warning), symbol: "doc.badge.magnifyingglass"),
            .init(id: "sync-snapshots", title: "Sync snapshots", detail: "Record the new collection states.", status: "Ready", statusColor: environment.theme.color(.success), symbol: "photo.on.rectangle")
        ]),
        .init(id: "ready", title: "Ready", items: [
            .init(id: "publish-catalog", title: "Publish catalog", detail: "Regenerate docs and examples.", status: "Queued", statusColor: environment.theme.color(.info), symbol: "square.stack.3d.up")
        ])
    ]
}

private func advancedBoardColumns(environment: DesignSystemEnvironment) -> [Board.Column] {
    [
        .init(id: "backlog", title: "Backlog", items: [
            .init(id: "alert", title: "Alert", detail: "Feedback work", status: "Review", statusColor: environment.theme.color(.warning), symbol: "exclamationmark.triangle"),
            .init(id: "charts", title: "Charts", detail: "Metrics work", status: "Ready", statusColor: environment.theme.color(.success), symbol: "chart.bar")
        ]),
        .init(id: "done", title: "Done", items: [
            .init(id: "foundations", title: "Foundations", detail: "Token exports", status: "Done", statusColor: environment.theme.color(.success), symbol: "shippingbox")
        ])
    ]
}

private func collectionPaletteItems(environment: DesignSystemEnvironment) -> [Board.Item] {
    [
        .init(id: "metric-card", title: "Metric card", detail: "Reusable dashboard tile.", status: "Ready", statusColor: environment.theme.color(.success), symbol: "chart.bar"),
        .init(id: "status-list", title: "Status list", detail: "Dense collection summary.", status: "Review", statusColor: environment.theme.color(.warning), symbol: "list.bullet.rectangle"),
        .init(id: "release-note", title: "Release note", detail: "Attach guidance to a workflow column.", status: "Info", statusColor: environment.theme.color(.info), symbol: "paperclip")
    ]
}

private func collectionInsertDestinations(environment: DesignSystemEnvironment) -> [Board.Destination] {
    collectionBoardColumns(environment: environment).map { column in
        .init(
            title: "Insert into \(column.title)",
            columnID: column.id,
            columnTitle: column.title,
            index: column.items.count
        )
    }
}

private func advancedInsertDestinations(environment: DesignSystemEnvironment) -> [Board.Destination] {
    advancedBoardColumns(environment: environment).map { column in
        .init(
            title: "Insert into \(column.title)",
            columnID: column.id,
            columnTitle: column.title,
            index: column.items.count
        )
    }
}

private let guidedHelpTopics: [HelpTopic] = [
    .init(id: "context", title: "Current context", detail: "Tie guidance to the active workflow.", symbol: "scope"),
    .init(id: "recovery", title: "Recovery", detail: "Name the next safe action.", symbol: "arrow.uturn.backward"),
    .init(id: "handoff", title: "Handoff", detail: "Explain what changes next.", symbol: "square.and.arrow.up")
]

private func guidedHelpCopy(_ selectedTopicID: String?) -> String {
    switch selectedTopicID {
    case "recovery":
        "Recovery guidance should name the failed step and the safest next move without forcing the user out of the current panel."
    case "handoff":
        "Handoff guidance should confirm what changed, what still needs review, and who owns the next action."
    default:
        "Link support guidance to the active decision and preserve the user’s place in the workflow."
    }
}
