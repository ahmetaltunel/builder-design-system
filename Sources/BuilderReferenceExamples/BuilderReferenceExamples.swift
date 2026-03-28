import SwiftUI
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
                supportedStates: ["Prompting", "Generated", "Review"],
                accessibilityNotes: [
                    "Generated output should be clearly differentiated from authored input.",
                    "Follow-up actions should remain explicit instead of implied."
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
                supportedStates: ["Start", "In progress", "Complete"],
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
        componentExample(id: id, displayName: displayName, family: family).makePreview(environment, options)
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

                    ItemsPalette(
                        environment: environment,
                        items: [
                            .init(title: "Metric card", detail: "Reusable dashboard tile.", status: "Ready", statusColor: environment.theme.color(.success), symbol: "chart.bar"),
                            .init(title: "Status list", detail: "Dense collection summary.", status: "Review", statusColor: environment.theme.color(.warning), symbol: "list.bullet.rectangle")
                        ]
                    )
                }
            } else {
                CodeView(environment: environment, code: "let system = BuilderDesignSystem()")
            }
        }
    }
}

private struct DataReferenceExample: View {
    let environment: DesignSystemEnvironment
    @State private var selectedMetric: MetricSelection? = coverageSelection(label: "Tokens")
    @State private var visibleSeriesIDs: Set<String> = ["Coverage", "Adoption"]
    @State private var page = 1

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

    private var selectedRowID: Binding<String?> {
        Binding(
            get: { selectedMetric?.datumID },
            set: { nextValue in
                guard let nextValue else {
                    selectedMetric = nil
                    return
                }
                selectedMetric = coverageSelection(label: nextValue)
            }
        )
    }

    private var selectedPairs: [KeyValuePairs.Pair] {
        guard let selectedMetric else {
            return [
                .init(key: "Selection", value: "Choose a visible metric"),
                .init(key: "Behavior", value: "Hover to preview or click to pin")
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
            MixedChartPanel(
                environment: environment,
                title: "Coverage and adoption",
                subtitle: "Selection stays synchronized across the chart, detail pane, and table.",
                state: .ready,
                barSeries: [coverageSeries],
                lineSeries: [adoptionSeries],
                selection: $selectedMetric,
                visibleSeriesIDs: $visibleSeriesIDs,
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
                    state: .empty(.init(title: "No status mix", message: "Broaden the current filter to restore the distribution.", symbol: "chart.pie")),
                    slices: [],
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
                rows: [
                    .init(id: "Tokens", cells: ["Tokens", "Ready", "Now"]),
                    .init(id: "Components", cells: ["Components", "Review", "2h ago"]),
                    .init(id: "Patterns", cells: ["Patterns", "Ready", "1d ago"])
                ],
                selectedRowID: selectedRowID
            )

            PaginationControl(environment: environment, page: $page, pageCount: 5)
        }
    }
}

private struct AIReferenceExample: View {
    let environment: DesignSystemEnvironment
    @State private var prompt = "Summarize the component contract."

    var body: some View {
        PanelSurface(environment: environment, title: "Generative workflow", subtitle: "Keep prompt, output, and review actions explicit.") {
            HStack(spacing: 10) {
                AvatarView(environment: environment, title: "Builder assistant", symbol: "sparkles")
                TokenBadge(environment: environment, title: "Review required", tint: nil)
            }

            PromptInput(environment: environment, prompt: $prompt, actionTitle: "Draft") {}

            SupportPromptGroup(
                environment: environment,
                title: "Suggested prompts",
                prompts: [
                    .init(title: "Summarize", detail: "Condense the latest changes."),
                    .init(title: "Find gaps", detail: "Inspect missing inventory."),
                    .init(title: "Explain tradeoffs", detail: "Compare candidate APIs.")
                ]
            ) { selected in
                prompt = selected.title
            }

            ChatBubble(environment: environment, role: .user, author: "Builder", message: prompt)
            ChatBubble(
                environment: environment,
                role: .assistant,
                author: "Builder assistant",
                message: "BuilderDesignSystem now ships compiled reference examples, generated docs, and reusable search, chart, and status primitives.",
                detail: "Draft output"
            )
        }
    }
}

private struct TutorialReferenceExample: View {
    let environment: DesignSystemEnvironment

