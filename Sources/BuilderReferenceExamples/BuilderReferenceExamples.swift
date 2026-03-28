import SwiftUI
import UniformTypeIdentifiers
import BuilderDesignSystem

package enum BuilderReferenceExamples {
    package static func componentExample(
        id: ComponentExampleID,
        displayName: String,
        family: ComponentExampleFamily
    ) -> ComponentReferenceExample {
        let template: ComponentReferenceExample

        switch family {
        case .shell:
            template = ComponentReferenceExample(
                id: id,
                title: "Shell workspace",
                summary: "Compose structural shell surfaces from reusable layout, row, and panel primitives.",
                supportedStates: ["Default", "Selected", "Focused", "Compact"],
                accessibilityNotes: [
                    "Keep the navigation rail keyboard reachable from the shell.",
                    "Selected route styling should not be the only signal for current location."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                AppLayout(environment: environment, sidebarWidth: 240) {
                    SidebarRow(
                        environment: environment,
                        title: "Components",
                        symbol: "square.grid.2x2",
                        isSelected: true
                    )
                } content: {
                    PanelSurface(
                        environment: environment,
                        title: "Workspace",
                        subtitle: "Shell composition stays token-driven."
                    ) {
                        Text("Primary content")
                    }
                }
                """,
                makePreview: { environment, _ in AnyView(ShellReferenceExample(environment: environment)) }
            )
        case .toolbar:
            template = ComponentReferenceExample(
                id: id,
                title: "Toolbar actions",
                summary: "Keep toolbar actions dense, quiet, and scoped to the current work surface.",
                supportedStates: ["Default", "Selected", "Disabled"],
                accessibilityNotes: [
                    "Toolbar actions should announce purpose instead of only repeating the icon.",
                    "Grouped segmented state should remain reachable in compact density."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                HStack(spacing: 12) {
                    ToolbarButton(environment: environment, title: "Refresh", symbol: "arrow.clockwise") {}
                    SegmentedPicker(
                        environment: environment,
                        options: [("Compact", 0), ("Default", 1), ("Comfortable", 2)],
                        selection: $selection
                    )
                }
                """,
                makePreview: { environment, _ in AnyView(ToolbarReferenceExample(environment: environment)) }
            )
        case .navigation:
            template = ComponentReferenceExample(
                id: id,
                title: "Navigation browser",
                summary: "Use native macOS navigation primitives with custom system row visuals.",
                supportedStates: ["Default", "Selected", "Keyboard active", "Disabled"],
                accessibilityNotes: [
                    "Selection and activation should stay in sync when using keyboard navigation.",
                    "Section labels should remain exposed to assistive technologies."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                NavigationSidebarList(
                    environment: environment,
                    sections: [
                        NavigationSection(
                            id: "workspace",
                            title: "Workspace",
                            items: [
                                NavigationItem(id: "home", title: "Home", symbol: "house"),
                                NavigationItem(id: "components", title: "Components", symbol: "square.grid.2x2")
                            ]
                        )
                    ],
                    selection: $selection
                ) { item, isSelected in
                    SidebarRow(
                        environment: environment,
                        title: item.title,
                        symbol: item.symbol ?? "circle",
                        isSelected: isSelected
                    )
                }
                """,
                makePreview: { environment, _ in AnyView(NavigationReferenceExample(environment: environment)) }
            )
        case .form:
            template = ComponentReferenceExample(
                id: id,
                title: "Form field composition",
                summary: "Form examples pair label, description, validation, and field state from the same contract.",
                supportedStates: ["Default", "Disabled", "Read-only", "Error"],
                accessibilityNotes: [
                    "Each field should preserve its label and validation relationship.",
                    "Error states should be communicated through text, not color alone."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                FormField(environment: environment, label: "Project name", description: "Editable field") {
                    TextInputField(
                        environment: environment,
                        placeholder: "Project name",
                        text: $text,
                        status: .error,
                        message: "Enter a readable project name."
                    )
                }
                """,
                makePreview: { environment, options in
                    AnyView(FormReferenceExample(environment: environment, options: options))
                }
            )
        case .selection:
            template = ComponentReferenceExample(
                id: id,
                title: "Selection controls",
                summary: "Selection controls should express state without changing layout rhythm.",
                supportedStates: ["Default", "Selected", "Mixed", "Disabled", "Loading"],
                accessibilityNotes: [
                    "Mixed and disabled states need an explicit announced state.",
                    "Loading should not remove the selected value context."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                Checkbox(environment: environment, title: "Enable grouped settings", isOn: $enabled)
                ToggleSwitch(environment: environment, title: "Use native transitions", isOn: $enabled, isLoading: isLoading)
                SelectMenu(
                    environment: environment,
                    options: [.init(label: "Automatic", value: "Automatic")],
                    selection: $selection
                )
                """,
                makePreview: { environment, options in
                    AnyView(SelectionReferenceExample(environment: environment, options: options))
                }
            )
        case .feedback:
            template = ComponentReferenceExample(
                id: id,
                title: "Feedback stack",
                summary: "Feedback primitives should pair semantic tone with the next operational action.",
                supportedStates: ["Info", "Success", "Warning", "Error", "Dismissed"],
                accessibilityNotes: [
                    "Announcements should stay readable without relying on color alone.",
                    "Dismissible banners should expose an explicit close affordance."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                AlertBanner(
                    environment: environment,
                    title: "Documentation updated",
                    message: "Review the latest component guidance.",
                    tone: .info,
                    actionTitle: "Open docs"
                ) {}
                """,
                makePreview: { environment, options in
                    AnyView(FeedbackReferenceExample(environment: environment, options: options))
                }
            )
        case .overlay:
            template = ComponentReferenceExample(
                id: id,
                title: "Overlay surfaces",
                summary: "Modal, drawer, and popover surfaces should inherit the same material and motion system.",
                supportedStates: ["Closed", "Open", "Focused"],
                accessibilityNotes: [
                    "Opening an overlay should move focus into the overlay surface.",
                    "Dismissing an overlay should restore focus to the trigger."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                ModalSurface(environment: environment, title: "Confirm changes") {
                    ValidationSummary(environment: environment, items: [])
                }
                """,
                makePreview: { environment, _ in AnyView(OverlayReferenceExample(environment: environment)) }
            )
        case .content:
            template = ComponentReferenceExample(
                id: id,
                title: "Content surfaces",
                summary: "Use content primitives to build calm grouped sections before reaching for one-off stacks.",
                supportedStates: ["Default", "Expanded", "Empty"],
                accessibilityNotes: [
                    "Tabbed content should keep the selected panel obvious to keyboard users.",
                    "Expanding content should preserve reading order."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                Tabs(
                    environment: environment,
                    items: [
                        .init(title: "Overview", value: "overview"),
                        .init(title: "Content", value: "content")
                    ],
                    selection: $tab
                )
                """,
                makePreview: { environment, _ in AnyView(ContentReferenceExample(environment: environment)) }
            )
        case .data:
            template = ComponentReferenceExample(
                id: id,
                title: "Data surfaces",
                summary: "Tables and charts should stay dense and readable while exposing selection, filtering, and async state without product-local styling.",
                supportedStates: ["Ready", "Selected", "Filtered", "Loading", "Empty", "Error"],
                accessibilityNotes: [
                    "Data views should remain understandable without color-only distinctions.",
                    "Selection detail should remain readable outside the chart.",
                    "Pagination and selection should be keyboard reachable."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                MixedChartPanel(
                    environment: environment,
                    title: "Coverage and adoption",
                    state: .ready,
                    barSeries: [
                        .init(title: "Coverage", color: environment.theme.color(.chartBlue), points: [
                            .init(label: "Tokens", value: 82),
                            .init(label: "Components", value: 80),
                            .init(label: "Patterns", value: 24)
                        ])
                    ],
                    lineSeries: [
                        .init(title: "Adoption", color: environment.theme.color(.chartTeal), points: [
                            .init(label: "Tokens", value: 64),
                            .init(label: "Components", value: 58),
                            .init(label: "Patterns", value: 18)
                        ])
                    ],
                    selection: .constant(nil),
                    visibleSeriesIDs: .constant(["Coverage", "Adoption"]),
                    valueFormatter: { value in "\\(Int(value))%" }
                )
                """,
                makePreview: { environment, _ in AnyView(DataReferenceExample(environment: environment)) }
            )
        case .ai:
            template = ComponentReferenceExample(
                id: id,
                title: "AI review surface",
                summary: "Prompt, output, and follow-up actions should stay explicit and reviewable.",
                supportedStates: ["Composing", "Submitting", "Streaming", "Retry"],
                accessibilityNotes: [
                    "Generated output should be clearly differentiated from authored input.",
                    "Follow-up actions should remain explicit instead of implied.",
                    "Submit shortcuts should be explained in persistent text."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                VStack(spacing: 12) {
                    PromptInput(environment: environment, prompt: $prompt, actionTitle: "Draft") {}
                    ChatBubble(environment: environment, role: .assistant, author: "Builder assistant", message: output)
                }
                """,
                makePreview: { environment, _ in AnyView(AIReferenceExample(environment: environment)) }
            )
        case .tutorial:
            template = ComponentReferenceExample(
                id: id,
                title: "Guided flow",
                summary: "Tutorial and onboarding surfaces should keep progress visible inside the same shell language.",
                supportedStates: ["Current", "Complete", "Warning", "Optional"],
                accessibilityNotes: [
                    "Step progression should stay understandable without motion.",
                    "Progress updates should be announced with clear current-step wording."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                TutorialPanel(
                    environment: environment,
                    title: "Build tutorial",
                    steps: [.init(id: "audit", title: "Audit"), .init(id: "verify", title: "Verify")],
                    currentStepID: "audit"
                ) {
                    Text("Guide teams into the system with the same shell language.")
                }
                """,
                makePreview: { environment, _ in AnyView(TutorialReferenceExample(environment: environment)) }
            )
        case .utility:
            template = ComponentReferenceExample(
                id: id,
                title: "Utility helpers",
                summary: "Utility components stay small, quiet, and tightly coupled to nearby workflow context.",
                supportedStates: ["Default", "Copied", "No results"],
                accessibilityNotes: [
                    "Utility messaging should remain concise enough for repeated exposure.",
                    "Search result items should announce title and context."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                SearchResultsOverlay(
                    environment: environment,
                    sections: [
                        SearchResultSection(
                            title: "Components",
                            items: [.init(id: "button", title: "Button", subtitle: "Action control", symbol: "capsule")]
                        )
                    ]
                ) { item in
                    print(item.title)
                }
                """,
                makePreview: { environment, _ in AnyView(UtilityReferenceExample(environment: environment)) }
            )
        case .specialized:
            template = ComponentReferenceExample(
                id: id,
                title: "Specialized workflows",
                summary: "Specialized components should still use the same form, feedback, and grouped-surface DNA.",
                supportedStates: ["Default", "Selected", "Review"],
                accessibilityNotes: [
                    "Specialized workflows should inherit field, selection, and status semantics from the core system.",
                    "Supporting metadata should stay in the same reading order as the primary action."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                HelpPanel(environment: environment, title: "Help") {
                    Text("Specialized surfaces should still feel like system components.")
                }
                """,
                makePreview: { environment, _ in AnyView(SpecializedReferenceExample(environment: environment)) }
            )
        }

        let exact = ExactReferenceContent.component(
            id: id,
            displayName: displayName,
            family: family,
            fallbackCode: template.code
        )

        return .init(
            id: id,
            title: "\(displayName) example",
            summary: "Canonical compiled example for \(displayName). \(exact.summary)",
            supportedStates: template.supportedStates,
            accessibilityNotes: template.accessibilityNotes,
            code: """
            // Canonical example for \(displayName)
            \(exact.code)
            """,
            makePreview: template.makePreview
        )
    }

    @MainActor
    package static func componentPreview(
        id: ComponentExampleID,
        displayName: String,
        family: ComponentExampleFamily,
        environment: DesignSystemEnvironment,
        options: ComponentPreviewOptions = .live
    ) -> AnyView {
        if let exactPreview = exactComponentPreview(
            id: id,
            displayName: displayName,
            environment: environment,
            options: options
        ) {
            return exactPreview
        }

        return componentExample(id: id, displayName: displayName, family: family).makePreview(environment, options)
    }

    package static func patternExample(
        id: PatternExampleID,
        displayName: String,
        family: PatternExampleFamily
    ) -> PatternReferenceExample {
        let template: PatternReferenceExample

        switch family {
        case .actionFlow:
            template = PatternReferenceExample(
                id: id,
                title: "Action flow recipe",
                summary: "Keep the primary action obvious while secondary guidance remains nearby and calm.",
                contentGuidance: [
                    "Use direct action labels such as Save, Review, and Continue.",
                    "Pair status language with the next step instead of generic reassurance."
                ],
                accessibilityNotes: [
                    "Primary action should remain reachable after validation feedback appears.",
                    "Live updates should use persistent text, not only animation."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                PanelSurface(environment: environment, title: "Action flow") {
                    ValidationSummary(environment: environment, items: validationItems)
                    SystemButton(environment: environment, title: "Continue", tone: .primary) {}
                }
                """,
                makePreview: { environment in AnyView(ActionFlowPatternExample(environment: environment)) }
            )
        case .announcement:
            template = PatternReferenceExample(
                id: id,
                title: "Announcement recipe",
                summary: "Introduce capability without turning the shell into a marketing surface.",
                contentGuidance: [
                    "State what changed, who it affects, and what the next action is.",
                    "Keep announcement copy to one short operational sentence."
                ],
                accessibilityNotes: [
                    "Announcements should remain readable with reduced motion enabled.",
                    "Dismissal controls should be explicit."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                NoticeStack(environment: environment, notices: [
                    .init(title: "New workflow", message: "Open Recipes to inspect the updated flow.", tone: .info)
                ])
                """,
                makePreview: { environment in AnyView(AnnouncementPatternExample(environment: environment)) }
            )
        case .unsavedChanges:
            template = PatternReferenceExample(
                id: id,
                title: "Unsaved changes recipe",
                summary: "Communicate risk clearly without making the interface feel punitive.",
                contentGuidance: [
                    "State the consequence directly.",
                    "Use action labels that distinguish save, discard, and cancel."
                ],
                accessibilityNotes: [
                    "Focus should land on the dialog content when the warning opens.",
                    "Status text should describe the pending consequence."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                ModalSurface(environment: environment, title: "Leave without saving") {
                    AlertBanner(environment: environment, title: "Unsaved edits", message: "Save or discard before leaving.", tone: .warning)
                }
                """,
                makePreview: { environment in AnyView(UnsavedChangesPatternExample(environment: environment)) }
            )
        case .dataVisualization:
            template = PatternReferenceExample(
                id: id,
                title: "Data visualization recipe",
                summary: "Charts, filters, async state, and detail panes should behave like one connected analytical workflow.",
                contentGuidance: [
                    "Lead with the operational takeaway before dense detail.",
                    "Expose selected values in adjacent detail content, not only in the plot.",
                    "Use labels that stay meaningful without chart color."
                ],
                accessibilityNotes: [
                    "Provide tabular detail adjacent to chart summaries.",
                    "Selection changes should announce the chosen metric clearly.",
                    "Filtering controls should remain reachable without moving focus unexpectedly."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                VStack(spacing: 16) {
                    MixedChartPanel(
                        environment: environment,
                        title: "Coverage and adoption",
                        state: .ready,
                        barSeries: coverageSeries,
                        lineSeries: adoptionSeries,
                        selection: $selection,
                        visibleSeriesIDs: $visibleSeriesIDs,
                        valueFormatter: { value in "\\(Int(value))%" }
                    )
                    KeyValuePairs(environment: environment, pairs: metricPairs)
                    DataTable(environment: environment, columns: columns, rows: rows, selectedRowID: .constant(nil))
                }
                """,
                makePreview: { environment in AnyView(DataVisualizationPatternExample(environment: environment)) }
            )
        case .density:
            template = PatternReferenceExample(
                id: id,
                title: "Density settings recipe",
                summary: "Let builders change density without changing the visual language or control hierarchy.",
                contentGuidance: [
                    "Describe what density changes, not just the label Compact or Comfortable.",
                    "Keep the explanation tied to information rhythm and scanability."
                ],
                accessibilityNotes: [
                    "Density changes must preserve hit targets.",
                    "Density controls should remain keyboard reachable in the same order."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                SettingsGroup(environment: environment) {
                    SettingsRow(environment: environment, title: "Density", detail: "Align rows and fields") {
                        SegmentedPicker(environment: environment, options: [("Compact", 0), ("Default", 1)], selection: $density)
                    }
                }
                """,
                makePreview: { environment in AnyView(DensityPatternExample(environment: environment)) }
            )
        case .stateHandling:
            template = PatternReferenceExample(
                id: id,
                title: "State handling recipe",
                summary: "Disabled, empty, and error states should still orient the user toward the next action.",
                contentGuidance: [
                    "Say what is blocked and how to recover.",
                    "Avoid vague copy such as Something went wrong."
                ],
                accessibilityNotes: [
                    "Error and empty states should preserve reading order.",
                    "Recovery messaging should remain visible when focus returns to the main surface."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                VStack(spacing: 14) {
                    EmptyStateView(environment: environment, title: "No results", message: "Clear the filter to restore the table.")
                    ValidationSummary(environment: environment, items: items)
                }
                """,
                makePreview: { environment in AnyView(StateHandlingPatternExample(environment: environment)) }
            )
        case .dragAndDrop:
            template = PatternReferenceExample(
                id: id,
                title: "Drag and drop recipe",
                summary: "Spatial rearrangement and file intake should feel obvious on desktop without breaking calm hierarchy.",
                contentGuidance: [
                    "Use explicit drop guidance rather than decorative empty chrome.",
                    "Confirm what was received and what happens next."
                ],
                accessibilityNotes: [
                    "Provide a keyboard-accessible alternative to dragging.",
                    "Describe the drop target clearly."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                PanelSurface(environment: environment, title: "Drop files") {
                    EmptyStateView(environment: environment, title: "Drop release notes here", message: "Or browse from disk.")
                }
                """,
                makePreview: { environment in AnyView(DragAndDropPatternExample(environment: environment)) }
            )
        case .filtering:
            template = PatternReferenceExample(
                id: id,
                title: "Filtering recipe",
                summary: "Search, scoped filters, and table results should behave like one connected workflow.",
                contentGuidance: [
                    "Keep filter labels concrete and composable.",
                    "Say what is being filtered, not just the control type."
                ],
                accessibilityNotes: [
                    "Filters should preserve focus when results refresh.",
                    "Search results should be announced with context."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                let filterState = BrowserFilterState<String>(query: "", selectedScope: "All")
                SearchResultsOverlay(environment: environment, sections: sections) { _ in }
                """,
                makePreview: { environment in AnyView(FilteringPatternExample(environment: environment)) }
            )
        case .hero:
            template = PatternReferenceExample(
                id: id,
                title: "Hero header recipe",
                summary: "Opening states should orient the workspace rather than imitate marketing copy.",
                contentGuidance: [
                    "Lead with the job to be done.",
                    "Keep supporting copy calm and operational."
                ],
                accessibilityNotes: [
                    "Large heading hierarchy should still read correctly to screen readers.",
                    "Primary actions should remain near the heading."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                PanelSurface(environment: environment, title: "Build with the system") {
                    SystemButton(environment: environment, title: "Browse components", tone: .primary) {}
                }
                """,
                makePreview: { environment in AnyView(HeroPatternExample(environment: environment)) }
            )
        case .support:
            template = PatternReferenceExample(
                id: id,
                title: "Support panel recipe",
                summary: "Support and inspection content should sit adjacent to work instead of interrupting it.",
                contentGuidance: [
                    "Support copy should answer the current decision, not restate the page.",
                    "Keep side-panel language concise enough for repeated exposure."
                ],
                accessibilityNotes: [
                    "Supplementary panels should preserve logical focus order.",
                    "Popover and drawer dismissals should restore focus."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                DrawerSurface(environment: environment, title: "Guidance") {
                    Text("Keep help adjacent to work.")
                }
                """,
                makePreview: { environment in AnyView(SupportPatternExample(environment: environment)) }
            )
        case .loading:
            template = PatternReferenceExample(
                id: id,
                title: "Loading and refreshing recipe",
                summary: "Refreshing data should preserve layout stability and status clarity.",
                contentGuidance: [
                    "Name what is loading or refreshing.",
                    "Keep in-flight language short enough for repeated exposure."
                ],
                accessibilityNotes: [
                    "Loading indicators should not erase context.",
                    "Status changes should remain perceivable without animation."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                VStack(spacing: 12) {
                    LoadingSpinner(environment: environment, label: "Refreshing metrics")
                    StatusIndicator(environment: environment, label: "Refresh in progress", tone: .info)
                }
                """,
                makePreview: { environment in AnyView(LoadingPatternExample(environment: environment)) }
            )
        case .onboarding:
            template = PatternReferenceExample(
                id: id,
                title: "Onboarding recipe",
                summary: "Guide the first-run journey without switching visual systems.",
                contentGuidance: [
                    "Explain the next step in direct product language.",
                    "Use progress labels that describe intent, not only sequence numbers."
                ],
                accessibilityNotes: [
                    "Current step and next action should remain obvious without motion.",
                    "Progress changes should be announced with context."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                WizardLayout(environment: environment, title: "Bring a team in", steps: steps, currentStepID: "Tune") {
                    Text("Guide teams into the system.")
                }
                """,
                makePreview: { environment in AnyView(OnboardingPatternExample(environment: environment)) }
            )
        case .navigation:
            template = PatternReferenceExample(
                id: id,
                title: "Workspace navigation recipe",
                summary: "Primary navigation, secondary context, and content should feel like one desktop workspace.",
                contentGuidance: [
                    "Route names should describe destinations, not implementation details.",
                    "Secondary panel copy should support the current task, not duplicate the sidebar."
                ],
                accessibilityNotes: [
                    "Keyboard selection and activation should stay aligned in all navigation regions.",
                    "Current destination should remain obvious to assistive technologies."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                AppLayout(environment: environment, sidebarWidth: 240) {
                    NavigationSidebarList(environment: environment, sections: sections, selection: $selection) { item, isSelected in
                        SidebarRow(environment: environment, title: item.title, symbol: item.symbol ?? "circle", isSelected: isSelected)
                    }
                } content: {
                    PanelSurface(environment: environment, title: "Workspace") { Text("Current route") }
                }
                """,
                makePreview: { environment in AnyView(NavigationPatternExample(environment: environment)) }
            )
        case .dashboard:
            template = PatternReferenceExample(
                id: id,
                title: "Dashboard recipe",
                summary: "Status, metrics, and lists should share one calm operating surface.",
                contentGuidance: [
                    "Lead with status and key metrics before dense detail.",
                    "Keep section headings utilitarian rather than promotional."
                ],
                accessibilityNotes: [
                    "Metric labels should stay meaningful when read out of visual context.",
                    "Tables and charts should expose the same information hierarchy."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                VStack(spacing: 16) {
                    StatusIndicator(environment: environment, label: "Release candidate", tone: .success)
                    ChartPanel(environment: environment, title: "Coverage", points: points)
                }
                """,
                makePreview: { environment in AnyView(DashboardPatternExample(environment: environment)) }
            )
        case .timeAndFeedback:
            template = PatternReferenceExample(
                id: id,
                title: "Time and feedback recipe",
                summary: "Recency and outcome messaging should stay concise enough for repeated product exposure.",
                contentGuidance: [
                    "Use plain recency language such as Updated 2h ago.",
                    "Keep feedback language factual and next-step oriented."
                ],
                accessibilityNotes: [
                    "Timestamps should stay understandable when read aloud.",
                    "Feedback updates should use persistent text rather than ephemeral animation."
                ],
                code: """
                let environment = DesignSystemEnvironment.preview(.dark)

                VStack(spacing: 12) {
                    LiveRegionMessage(environment: environment, message: "Updated 2 hours ago")
                    NoticeStack(environment: environment, notices: notices)
                }
                """,
                makePreview: { environment in AnyView(TimeAndFeedbackPatternExample(environment: environment)) }
            )
        }

        let exact = ExactReferenceContent.pattern(
            id: id,
            displayName: displayName,
            family: family,
            fallbackCode: template.code
        )

        return .init(
            id: id,
            title: "\(displayName) example",
            summary: "Canonical compiled pattern example for \(displayName). \(exact.summary)",
            contentGuidance: template.contentGuidance,
            accessibilityNotes: template.accessibilityNotes,
            code: """
            // Canonical example for \(displayName)
            \(exact.code)
            """,
            makePreview: template.makePreview
        )
    }

    @MainActor
    package static func patternPreview(
        id: PatternExampleID,
        displayName: String,
        family: PatternExampleFamily,
        environment: DesignSystemEnvironment
    ) -> AnyView {
        patternExample(id: id, displayName: displayName, family: family).makePreview(environment)
    }
}

private struct ShellReferenceExample: View {
    let environment: DesignSystemEnvironment

    var body: some View {
        AppLayout(environment: environment, sidebarWidth: 220) {
            VStack(alignment: .leading, spacing: 8) {
                SidebarRow(environment: environment, title: "Home", symbol: "house", isSelected: false)
                SidebarRow(environment: environment, title: "Components", symbol: "square.grid.2x2", isSelected: true)
                SidebarRow(environment: environment, title: "Recipes", symbol: "square.on.square", isSelected: false)
            }
            .padding(16)
        } content: {
            PanelSurface(environment: environment, title: "Builder workspace", subtitle: "Use shared layout primitives before bespoke stacks.") {
                HStack(spacing: 10) {
                    SystemButton(environment: environment, title: "Primary", tone: .primary) {}
                    SystemButton(environment: environment, title: "Secondary", tone: .secondary) {}
                }
            }
            .padding(18)
        }
        .frame(height: 260)
    }
}

private struct ToolbarReferenceExample: View {
    let environment: DesignSystemEnvironment
    @State private var selection = 1

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Toolbar")
                    .font(environment.theme.typography(.sectionTitle).font)
                Spacer()
                ToolbarButton(environment: environment, title: "Refresh", symbol: "arrow.clockwise") {}
            }

            SegmentedPicker(
                environment: environment,
                options: [("Compact", 0), ("Default", 1), ("Comfortable", 2)],
                selection: $selection,
                style: .neutral
            )
            .frame(width: 280)
        }
    }
}

private struct NavigationReferenceExample: View {
    let environment: DesignSystemEnvironment
    @State private var route: String? = "components"
    @State private var subsection = "overview"

    private var sections: [NavigationSection<String>] {
        [
            .init(
                id: "workspace",
                title: "Workspace",
                items: [
                    .init(id: "home", title: "Home", symbol: "house"),
                    .init(id: "components", title: "Components", symbol: "square.grid.2x2"),
                    .init(id: "recipes", title: "Recipes", symbol: "square.on.square")
                ]
            )
        ]
    }

    var body: some View {
        HStack(alignment: .top, spacing: 18) {
            NavigationSidebarList(environment: environment, sections: sections, selection: $route, rowHeight: 44) { item, isSelected in
                SidebarRow(environment: environment, title: item.title, symbol: item.symbol ?? "circle", isSelected: isSelected)
            }
            .frame(width: 220, height: 180)

            VStack(alignment: .leading, spacing: 12) {
                BreadcrumbGroup(environment: environment, items: [
                    .init(title: "Library"),
                    .init(title: "Components", isCurrent: true)
                ])

                Tabs(environment: environment, items: [
                    .init(title: "Overview", value: "overview"),
                    .init(title: "Tokens", value: "tokens"),
                    .init(title: "Usage", value: "usage")
                ], selection: $subsection)
            }
        }
    }
}

private struct FormReferenceExample: View {
    let environment: DesignSystemEnvironment
    let options: ComponentPreviewOptions
    @State private var name = "Builder system"
    @State private var query = ""
    @State private var note = "Fields should keep validation and helper text in one rhythm."

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            FormField(environment: environment, label: "Project name", description: "Editable field with shared status semantics.") {
                TextInputField(
                    environment: environment,
                    placeholder: "Project name",
                    text: $name,
                    status: options.showDisabledState ? .error : .normal,
                    message: options.showDisabledState ? "Enter a valid project name." : nil,
                    isReadOnly: options.showReadOnlyState,
                    isEnabled: !options.showDisabledState
                )
            }

            FormField(environment: environment, label: "Search", description: "Search should remain related to field validation and density.") {
                TextFilterField(environment: environment, placeholder: "Search the system", text: $query)
            }

            FormField(environment: environment, label: "Notes", hint: options.showReadOnlyState ? "This example is showing the read-only state." : nil) {
                TextAreaField(
                    environment: environment,
                    placeholder: "Notes",
                    text: $note,
                    status: options.showDisabledState ? .warning : .normal,
                    message: options.showDisabledState ? "Resolve the field warning before continuing." : nil,
                    isReadOnly: options.showReadOnlyState,
                    isEnabled: !options.showDisabledState
                )
            }
        }
    }
}

private struct SelectionReferenceExample: View {
    let environment: DesignSystemEnvironment
    let options: ComponentPreviewOptions
    @State private var enabled = true
    @State private var selection = "Automatic"
    @State private var choices: Set<String> = ["Shell"]
    @State private var radio = 1

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Checkbox(
                environment: environment,
                title: "Enable grouped settings",
                detail: options.showReadOnlyState ? "Mixed state previews a partially applied setting." : nil,
                isOn: $enabled,
                isMixed: options.showReadOnlyState,
                isEnabled: !options.showDisabledState
            )

            ToggleSwitch(
                environment: environment,
                title: "Use native transitions",
                detail: options.showLoadingState ? "Loading shows the in-flight state without losing context." : nil,
                isOn: $enabled,
                isEnabled: !options.showDisabledState,
                isLoading: options.showLoadingState
            )

            RadioGroup(
                environment: environment,
                options: [
                    .init(label: "Compact", value: 0),
                    .init(label: "Default", value: 1, isEnabled: !options.showDisabledState),
                    .init(label: "Comfortable", value: 2, isEnabled: !options.showDisabledState)
                ],
                selection: $radio
            )

            HStack(spacing: 12) {
                SelectMenu(
                    environment: environment,
                    options: [
                        .init(label: "Automatic", value: "Automatic"),
                        .init(label: "Sidebar", value: "Sidebar"),
                        .init(label: "Workspace", value: "Workspace")
                    ],
                    selection: $selection,
                    isEnabled: !options.showDisabledState
                )

                MultiselectMenu(
                    environment: environment,
                    options: [
                        .init(label: "Shell", value: "Shell"),
                        .init(label: "Content", value: "Content"),
                        .init(label: "Feedback", value: "Feedback")
                    ],
                    selection: $choices,
                    isEnabled: !options.showDisabledState
                )
            }
        }
    }
}

private struct FeedbackReferenceExample: View {
    let environment: DesignSystemEnvironment
    let options: ComponentPreviewOptions
    @State private var alertVisible = true

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            StatusIndicator(environment: environment, label: "System healthy", detail: "All exports and docs resolve.", tone: .success)

            if alertVisible {
                AlertBanner(
                    environment: environment,
                    title: options.showLoadingState ? "Refreshing guidance" : "Documentation updated",
                    message: options.showLoadingState ? "Rebuilding reference pages and snapshots." : "System and showcase docs now reflect the shared examples path.",
                    tone: options.showDisabledState ? .warning : .info,
                    actionTitle: "Review states",
                    action: {},
                    isDismissible: true,
                    onDismiss: { alertVisible = false }
                )
            }

            ValidationSummary(
                environment: environment,
                items: [
                    .init(id: "labels", title: "Action labels", detail: "Keep primary actions direct and short.", status: .success),
                    .init(id: "errors", title: "Error messaging", detail: "Explain the exact fix needed.", status: options.showDisabledState ? .error : .warning)
                ]
            )

            HStack(spacing: 14) {
                LoadingSpinner(environment: environment, label: options.showLoadingState ? "Refreshing previews" : "Idle")
                if options.showLoadingState {
                    LoadingBar(environment: environment, label: "Syncing examples", detail: "Reference pages are rebuilding.")
                        .frame(maxWidth: 220)
                }
                LiveRegionMessage(environment: environment, message: "Status updates stay readable without relying on color alone.")
            }
        }
    }
}

private struct OverlayReferenceExample: View {
    let environment: DesignSystemEnvironment
    @State private var selection = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SegmentedPicker(
                environment: environment,
                options: [("Modal", 0), ("Drawer", 1), ("Popover", 2)],
                selection: $selection,
                style: .neutral
            )
            .frame(width: 240)

            Group {
                if selection == 0 {
                    ModalSurface(environment: environment, title: "Confirm changes") {
                        overlayContent
                    }
                } else if selection == 1 {
                    DrawerSurface(environment: environment, title: "Inspector") {
                        overlayContent
                    }
                } else {
                    PopoverSurface(environment: environment, title: "Quick action") {
                        overlayContent
                    }
                }
            }
        }
    }

    private var overlayContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Overlays should inherit the same material and token system as the rest of the product.")
                .font(environment.theme.typography(.body).font)
                .foregroundStyle(environment.theme.color(.textSecondary))

            HStack(spacing: 10) {
                SystemButton(environment: environment, title: "Confirm", tone: .primary) {}
                SystemButton(environment: environment, title: "Cancel", tone: .secondary) {}
            }
        }
    }
}

private struct ContentReferenceExample: View {
    let environment: DesignSystemEnvironment
    @State private var tab = "overview"
    @State private var isExpanded = true
    @State private var selectedBoardItemID: String?
    @State private var selectedPaletteItemID: String?
    @State private var boardColumns: [Board.Column]

    init(environment: DesignSystemEnvironment) {
        self.environment = environment
        _selectedBoardItemID = State(initialValue: "review-tokens")
        _selectedPaletteItemID = State(initialValue: "metric-card")
        _boardColumns = State(initialValue: contentBoardColumns(environment: environment))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Tabs(environment: environment, items: [
                .init(title: "Overview", value: "overview"),
                .init(title: "Content", value: "content"),
                .init(title: "Code", value: "code")
            ], selection: $tab)

            if tab == "overview" {
                CardGrid(environment: environment, data: contentCards, columns: 3) { card in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(card.title)
                            .font(environment.theme.typography(.bodyStrong).font)
                        Text(card.detail)
                            .font(environment.theme.typography(.caption).font)
                            .foregroundStyle(environment.theme.color(.textSecondary))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else if tab == "content" {
                VStack(alignment: .leading, spacing: 14) {
                    ExpandableSection(environment: environment, title: "Advanced notes", subtitle: "Expandable surfaces should keep grouped DNA.", isExpanded: $isExpanded) {
                        Text("Structure should come from reusable content primitives instead of local card stacks.")
                            .font(environment.theme.typography(.body).font)
                            .foregroundStyle(environment.theme.color(.textSecondary))
                    }

                    HStack(alignment: .top, spacing: 16) {
                        Board(
                            environment: environment,
                            columns: boardColumns,
                            selectedItemID: $selectedBoardItemID,
                            onActivateItem: { item in
                                selectedBoardItemID = item.id
                            },
                            onMoveItem: { itemID, destinationColumnID, destinationIndex in
                                boardColumns = moveBoardItem(
                                    in: boardColumns,
                                    itemID: itemID,
                                    destinationColumnID: destinationColumnID,
                                    destinationIndex: destinationIndex
                                )
                                selectedBoardItemID = itemID
                            }
                        )
                        .frame(maxWidth: .infinity)

                        ItemsPalette(
                            environment: environment,
                            title: "Add content",
                            subtitle: "Select a reusable tile or insert it into the board.",
                            items: contentPaletteItems(environment: environment),
                            selectedItemID: $selectedPaletteItemID,
                            insertDestinations: boardInsertDestinations(from: boardColumns),
                            onActivateItem: { item in
                                selectedPaletteItemID = item.id
                            },
                            onInsertItem: { item, destinationColumnID, destinationIndex in
                                boardColumns = insertBoardItem(
                                    item,
                                    into: boardColumns,
                                    destinationColumnID: destinationColumnID,
                                    destinationIndex: destinationIndex
                                )
                                selectedPaletteItemID = item.id
                            }
                        )
                        .frame(width: 320)
                    }

                    Text("Selection, move, and insert callbacks stay with the consumer while the system owns the presentation contract.")
                        .font(environment.theme.typography(.caption).font)
                        .foregroundStyle(environment.theme.color(.textSecondary))
                }
            } else {
                CodeView(environment: environment, code: "let system = BuilderDesignSystem()")
            }
        }
    }
}

private struct DataReferenceExample: View {
    let environment: DesignSystemEnvironment
    @StateObject private var announcementCenter: AnnouncementCenter
    @StateObject private var collectionController: CollectionController<DataTable.Row>
    @StateObject private var chartController: MetricChartController

    init(environment: DesignSystemEnvironment) {
        self.environment = environment

        let announcementCenter = AnnouncementCenter()
        _announcementCenter = StateObject(wrappedValue: announcementCenter)
        _collectionController = StateObject(
            wrappedValue: makeDataCollectionController(announcementCenter: announcementCenter)
        )
        _chartController = StateObject(
            wrappedValue: MetricChartController(announcementCenter: announcementCenter)
        )
    }

    private var coverageSeries: MetricSeries {
        .init(title: "Coverage", color: environment.theme.color(.chartBlue), points: [
            .init(label: "Tokens", value: 82),
            .init(label: "Components", value: 80),
            .init(label: "Patterns", value: 24)
        ])
    }

    private var adoptionSeries: MetricSeries {
        .init(title: "Adoption", color: environment.theme.color(.chartTeal), points: [
            .init(label: "Tokens", value: 64),
            .init(label: "Components", value: 58),
            .init(label: "Patterns", value: 18)
        ])
    }

    private var selectedPairs: [KeyValuePairs.Pair] {
        guard let selectedMetric = chartController.activeSelection else {
            return [
                .init(key: "Selection", value: "Choose a visible metric"),
                .init(key: "Behavior", value: "Hover, filter, or choose a row to pin the same metric.")
            ]
        }

        return [
            .init(key: "Series", value: selectedMetric.seriesTitle),
            .init(key: "Metric", value: selectedMetric.label),
            .init(key: "Value", value: selectedMetric.formattedValue)
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                TextFilterField(
                    environment: environment,
                    placeholder: "Filter metrics",
                    controller: collectionController
                )

                ViewPreferencesPanel(environment: environment, controller: collectionController)
                    .frame(width: 220)
            }

            MixedChartPanel(
                environment: environment,
                title: "Coverage and adoption",
                subtitle: "Collection and chart controllers keep selection, pagination, and announcements aligned.",
                state: collectionController.presentationState,
                barSeries: [coverageSeries],
                lineSeries: [adoptionSeries],
                controller: chartController,
                valueFormatter: percentMetricValue
            )

            HStack(alignment: .top, spacing: 16) {
                KeyValuePairs(environment: environment, pairs: selectedPairs)
                    .frame(maxWidth: .infinity)

                BarChartPanel(
                    environment: environment,
                    title: "Coverage refresh",
                    subtitle: "Async state keeps the layout stable while metrics reload.",
                    state: .loading(.init(label: "Refreshing coverage", detail: "Legend and selection affordances stay in place.")),
                    series: [
                        .init(title: "Coverage", color: environment.theme.color(.chartPurple), points: [
                            .init(label: "Dashboards", value: 74),
                            .init(label: "Forms", value: 61),
                            .init(label: "Feedback", value: 89)
                        ])
                    ],
                    valueFormatter: percentMetricValue,
                    height: 180
                )
                .frame(maxWidth: .infinity)

                DonutChartPanel(
                    environment: environment,
                    title: "Status mix",
                    state: .ready,
                    slices: [
                        .init(title: "Ready", value: 18, color: environment.theme.color(.chartGreen)),
                        .init(title: "Review", value: 7, color: environment.theme.color(.chartAmber)),
                        .init(title: "Blocked", value: 3, color: environment.theme.color(.chartRed))
                    ],
                    selection: .constant(nil),
                    visibleSeriesIDs: .constant(["Ready", "Review", "Blocked"]),
                    valueFormatter: { value in "\(Int(value)) items" },
                    height: 180
                )
                .frame(maxWidth: .infinity)
            }

            DataTable(
                environment: environment,
                columns: [
                    .init(title: "Area"),
                    .init(title: "Status"),
                    .init(title: "Updated")
                ],
                controller: collectionController
            )

            PaginationControl(environment: environment, controller: collectionController)

            if let latestMessage = announcementCenter.latestMessage {
                LiveRegionMessage(environment: environment, message: latestMessage)
            }
        }
        .onAppear {
            synchronizeChartSelection(with: collectionController.selectedItemID)
        }
        .onChange(of: chartController.activeSelection?.datumID) { _, nextValue in
            guard collectionController.selectedItemID != nextValue else { return }
            collectionController.select(itemID: nextValue)
        }
        .onChange(of: collectionController.selectedItemID) { _, nextValue in
            synchronizeChartSelection(with: nextValue)
        }
    }

    private func synchronizeChartSelection(with itemID: String?) {
        guard let itemID else {
            chartController.clearPinnedSelection()
            return
        }

        guard chartController.pinnedSelection?.datumID != itemID else { return }
        chartController.pin(coverageSelection(label: itemID))
    }
}

private struct AIReferenceExample: View {
    let environment: DesignSystemEnvironment
    @StateObject private var announcementCenter: AnnouncementCenter
    @StateObject private var promptController: PromptComposerController
    @StateObject private var conversationController: ConversationController
    @State private var selectedPromptID = "summarize"

    init(environment: DesignSystemEnvironment) {
        self.environment = environment

        let announcementCenter = AnnouncementCenter()
        _announcementCenter = StateObject(wrappedValue: announcementCenter)
        _promptController = StateObject(
            wrappedValue: PromptComposerController(
                draft: "Summarize the latest runtime additions and call out any remaining rollout risks.",
                supportingText: "Command-Return submits. Draft persistence and streaming state stay with the controller.",
                submitShortcutBehavior: .commandReturn
            )
        )
        _conversationController = StateObject(
            wrappedValue: ConversationController(
                messages: [
                    .init(
                        role: .assistant,
                        author: "Builder assistant",
                        message: "BuilderBehaviors keeps reusable runtime logic headless so the views stay composable.",
                        detail: "Submit a prompt to stream a new reply through the injected driver.",
                        footerMetadata: [
                            .init(label: "Runtime", value: "Controller-backed"),
                            .init(label: "Updated", value: "Now")
                        ]
                    )
                ],
                driver: ReferenceConversationDriver(),
                announcementCenter: announcementCenter
            )
        )
    }

    var body: some View {
        PanelSurface(environment: environment, title: "Generative workflow", subtitle: "Keep prompt, output, and review actions explicit.") {
            HStack(spacing: 10) {
                AvatarView(environment: environment, title: "Builder assistant", symbol: "sparkles")
                TokenBadge(
                    environment: environment,
                    title: conversationController.isStreaming ? "Streaming" : "Runtime backed",
                    tint: nil
                )
            }

            PromptInput(
                environment: environment,
                controller: promptController,
                actionTitle: "Draft",
                isMultiline: true,
                minHeight: 110,
                secondaryActionTitle: "Clear",
                secondaryActionSymbol: "xmark",
                onSecondaryAction: {
                    promptController.clear()
                    selectedPromptID = ""
                }
            ) {
                promptController.beginSubmitting()
                conversationController.send(prompt: promptController.draft)
            }

            SupportPromptGroup(
                environment: environment,
                title: "Suggested prompts",
                prompts: [
                    .init(
                        id: "summarize",
                        title: "Summarize the runtime rollout",
                        detail: "Condense the latest controller work.",
                        isSelected: selectedPromptID == "summarize",
                        isRecommended: true
                    ),
                    .init(
                        id: "find-gaps",
                        title: "Find remaining orchestration gaps",
                        detail: "Inspect any app-owned runtime glue that still remains.",
                        isSelected: selectedPromptID == "find-gaps"
                    ),
                    .init(
                        id: "compare",
                        title: "Explain protocol tradeoffs",
                        detail: "Compare controller-backed and callback-only adoption paths.",
                        isEnabled: false,
                        isSelected: selectedPromptID == "compare"
                    )
                ]
            ) { selected in
                promptController.acceptSuggestion(selected.title)
                selectedPromptID = selected.id
            }

            ForEach(conversationController.messages) { message in
                ChatBubble(
                    environment: environment,
                    message: message,
                    showsCopyAction: message.role == .assistant,
                    onRetry: message.state == .error ? {
                        conversationController.retry(messageID: message.id)
                    } : nil
                )
            }

            if let latestMessage = announcementCenter.latestMessage {
                LiveRegionMessage(environment: environment, message: latestMessage)
            }
        }
        .onChange(of: conversationController.isStreaming) { _, isStreaming in
            if isStreaming {
                promptController.beginSubmitting()
            } else {
                promptController.finishSubmitting()
            }
        }
    }
}

private struct TutorialReferenceExample: View {
    let environment: DesignSystemEnvironment
    @StateObject private var announcementCenter: AnnouncementCenter
    @StateObject private var tutorialController: TutorialFlowController
    @StateObject private var helpNavigator: HelpNavigator

    init(environment: DesignSystemEnvironment) {
        self.environment = environment

        let announcementCenter = AnnouncementCenter()
        _announcementCenter = StateObject(wrappedValue: announcementCenter)
        _tutorialController = StateObject(
            wrappedValue: makeTutorialFlowController(announcementCenter: announcementCenter)
        )
        _helpNavigator = StateObject(
            wrappedValue: makeHelpNavigator(announcementCenter: announcementCenter)
        )
    }

    var body: some View {
        WizardLayout(
            environment: environment,
            title: "Create a component family",
            steps: [
                .init(id: "audit", title: "Audit", detail: "Review the API and states."),
                .init(id: "build", title: "Build", detail: "Promote shared primitives."),
                .init(id: "verify", title: "Verify", detail: "Run tests and inspect the showcase.")
            ],
            currentStepID: tutorialController.currentStepID
        ) {
            HStack(alignment: .top, spacing: 16) {
                TutorialPanel(
                    environment: environment,
                    title: "Rollout guidance",
                    subtitle: "Controller-backed progression keeps state, announcements, and resume points aligned.",
                    controller: tutorialController
                ) {
                    Text("Tutorial flows should guide builders without leaving the shared shell language.")
                        .font(environment.theme.typography(.body).font)
                        .foregroundStyle(environment.theme.color(.textSecondary))
                } primaryActions: {
                    SystemButton(environment: environment, title: "Continue", tone: .primary) {
                        tutorialController.advance()
                    }
                } secondaryActions: {
                    HStack(spacing: 10) {
                        SystemButton(environment: environment, title: "Back", tone: .secondary) {
                            tutorialController.goBack()
                        }
                        SystemButton(environment: environment, title: "Skip optional", tone: .secondary) {
                            tutorialController.skipCurrentStep()
                        }
                    }
                }
                .frame(maxWidth: .infinity)

                HelpPanel(
                    environment: environment,
                    title: "Step help",
                    subtitle: "Context help can follow tutorial progress without becoming product logic.",
                    topics: helpNavigator.topics,
                    selectedTopicID: Binding(
                        get: { helpNavigator.selectedTopicID },
                        set: { helpNavigator.selectTopic($0) }
                    )
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(helpMessage(for: helpNavigator.selectedTopicID))
                            .font(environment.theme.typography(.body).font)
                            .foregroundStyle(environment.theme.color(.textSecondary))
                        ValidationMessage(
                            environment: environment,
                            status: .normal,
                            message: "Related guidance stays adjacent to the active rollout step."
                        )
                    }
                }
                .frame(width: 320)
            }

            if let latestMessage = announcementCenter.latestMessage {
                LiveRegionMessage(environment: environment, message: latestMessage)
            }
        }
        .onAppear {
            helpNavigator.sync(withTutorialStepID: tutorialController.currentStepID)
        }
        .onChange(of: tutorialController.currentStepID) { _, nextValue in
            helpNavigator.sync(withTutorialStepID: nextValue)
        }
    }
}

private struct UtilityReferenceExample: View {
    let environment: DesignSystemEnvironment

    private var sections: [SearchResultSection<String>] {
        [
            .init(
                title: "Components",
                items: [
                    .init(id: "button", title: "Button", subtitle: "Primary action control", symbol: "capsule"),
                    .init(id: "modal", title: "Modal", subtitle: "Overlay surface", symbol: "square.on.square")
                ]
            )
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SearchResultsOverlay(environment: environment, sections: sections) { _ in }
            EmptyStateView(
                environment: environment,
                title: "No utility results",
                message: "Try a broader term or clear the current query.",
                symbol: "magnifyingglass"
            )
        }
    }
}

private struct SpecializedReferenceExample: View {
    let environment: DesignSystemEnvironment
    @StateObject private var announcementCenter: AnnouncementCenter
    @StateObject private var importController: FileImportController
    @StateObject private var uploadController: FileUploadSessionController

    init(environment: DesignSystemEnvironment) {
        self.environment = environment

        let announcementCenter = AnnouncementCenter()
        let importController = makeReferenceFileImportController(announcementCenter: announcementCenter)
        let uploadController = makeReferenceFileUploadController(announcementCenter: announcementCenter)

        _announcementCenter = StateObject(wrappedValue: announcementCenter)
        _importController = StateObject(wrappedValue: importController)
        _uploadController = StateObject(wrappedValue: uploadController)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HelpPanel(environment: environment, title: "Help", subtitle: "Keep support adjacent to the active task.") {
                BulletList(environment: environment, items: [
                    "Import, paste, and upload stay inside one runtime-backed contract.",
                    "Validation and retry messaging come from the shared session controller.",
                    "Apps still own the real upload driver and file source."
                ])
            } footer: {
                HStack(spacing: 10) {
                    SystemButton(environment: environment, title: "Queue sample files", tone: .secondary) {
                        uploadController.enqueue(requests: sampleUploadRequests())
                    }
                    SystemButton(environment: environment, title: "Start uploads", tone: .primary) {
                        uploadController.startUploads(using: ReferenceUploadDriver())
                    }
                }
                SystemButton(environment: environment, title: "Remove completed", tone: .secondary) {
                    uploadController.removeCompleted()
                }
            }

            FileUploadField(
                environment: environment,
                title: "Attach release notes",
                subtitle: "The field owns interaction wiring while the app still injects import and upload drivers.",
                dropTitle: "Drop release notes",
                dropDetail: "Accept Markdown, PDF, image, and archive files from Finder.",
                importController: importController,
                uploadController: uploadController,
                pickerTitle: "Browse sample files",
                pasteActionTitle: "Paste from clipboard"
            )

            if let latestMessage = announcementCenter.latestMessage {
                LiveRegionMessage(environment: environment, message: latestMessage)
            }
        }
    }
}

private struct ActionFlowPatternExample: View {
    let environment: DesignSystemEnvironment

    var body: some View {
        PanelSurface(environment: environment, title: "Action flow", subtitle: "Keep the next action obvious.") {
            ValidationSummary(
                environment: environment,
                items: [
                    .init(id: "name", title: "Project name", detail: "Name the product surface before continuing.", status: .warning)
                ]
            )
            HStack(spacing: 10) {
                SystemButton(environment: environment, title: "Continue", tone: .primary) {}
                SystemButton(environment: environment, title: "Save draft", tone: .secondary) {}
            }
        }
    }
}

private struct AnnouncementPatternExample: View {
    let environment: DesignSystemEnvironment

    var body: some View {
        NoticeStack(environment: environment, notices: [
            .init(title: "New workflow", message: "Open Recipes to inspect the updated navigation and validation patterns.", tone: .info),
            .init(title: "Preview", message: "The new examples registry is available for review in the showcase.", tone: .warning)
        ])
    }
}

private struct UnsavedChangesPatternExample: View {
    let environment: DesignSystemEnvironment

    var body: some View {
        ModalSurface(environment: environment, title: "Leave without saving") {
            VStack(alignment: .leading, spacing: 12) {
                AlertBanner(
                    environment: environment,
                    title: "Unsaved edits",
                    message: "Save or discard your updates before you leave this surface.",
                    tone: .warning
                )
                HStack(spacing: 10) {
                    SystemButton(environment: environment, title: "Save changes", tone: .primary) {}
                    SystemButton(environment: environment, title: "Discard", tone: .secondary) {}
                }
            }
        }
    }
}

private struct DataVisualizationPatternExample: View {
    let environment: DesignSystemEnvironment
    @StateObject private var announcementCenter: AnnouncementCenter
    @StateObject private var collectionController: CollectionController<DataTable.Row>
    @StateObject private var chartController: MetricChartController

    init(environment: DesignSystemEnvironment) {
        self.environment = environment

        let announcementCenter = AnnouncementCenter()
        _announcementCenter = StateObject(wrappedValue: announcementCenter)
        _collectionController = StateObject(
            wrappedValue: makeVisualizationCollectionController(announcementCenter: announcementCenter)
        )
        _chartController = StateObject(
            wrappedValue: MetricChartController(announcementCenter: announcementCenter)
        )
    }

    private var coverageSeries: MetricSeries {
        .init(title: "Coverage", color: environment.theme.color(.chartBlue), points: [
            .init(label: "Navigation", value: 76),
            .init(label: "Forms", value: 68),
            .init(label: "Feedback", value: 59)
        ])
    }

    private var adoptionSeries: MetricSeries {
        .init(title: "Adoption", color: environment.theme.color(.chartTeal), points: [
            .init(label: "Navigation", value: 62),
            .init(label: "Forms", value: 51),
            .init(label: "Feedback", value: 48)
        ])
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            PropertyFilterBar(environment: environment, controller: collectionController)

            MixedChartPanel(
                environment: environment,
                title: "Usage coverage",
                subtitle: "The chart controller stays synchronized with collection filters and table selection.",
                state: collectionController.presentationState,
                barSeries: [coverageSeries],
                lineSeries: [adoptionSeries],
                controller: chartController,
                valueFormatter: percentMetricValue
            )

            HStack(alignment: .top, spacing: 16) {
                KeyValuePairs(
                    environment: environment,
                    pairs: [
                        .init(key: "Series", value: chartController.activeSelection?.seriesTitle ?? "Coverage"),
                        .init(key: "Metric", value: chartController.activeSelection?.label ?? "Navigation"),
                        .init(key: "Value", value: chartController.activeSelection?.formattedValue ?? "76%")
                    ]
                )
                .frame(maxWidth: .infinity)

                DonutChartPanel(
                    environment: environment,
                    title: "Coverage mix",
                    state: .loading(.init(label: "Refreshing status mix", detail: "Use the same async contract as the main chart.")),
                    slices: [
                        .init(title: "Ready", value: 18, color: environment.theme.color(.chartGreen)),
                        .init(title: "Review", value: 9, color: environment.theme.color(.chartAmber)),
                        .init(title: "Planned", value: 6, color: environment.theme.color(.chartPurple))
                    ],
                    height: 180
                )
                .frame(width: 320)
            }

            DataTable(
                environment: environment,
                columns: [.init(title: "Surface"), .init(title: "State"), .init(title: "Updated")],
                controller: collectionController
            )

            if let latestMessage = announcementCenter.latestMessage {
                LiveRegionMessage(environment: environment, message: latestMessage)
            }
        }
        .onAppear {
            synchronizeSelection(with: collectionController.selectedItemID)
        }
        .onChange(of: chartController.activeSelection?.datumID) { _, nextValue in
            guard collectionController.selectedItemID != nextValue else { return }
            collectionController.select(itemID: nextValue)
        }
        .onChange(of: collectionController.selectedItemID) { _, nextValue in
            synchronizeSelection(with: nextValue)
        }
    }

    private func synchronizeSelection(with itemID: String?) {
        guard let itemID else {
            chartController.clearPinnedSelection()
            return
        }

        guard chartController.pinnedSelection?.datumID != itemID else { return }
        chartController.pin(coverageSelection(label: itemID))
    }
}

private struct DensityPatternExample: View {
    let environment: DesignSystemEnvironment
    @State private var density = 1

    var body: some View {
        SettingsGroup(environment: environment) {
            SettingsRow(environment: environment, title: "Density", detail: "Align rows and fields across the shell.") {
                SegmentedPicker(
                    environment: environment,
                    options: [("Compact", 0), ("Default", 1), ("Comfortable", 2)],
                    selection: $density,
                    style: .neutral
                )
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

private struct StateHandlingPatternExample: View {
    let environment: DesignSystemEnvironment

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            EmptyStateView(
                environment: environment,
                title: "No matching surfaces",
                message: "Clear the current filter to restore the full library."
            )
            ValidationSummary(
                environment: environment,
                items: [
                    .init(id: "filter", title: "Filter scope", detail: "Choose at least one enabled scope.", status: .error),
                    .init(id: "copy", title: "Empty-state copy", detail: "Offer one clear next step.", status: .warning)
                ]
            )
        }
    }
}

private struct DragAndDropPatternExample: View {
    let environment: DesignSystemEnvironment
    @StateObject private var announcementCenter: AnnouncementCenter
    @StateObject private var importController: FileImportController
    @StateObject private var uploadController: FileUploadSessionController
    @StateObject private var boardController: BoardController
    @State private var columns: [Board.Column]

    init(environment: DesignSystemEnvironment) {
        self.environment = environment

        let announcementCenter = AnnouncementCenter()
        _announcementCenter = StateObject(wrappedValue: announcementCenter)
        _importController = StateObject(
            wrappedValue: FileImportController(
                acceptedContentTypes: [.plainText, .pdf, .image],
                source: ReferenceFileImportSource(urls: sampleUploadURLs().filter {
                    matchesAcceptedContentType($0, acceptedContentTypes: [.plainText, .pdf, .image])
                }),
                announcementCenter: announcementCenter
            )
        )
        _uploadController = StateObject(
            wrappedValue: FileUploadSessionController(
                items: dragAndDropUploadItems,
                announcementCenter: announcementCenter
            )
        )
        _boardController = StateObject(
            wrappedValue: BoardController(
                selectedItemID: "review-docs",
                announcementCenter: announcementCenter,
                focusCoordinator: FocusCoordinator(focusedID: "review-docs")
            )
        )
        _columns = State(initialValue: dragAndDropBoardColumns(environment: environment))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            FileUploadField(
                environment: environment,
                title: "Drop files",
                subtitle: "Import, paste, queue, and upload stay coordinated through runtime controllers.",
                dropTitle: "Drop release notes here",
                dropDetail: "Or use Browse to upload from disk.",
                importController: importController,
                uploadController: uploadController,
                pickerTitle: "Browse samples",
                pasteActionTitle: "Paste files"
            )

            HStack(spacing: 10) {
                SystemButton(environment: environment, title: "Queue samples", tone: .secondary) {
                    uploadController.enqueue(requests: sampleUploadRequests())
                }
                SystemButton(environment: environment, title: "Start uploads", tone: .primary) {
                    uploadController.startUploads(using: ReferenceUploadDriver())
                }
            }

            HStack(alignment: .top, spacing: 16) {
                Board(
                    environment: environment,
                    columns: $columns,
                    controller: boardController,
                    onActivateItem: { item in
                        boardController.activate(itemID: item.id)
                    },
                    paletteItemResolver: { itemID in
                        contentPaletteItems(environment: environment).first { $0.id == itemID }
                    }
                )
                .frame(maxWidth: .infinity)

                ItemsPalette(
                    environment: environment,
                    title: "Insert items",
                    subtitle: "Use explicit insert commands or native drag and drop from the same board controller.",
                    items: contentPaletteItems(environment: environment),
                    controller: boardController,
                    insertDestinations: boardInsertDestinations(from: columns),
                    onActivateItem: { item in
                        boardController.activate(itemID: item.id)
                    },
                    onInsertItem: { item, destinationColumnID, destinationIndex in
                        let oldColumns = columns
                        let newColumns = insertBoardItem(
                            item,
                            into: columns,
                            destinationColumnID: destinationColumnID,
                            destinationIndex: destinationIndex
                        )
                        let destinationTitle = columns.first { $0.id == destinationColumnID }?.title ?? "column"
                        boardController.insert(
                            itemID: item.id,
                            itemTitle: item.title,
                            destinationColumnTitle: destinationTitle
                        ) {
                            columns = newColumns
                        } undo: {
                            columns = oldColumns
                        }
                    }
                )
                .frame(width: 320)
            }

            if let latestMessage = announcementCenter.latestMessage {
                LiveRegionMessage(environment: environment, message: latestMessage)
            }
        }
    }
}

private struct FilteringPatternExample: View {
    let environment: DesignSystemEnvironment
    @StateObject private var filterState = BrowserFilterState<String>(query: "text", selectedScope: "Components")

    private var sections: [SearchResultSection<String>] {
        [
            .init(
                title: "Components",
                items: [
                    .init(id: "text-input", title: "Text input", subtitle: "Editable field", symbol: "rectangle.and.pencil.and.ellipsis"),
                    .init(id: "text-area", title: "Text area", subtitle: "Long-form field", symbol: "doc.text")
                ]
            )
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextInputField(environment: environment, placeholder: "Search components", text: $filterState.query, leadingSymbol: "magnifyingglass")
            SearchResultsOverlay(environment: environment, sections: sections) { _ in }
        }
    }
}

private struct HeroPatternExample: View {
    let environment: DesignSystemEnvironment

    var body: some View {
        PanelSurface(environment: environment, title: "Build with the system", subtitle: "Open Components when you need a primitive, Recipes when you need a composed flow.") {
            HStack(spacing: 10) {
                SystemButton(environment: environment, title: "Browse components", tone: .primary) {}
                SystemButton(environment: environment, title: "Open recipes", tone: .secondary) {}
            }
        }
    }
}

private struct SupportPatternExample: View {
    let environment: DesignSystemEnvironment
    @StateObject private var announcementCenter: AnnouncementCenter
    @StateObject private var helpNavigator: HelpNavigator

    init(environment: DesignSystemEnvironment) {
        self.environment = environment

        let announcementCenter = AnnouncementCenter()
        _announcementCenter = StateObject(wrappedValue: announcementCenter)
        _helpNavigator = StateObject(
            wrappedValue: makeHelpNavigator(announcementCenter: announcementCenter)
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HelpPanel(
                environment: environment,
                title: "Guidance",
                subtitle: "Keep help adjacent to work instead of interrupting the current task.",
                navigator: helpNavigator
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(helpMessage(for: helpNavigator.selectedTopicID))
                        .font(environment.theme.typography(.body).font)
                        .foregroundStyle(environment.theme.color(.textSecondary))
                    ValidationMessage(environment: environment, status: .normal, message: "Use the same calm shell language as the main workspace.")
                }
            }

            if let latestMessage = announcementCenter.latestMessage {
                LiveRegionMessage(environment: environment, message: latestMessage)
            }
        }
    }
}

private struct LoadingPatternExample: View {
    let environment: DesignSystemEnvironment

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            LoadingSpinner(environment: environment, label: "Refreshing metrics")
            LoadingBar(environment: environment, label: "Indexing references", detail: "Duration is not yet known.")
            StatusIndicator(environment: environment, label: "Refresh in progress", detail: "The data table and chart should keep their layout stable.", tone: .info)
            ProgressBar(environment: environment, value: 0.66, label: "Publishing docs")
        }
    }
}

private struct OnboardingPatternExample: View {
    let environment: DesignSystemEnvironment
    @StateObject private var announcementCenter: AnnouncementCenter
    @StateObject private var tutorialController: TutorialFlowController
    @State private var showsCoachmark = true

    init(environment: DesignSystemEnvironment) {
        self.environment = environment

        let announcementCenter = AnnouncementCenter()
        _announcementCenter = StateObject(wrappedValue: announcementCenter)
        _tutorialController = StateObject(
            wrappedValue: TutorialFlowController(
                steps: [
                    .init(id: "Choose", title: "Choose", detail: "Pick the team and scope.", status: .complete),
                    .init(id: "Tune", title: "Tune", detail: "Confirm density, guidance, and defaults.", status: .current),
                    .init(id: "Validate", title: "Validate", detail: "Run the final rollout checks.", status: .warning, isOptional: true)
                ],
                currentStepID: "Tune",
                completedStepIDs: ["Choose"],
                announcementCenter: announcementCenter
            )
        )
    }

    var body: some View {
        CoachmarkHost(
            environment: environment,
            step: showsCoachmark ? coachmarkStep : nil,
            onPrimaryAction: {
                tutorialController.advance()
                showsCoachmark = false
            },
            onSecondaryAction: {
                showsCoachmark = false
            }
        ) {
            WizardLayout(
                environment: environment,
                title: "Bring a team into the system",
                steps: [
                    .init(title: "Choose"),
                    .init(title: "Tune"),
                    .init(title: "Validate")
                ],
                currentStepID: tutorialController.currentStepID
            ) {
                TutorialPanel(
                    environment: environment,
                    title: "Team onboarding",
                    subtitle: "Coachmarks can spotlight the next action without introducing product-specific runtime code.",
                    controller: tutorialController
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Guide teams into the system without changing the shell language.")
                            .font(environment.theme.typography(.body).font)
                            .foregroundStyle(environment.theme.color(.textSecondary))

                        AnnotationAnchor(id: "invite-team") {
                            SystemButton(environment: environment, title: "Invite team", tone: .primary) {}
                        }

                        if let latestMessage = announcementCenter.latestMessage {
                            LiveRegionMessage(environment: environment, message: latestMessage)
                        }
                    }
                } primaryActions: {
                    SystemButton(environment: environment, title: "Continue", tone: .primary) {
                        tutorialController.advance()
                    }
                } secondaryActions: {
                    SystemButton(environment: environment, title: "Back", tone: .secondary) {
                        tutorialController.goBack()
                    }
                }
            }
        }
    }

    private var coachmarkStep: CoachmarkStep {
        CoachmarkStep(
            anchorID: "invite-team",
            title: "Invite the rollout group",
            message: "Attach the next onboarding action to a real anchor so focus restoration and reduced motion stay consistent.",
            primaryActionTitle: "Continue",
            secondaryActionTitle: "Dismiss"
        )
    }
}

private struct NavigationPatternExample: View {
    let environment: DesignSystemEnvironment
    @State private var selection: String? = "components"

    private var sections: [NavigationSection<String>] {
        [
            .init(
                id: "workspace",
                title: "Workspace",
                items: [
                    .init(id: "home", title: "Home", symbol: "house"),
                    .init(id: "components", title: "Components", symbol: "square.grid.2x2"),
                    .init(id: "recipes", title: "Recipes", symbol: "square.on.square")
                ]
            )
        ]
    }

    var body: some View {
        AppLayout(environment: environment, sidebarWidth: 220) {
            NavigationSidebarList(environment: environment, sections: sections, selection: $selection, rowHeight: 44) { item, isSelected in
                SidebarRow(environment: environment, title: item.title, symbol: item.symbol ?? "circle", isSelected: isSelected)
            }
            .padding(16)
        } content: {
            PanelSurface(environment: environment, title: "Workspace", subtitle: "Primary navigation and content should feel like one desktop surface.") {
                Text("Current route: \(selection ?? "home")")
                    .font(environment.theme.typography(.body).font)
                    .foregroundStyle(environment.theme.color(.textSecondary))
            }
            .padding(18)
        }
        .frame(height: 280)
    }
}

private struct DashboardPatternExample: View {
    let environment: DesignSystemEnvironment
    @State private var selectedMetric: MetricSelection? = coverageSelection(label: "Tokens")
    @State private var visibleSeriesIDs: Set<String> = ["Coverage", "Target"]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            StatusIndicator(environment: environment, label: "Release candidate", detail: "Ready to hand off after the final review clears.", tone: .success)
            MixedChartPanel(
                environment: environment,
                title: "Coverage",
                subtitle: "Pinned metrics stay visible in the summary row.",
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
                valueFormatter: percentMetricValue
            )
        }
    }
}

private struct TimeAndFeedbackPatternExample: View {
    let environment: DesignSystemEnvironment

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            LiveRegionMessage(environment: environment, message: "Updated 2 hours ago")
            NoticeStack(environment: environment, notices: [
                .init(title: "Saved", message: "Token mappings were updated across light and dark mode.", tone: .success),
                .init(title: "Review pending", message: "Accessibility still needs a keyboard pass.", tone: .warning)
            ])
        }
    }
}

private func percentMetricValue(_ value: Double) -> String {
    "\(Int(value.rounded()))%"
}

private func coverageSelection(label: String) -> MetricSelection {
    let values: [String: Double] = [
        "Tokens": 82,
        "Components": 80,
        "Patterns": 24,
        "Navigation": 76,
        "Forms": 68,
        "Feedback": 59
    ]

    let resolvedValue = values[label] ?? 0

    return MetricSelection(
        kind: .point,
        seriesID: "Coverage",
        seriesTitle: "Coverage",
        datumID: label,
        label: label,
        value: resolvedValue,
        formattedValue: percentMetricValue(resolvedValue)
    )
}

@MainActor
private func makeDataCollectionController(
    announcementCenter: AnnouncementCenter
) -> CollectionController<DataTable.Row> {
    CollectionController(
        items: [
            .init(id: "Tokens", cells: ["Tokens", "Ready", "Now"]),
            .init(id: "Components", cells: ["Components", "Review", "2h ago"]),
            .init(id: "Patterns", cells: ["Patterns", "Ready", "1d ago"])
        ],
        pageSize: 2,
        selectedItemID: "Tokens",
        searchableText: { row in
            row.cells.joined(separator: " ")
        },
        announcementCenter: announcementCenter
    )
}

@MainActor
private func makeVisualizationCollectionController(
    announcementCenter: AnnouncementCenter
) -> CollectionController<DataTable.Row> {
    CollectionController(
        items: [
            .init(id: "Navigation", cells: ["Navigation", "ready", "Now"]),
            .init(id: "Forms", cells: ["Forms", "review", "3h ago"]),
            .init(id: "Feedback", cells: ["Feedback", "planned", "Tomorrow"])
        ],
        activeFilterTokens: ["ready", "review"],
        pageSize: 3,
        selectedItemID: "Navigation",
        searchableText: { row in
            row.cells.joined(separator: " ")
        },
        filterMatcher: { row, tokens in
            guard row.cells.count > 1 else { return true }
            return tokens.contains(row.cells[1].lowercased())
        },
        announcementCenter: announcementCenter
    )
}

@MainActor
private func makeTutorialFlowController(
    announcementCenter: AnnouncementCenter
) -> TutorialFlowController {
    TutorialFlowController(
        steps: [
            .init(id: "audit", title: "Audit", detail: "Review API shape.", status: .complete),
            .init(id: "build", title: "Build", detail: "Add reusable surfaces.", status: .current),
            .init(id: "verify", title: "Verify", detail: "Run validation before release.", status: .warning, isOptional: true)
        ],
        currentStepID: "build",
        completedStepIDs: ["audit"],
        announcementCenter: announcementCenter
    )
}

@MainActor
private func makeHelpNavigator(
    announcementCenter: AnnouncementCenter
) -> HelpNavigator {
    HelpNavigator(
        topics: [
            .init(id: "context", title: "Current context", detail: "Tie guidance to the active workflow.", symbol: "scope"),
            .init(id: "recovery", title: "Recovery", detail: "Name the next safe action.", symbol: "arrow.uturn.backward"),
            .init(id: "handoff", title: "Handoff", detail: "Explain what changes next.", symbol: "square.and.arrow.up")
        ],
        selectedTopicID: "context",
        relatedTopicsByID: [
            "context": ["recovery", "handoff"],
            "recovery": ["context", "handoff"],
            "handoff": ["context", "recovery"]
        ],
        tutorialTopicMap: [
            "audit": "context",
            "build": "recovery",
            "verify": "handoff"
        ],
        announcementCenter: announcementCenter
    )
}

private func helpMessage(for topicID: String?) -> String {
    switch topicID {
    case "recovery":
        "Recovery guidance should name the failed step and the safest next move without forcing the user out of the current panel."
    case "handoff":
        "Handoff guidance should confirm what changed, what still needs review, and who owns the next action."
    default:
        "Link support guidance to the active decision and preserve the user’s place in the workflow."
    }
}

@MainActor
private func makeReferenceFileImportController(
    announcementCenter: AnnouncementCenter
) -> FileImportController {
    FileImportController(
        acceptedContentTypes: [.plainText, .pdf, .image, .archive],
        source: ReferenceFileImportSource(urls: sampleUploadURLs()),
        announcementCenter: announcementCenter,
        focusCoordinator: FocusCoordinator()
    )
}

@MainActor
private func makeReferenceFileUploadController(
    announcementCenter: AnnouncementCenter
) -> FileUploadSessionController {
    let controller = FileUploadSessionController(announcementCenter: announcementCenter)
    controller.enqueue(requests: sampleUploadRequests())
    return controller
}

private func sampleUploadURLs() -> [URL] {
    [
        URL(fileURLWithPath: "/tmp/release-notes.md"),
        URL(fileURLWithPath: "/tmp/design-review.pdf"),
        URL(fileURLWithPath: "/tmp/preview.png"),
        URL(fileURLWithPath: "/tmp/screenshots.zip")
    ]
}

private func sampleUploadRequests() -> [FileUploadRequest] {
    [
        .init(url: URL(fileURLWithPath: "/tmp/release-notes.md"), detail: "18 KB", symbol: "doc.text"),
        .init(url: URL(fileURLWithPath: "/tmp/design-review.pdf"), detail: "42 KB", symbol: "doc.richtext"),
        .init(url: URL(fileURLWithPath: "/tmp/preview.png"), detail: "640 KB", symbol: "photo")
    ]
}

private struct ReferenceFileImportSource: FileImportSource, Sendable {
    let urls: [URL]

    func selectFiles(
        acceptedContentTypes: [UTType],
        allowsMultipleSelection: Bool
    ) async throws -> [URL] {
        let accepted = urls.filter { url in
            matchesAcceptedContentType(url, acceptedContentTypes: acceptedContentTypes)
        }
        return allowsMultipleSelection ? accepted : Array(accepted.prefix(1))
    }
}

private struct ReferenceUploadDriver: FileUploadDriver, Sendable {
    func upload(request: FileUploadRequest) -> AsyncThrowingStream<FileUploadEvent, Error> {
        AsyncThrowingStream { continuation in
            continuation.yield(
                .init(
                    requestID: request.id,
                    status: .uploading,
                    progress: 0.34,
                    message: "Uploading \(request.title)...",
                    symbol: request.symbol
                )
            )

            if request.title.localizedCaseInsensitiveContains("preview") {
                continuation.yield(
                    .init(
                        requestID: request.id,
                        status: .error,
                        progress: nil,
                        message: "Preview files need review before upload.",
                        symbol: request.symbol,
                        canRetry: true
                    )
                )
            } else {
                continuation.yield(
                    .init(
                        requestID: request.id,
                        status: .success,
                        progress: 1,
                        message: "Uploaded successfully.",
                        symbol: request.symbol
                    )
                )
            }

            continuation.finish()
        }
    }
}

private struct ReferenceConversationDriver: ConversationDriver, Sendable {
    func streamReply(
        prompt: String,
        history _: [ConversationMessage]
    ) -> AsyncThrowingStream<ConversationStreamEvent, Error> {
        AsyncThrowingStream { continuation in
            if prompt.localizedCaseInsensitiveContains("fail") {
                continuation.finish(throwing: NSError(domain: "BuilderReferenceExamples", code: 1))
                return
            }

            continuation.yield(.appendText("BuilderBehaviors now centralizes reusable runtime state. "))
            continuation.yield(.appendText("Selection, streaming, uploads, commands, and announcements all compose through injected drivers."))
            continuation.yield(.setDetail("The runtime layer stays headless, so product services and domain persistence remain app-owned."))
            continuation.yield(
                .setFooterMetadata([
                    .init(label: "Driver", value: "Reference conversation"),
                    .init(label: "Status", value: "Complete")
                ])
            )
            continuation.yield(.complete)
            continuation.finish()
        }
    }
}

private func contentBoardColumns(environment: DesignSystemEnvironment) -> [Board.Column] {
    [
        .init(id: "queued", title: "Queued", items: [
            .init(id: "review-tokens", title: "Review tokens", detail: "Validation and docs", status: "Review", statusColor: environment.theme.color(.warning), symbol: "checklist"),
            .init(id: "verify-docs", title: "Verify docs", detail: "Generated references", status: "Ready", statusColor: environment.theme.color(.success), symbol: "doc.text.magnifyingglass")
        ]),
        .init(id: "done", title: "Done", items: [
            .init(id: "ship-foundations", title: "Ship foundations", detail: "Token exports and handbook", status: "Done", statusColor: environment.theme.color(.success), symbol: "shippingbox")
        ])
    ]
}

private func dragAndDropBoardColumns(environment: DesignSystemEnvironment) -> [Board.Column] {
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

private func contentPaletteItems(environment: DesignSystemEnvironment) -> [Board.Item] {
    [
        .init(id: "metric-card", title: "Metric card", detail: "Reusable dashboard tile.", status: "Ready", statusColor: environment.theme.color(.success), symbol: "chart.bar"),
        .init(id: "status-list", title: "Status list", detail: "Dense collection summary.", status: "Review", statusColor: environment.theme.color(.warning), symbol: "list.bullet.rectangle"),
        .init(id: "release-note", title: "Release note", detail: "Attach guidance to a workflow column.", status: "Info", statusColor: environment.theme.color(.info), symbol: "paperclip")
    ]
}

private let specializedUploadItems: [FileUploadItem] = [
    .init(id: "release-notes", title: "release-notes.md", detail: "18 KB", status: .success, message: "Uploaded successfully.", symbol: "doc.text"),
    .init(id: "screenshots", title: "screenshots.zip", detail: "2 files", status: .uploading, progress: 0.64, message: "Uploading archive...", symbol: "archivebox"),
    .init(id: "hero-image", title: "hero.png", detail: "4.2 MB", status: .error, message: "The file exceeds the current size limit.", symbol: "photo", canRetry: true)
]

private let dragAndDropUploadItems: [FileUploadItem] = [
    .init(id: "checklist", title: "checklist.md", detail: "12 KB", status: .success, message: "Uploaded successfully.", symbol: "checklist"),
    .init(id: "preview", title: "preview.png", detail: "640 KB", status: .warning, message: "Review the generated preview before publishing.", symbol: "photo", canRetry: true)
]

private func boardInsertDestinations(from columns: [Board.Column]) -> [Board.Destination] {
    columns.map { column in
        .init(
            title: "Insert into \(column.title)",
            columnID: column.id,
            columnTitle: column.title,
            index: column.items.count
        )
    }
}

private func moveBoardItem(
    in columns: [Board.Column],
    itemID: String,
    destinationColumnID: String,
    destinationIndex: Int
) -> [Board.Column] {
    var mutableColumns = columns
    var movingItem: Board.Item?

    for columnIndex in mutableColumns.indices {
        if let itemIndex = mutableColumns[columnIndex].items.firstIndex(where: { $0.id == itemID }) {
            movingItem = mutableColumns[columnIndex].items[itemIndex]
            var items = mutableColumns[columnIndex].items
            items.remove(at: itemIndex)
            mutableColumns[columnIndex] = .init(
                id: mutableColumns[columnIndex].id,
                title: mutableColumns[columnIndex].title,
                items: items
            )
            break
        }
    }

    guard let movingItem else { return columns }

    for columnIndex in mutableColumns.indices where mutableColumns[columnIndex].id == destinationColumnID {
        var items = mutableColumns[columnIndex].items
        let boundedIndex = min(max(destinationIndex, 0), items.count)
        items.insert(movingItem, at: boundedIndex)
        mutableColumns[columnIndex] = .init(
            id: mutableColumns[columnIndex].id,
            title: mutableColumns[columnIndex].title,
            items: items
        )
        return mutableColumns
    }

    return columns
}

private func insertBoardItem(
    _ item: Board.Item,
    into columns: [Board.Column],
    destinationColumnID: String,
    destinationIndex: Int
) -> [Board.Column] {
    var mutableColumns = columns

    for columnIndex in mutableColumns.indices where mutableColumns[columnIndex].id == destinationColumnID {
        var items = mutableColumns[columnIndex].items
        let boundedIndex = min(max(destinationIndex, 0), items.count)
        items.insert(item, at: boundedIndex)
        mutableColumns[columnIndex] = .init(
            id: mutableColumns[columnIndex].id,
            title: mutableColumns[columnIndex].title,
            items: items
        )
        return mutableColumns
    }

    return columns
}

private struct ContentCard: Identifiable {
    let id: String
    let title: String
    let detail: String
}

private let contentCards: [ContentCard] = [
    .init(id: "foundations", title: "Foundations", detail: "Theme, type, spacing, and materials."),
    .init(id: "components", title: "Components", detail: "Reusable primitives exported by the library."),
    .init(id: "recipes", title: "Recipes", detail: "Scenario-driven compositions built from the public API.")
]