    var body: some View {
        WizardLayout(
            environment: environment,
            title: "Create a component family",
            steps: [
                .init(id: "audit", title: "Audit", detail: "Review the API and states."),
                .init(id: "build", title: "Build", detail: "Promote shared primitives."),
                .init(id: "verify", title: "Verify", detail: "Run tests and inspect the showcase.")
            ],
            currentStepID: "build"
        ) {
            TutorialPanel(
                environment: environment,
                title: "Rollout guidance",
                subtitle: "Keep progression visible without leaving the current workflow.",
                steps: [
                    .init(id: "audit", title: "Audit", detail: "Review API shape."),
                    .init(id: "build", title: "Build", detail: "Add reusable surfaces."),
                    .init(id: "verify", title: "Verify", detail: "Run validation.")
                ],
                currentStepID: "build"
            ) {
                Text("Tutorial flows should guide builders without leaving the shared shell language.")
                    .font(environment.theme.typography(.body).font)
                    .foregroundStyle(environment.theme.color(.textSecondary))
            }
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

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HelpPanel(environment: environment, title: "Help", subtitle: "Keep support adjacent to the active task.") {
                BulletList(environment: environment, items: [
                    "Explain the current decision clearly.",
                    "Link guidance to the active surface.",
                    "Avoid hiding recovery steps."
                ])
            } footer: {
                HStack(spacing: 10) {
                    SystemButton(environment: environment, title: "Open docs", tone: .primary) {}
                    SystemButton(environment: environment, title: "Dismiss", tone: .secondary) {}
                }
            }

            FileUploadField(
                environment: environment,
                title: "Attach release notes",
                subtitle: "Presentation belongs to the system; picking and upload logic stays with the consumer.",
                dropTitle: "Drop release notes",
                dropDetail: "Or browse from disk.",
                items: [
                    .init(title: "release-notes.md", detail: "18 KB", status: .success),
                    .init(title: "screenshots.zip", detail: "2 files", status: .warning)
                ],
                onPick: {}
            ) { _ in
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
    @State private var selectedMetric: MetricSelection? = coverageSelection(label: "Navigation")
    @State private var visibleSeriesIDs: Set<String> = ["Coverage", "Adoption"]

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
            MixedChartPanel(
                environment: environment,
                title: "Usage coverage",
                subtitle: "Legend filtering and selection stay connected to the detail pane.",
                state: .ready,
                barSeries: [coverageSeries],
                lineSeries: [adoptionSeries],
                selection: $selectedMetric,
                visibleSeriesIDs: $visibleSeriesIDs,
                valueFormatter: percentMetricValue
            )

            HStack(alignment: .top, spacing: 16) {
                KeyValuePairs(
                    environment: environment,
                    pairs: [
                        .init(key: "Series", value: selectedMetric?.seriesTitle ?? "Coverage"),
                        .init(key: "Metric", value: selectedMetric?.label ?? "Navigation"),
                        .init(key: "Value", value: selectedMetric?.formattedValue ?? "76%")
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
                rows: [
                    .init(id: "Navigation", cells: ["Navigation shell", "Ready", "Now"]),
                    .init(id: "Forms", cells: ["Settings form", "Review", "3h ago"]),
                    .init(id: "Feedback", cells: ["Feedback summary", "Planned", "Tomorrow"])
                ],
                selectedRowID: Binding(
                    get: { selectedMetric?.datumID },
                    set: { selectedMetric = coverageSelection(label: $0 ?? "Navigation") }
                )
            )
        }
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

    var body: some View {
        FileUploadField(
            environment: environment,
            title: "Drop files",
            subtitle: "Provide a visible target and a keyboard alternative.",
            dropTitle: "Drop release notes here",
            dropDetail: "Or use Browse to upload from disk.",
            onPick: {}
        )
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

    var body: some View {
        HelpPanel(environment: environment, title: "Guidance", subtitle: "Keep help adjacent to work instead of interrupting the current task.") {
            VStack(alignment: .leading, spacing: 12) {
                Text("Link support guidance to the active decision and preserve the user’s place in the workflow.")
                    .font(environment.theme.typography(.body).font)
                    .foregroundStyle(environment.theme.color(.textSecondary))
                ValidationMessage(environment: environment, status: .normal, message: "Use the same calm shell language as the main workspace.")
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

    var body: some View {
        WizardLayout(
            environment: environment,
            title: "Bring a team into the system",
            steps: [
                .init(title: "Choose"),
                .init(title: "Tune"),
                .init(title: "Validate")
            ],
            currentStepID: "Tune"
        ) {
            TutorialPanel(
                environment: environment,
                title: "Team onboarding",
                subtitle: "Keep progress visible and the next action obvious.",
                steps: [
                    .init(id: "Choose", title: "Choose"),
                    .init(id: "Tune", title: "Tune"),
                    .init(id: "Validate", title: "Validate")
                ],
                currentStepID: "Tune"
            ) {
                Text("Guide teams into the system without changing the shell language.")
                    .font(environment.theme.typography(.body).font)
                    .foregroundStyle(environment.theme.color(.textSecondary))
            }
        }
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
