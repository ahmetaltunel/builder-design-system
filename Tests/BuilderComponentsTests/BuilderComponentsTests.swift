import SwiftUI
import XCTest
import BuilderFoundation
@testable import BuilderComponents

@MainActor
final class BuilderComponentsTests: XCTestCase {
    private struct DemoCard: Identifiable {
        let id: String
        let title: String
    }

    private struct ChartPoint: Identifiable {
        let id: String
        let label: String
        let value: Double
        let color: Color
    }

    private let environment = DesignSystemEnvironment(
        theme: AppTheme(mode: .dark, contrast: .standard),
        mode: .dark,
        contrast: .standard,
        density: .default,
        visualContext: .shell,
        reduceMotion: false,
        highContrast: false
    )

    func testSurfaceAndNavigationPrimitivesInstantiate() {
        let panel = PanelSurface(environment: environment, title: "Panel", subtitle: "Subtitle") {
            Text("Body")
        }
        let row = SidebarRow(environment: environment, title: "Overview", symbol: "sparkles", isSelected: true)
        let backdrop = SidebarBackdrop(environment: environment)
        let navItems = [
            NavigationItem(id: "home", title: "Home", symbol: "house"),
            NavigationItem(id: "components", title: "Components", subtitle: "Browse the component surface", symbol: "square.grid.3x3")
        ]
        let browser = NavigationBrowserList(
            environment: environment,
            items: navItems,
            selection: .constant("home")
        ) { item, isSelected in
            Text(item.title + (isSelected ? " selected" : ""))
        }
        let sidebar = NavigationSidebarList(
            environment: environment,
            sections: [.init(id: "workspace", title: "Workspace", items: navItems)],
            selection: .constant("home")
        ) { item, isSelected in
            Text(item.title + (isSelected ? " selected" : ""))
        }

        XCTAssertEqual(panel.title, "Panel")
        XCTAssertEqual(row.title, "Overview")
        XCTAssertNotNil(backdrop)
        XCTAssertEqual(browser.items.count, 2)
        XCTAssertEqual(sidebar.sections.count, 1)
        XCTAssertEqual(sidebar.sections[0].items.count, 2)
    }

    func testControlsAndFormPrimitivesInstantiate() {
        let button = SystemButton(environment: environment, title: "Primary") {}
        let toolbarButton = ToolbarButton(environment: environment, title: "Refresh", symbol: "arrow.clockwise") {}
        let tokenBadge = TokenBadge(environment: environment, title: "Accent", tint: .blue)
        let statusBadge = StatusBadge(environment: environment, label: "Ready", color: .green)
        let segmented = SegmentedPicker(
            environment: environment,
            options: [("One", 1), ("Two", 2)],
            selection: .constant(1)
        )
        let field = TextInputField(environment: environment, placeholder: "Search", text: .constant("hello"))
        let readOnlyField = ReadOnlyField(environment: environment, value: "Current value")
        let readOnlyTextArea = ReadOnlyTextArea(environment: environment, value: "Notes", hint: "Read only")

        XCTAssertEqual(button.title, "Primary")
        XCTAssertEqual(toolbarButton.title, "Refresh")
        XCTAssertEqual(tokenBadge.title, "Accent")
        XCTAssertEqual(statusBadge.label, "Ready")
        XCTAssertEqual(segmented.options.count, 2)
        XCTAssertEqual(field.placeholder, "Search")
        XCTAssertEqual(readOnlyField.value, "Current value")
        XCTAssertEqual(readOnlyTextArea.hint, "Read only")
    }

    func testCoreControlsExposeRicherStateContracts() {
        let loadingButton = SystemButton(
            environment: environment,
            title: "Save",
            tone: .primary,
            size: .large,
            isEnabled: false,
            isLoading: true
        ) {}
        let field = TextInputField(
            environment: environment,
            placeholder: "Search",
            text: .constant("builder"),
            status: .error,
            message: "Resolve the field before continuing.",
            isReadOnly: true,
            isEnabled: false
        )
        let textArea = TextAreaField(
            environment: environment,
            placeholder: "Notes",
            text: .constant("Read-only draft"),
            status: .warning,
            message: "This content is currently locked.",
            isReadOnly: true,
            isEnabled: false
        )
        let checkbox = Checkbox(environment: environment, title: "Apply to all", isOn: .constant(false), isMixed: true, isEnabled: false)
        let radio = RadioGroup(
            environment: environment,
            options: [
                .init(label: "Primary", value: 1),
                .init(label: "Fallback", value: 2, isEnabled: false)
            ],
            selection: .constant(1)
        )
        let toggle = ToggleSwitch(environment: environment, title: "Background sync", isOn: .constant(true), isEnabled: false, isLoading: true)
        let select = SelectMenu(
            environment: environment,
            options: [.init(label: "Auto", value: "auto")],
            selection: .constant("auto"),
            placeholder: "Choose mode",
            isEnabled: false
        )
        let multi = MultiselectMenu(
            environment: environment,
            options: [.init(label: "Shell", value: "shell")],
            selection: .constant(["shell"]),
            placeholder: "Pick areas",
            isEnabled: false
        )
        let alert = AlertBanner(
            environment: environment,
            title: "Needs review",
            message: "Dismiss and action affordances should coexist.",
            tone: .warning,
            actionTitle: "Inspect",
            action: {},
            isDismissible: true,
            onDismiss: {}
        )

        XCTAssertEqual(loadingButton.size, .large)
        XCTAssertFalse(loadingButton.isEnabled)
        XCTAssertTrue(loadingButton.isLoading)
        XCTAssertEqual(field.status, .error)
        XCTAssertEqual(field.message, "Resolve the field before continuing.")
        XCTAssertTrue(field.isReadOnly)
        XCTAssertFalse(field.isEnabled)
        XCTAssertEqual(textArea.status, .warning)
        XCTAssertTrue(textArea.isReadOnly)
        XCTAssertFalse(textArea.isEnabled)
        XCTAssertTrue(checkbox.isMixed)
        XCTAssertFalse(checkbox.isEnabled)
        XCTAssertFalse(radio.options[1].isEnabled)
        XCTAssertTrue(toggle.isLoading)
        XCTAssertFalse(toggle.isEnabled)
        XCTAssertEqual(select.placeholder, "Choose mode")
        XCTAssertFalse(select.isEnabled)
        XCTAssertEqual(multi.placeholder, "Pick areas")
        XCTAssertFalse(multi.isEnabled)
        XCTAssertTrue(alert.isDismissible)
        XCTAssertEqual(alert.actionTitle, "Inspect")
    }

    func testSearchValidationAndEmptyStatePrimitivesInstantiate() {
        let overlay = SearchResultsOverlay(
            environment: environment,
            sections: [
                .init(
                    title: "Components",
                    items: [
                        .init(id: "button", title: "Button", subtitle: "SystemButton", symbol: "square.grid.2x2")
                    ]
                )
            ]
        ) { _ in }
        let commandPalette = CommandPalette(
            environment: environment,
            query: .constant("button"),
            sections: [
                .init(title: "Components", items: [.init(id: "button", title: "Button", subtitle: "SystemButton", symbol: "square.grid.2x2")])
            ]
        ) { _ in }
        let validationMessage = ValidationMessage(environment: environment, status: .warning, message: "Check spacing before shipping.")
        let validationSummary = ValidationSummary(
            environment: environment,
            items: [.init(id: "contrast", title: "Contrast", detail: "Dark and light states should stay aligned.", status: .success)]
        )
        let emptyState = EmptyStateView(environment: environment, title: "No matches", message: "Clear the current query.")
        let filterState = BrowserFilterState<String>(query: "button", selectedScope: "Input & Selection")

        XCTAssertEqual(overlay.sections.count, 1)
        XCTAssertEqual(commandPalette.sections.count, 1)
        XCTAssertEqual(validationMessage.message, "Check spacing before shipping.")
        XCTAssertEqual(validationSummary.items.count, 1)
        XCTAssertEqual(emptyState.title, "No matches")
        XCTAssertTrue(filterState.hasQuery)
        XCTAssertEqual(filterState.selectedScope, "Input & Selection")
    }

    func testSettingsAndContentPrimitivesInstantiate() {
        let group = SettingsGroup(environment: environment) {
            Text("Row")
        }
        let row = SettingsRow(environment: environment, title: "Theme", detail: "Controls the active mode") {
            Text("Control")
        }
        let list = BulletList(environment: environment, items: ["One", "Two"])

        XCTAssertNotNil(group)
        XCTAssertEqual(row.title, "Theme")
        XCTAssertEqual(list.items.count, 2)
    }

    func testExpandedSelectionAndFormComponentsInstantiate() {
        let checkbox = Checkbox(environment: environment, title: "Enable", isOn: .constant(true))
        let radio = RadioGroup(
            environment: environment,
            options: [
                .init(label: "One", value: 1),
                .init(label: "Two", value: 2)
            ],
            selection: .constant(1)
        )
        let toggle = ToggleSwitch(environment: environment, title: "Active", isOn: .constant(false))
        let select = SelectMenu(
            environment: environment,
            options: [
                .init(label: "A", value: "a"),
                .init(label: "B", value: "b")
            ],
            selection: .constant("a")
        )
        let multi = MultiselectMenu(
            environment: environment,
            options: [
                .init(label: "A", value: "a"),
                .init(label: "B", value: "b")
            ],
            selection: .constant(["a"])
        )
        let toggleButton = ToggleButton(environment: environment, title: "Pinned", isOn: .constant(true))
        let buttonGroup = ButtonGroup(
            environment: environment,
            options: [
                .init(label: "Grid", value: "grid"),
                .init(label: "List", value: "list")
            ],
            selection: .constant("grid")
        )
        let slider = SliderField(environment: environment, title: "Contrast", value: .constant(42), in: 0...100)
        let textArea = TextAreaField(environment: environment, placeholder: "Notes", text: .constant("Hello"))
        let formField = FormField(environment: environment, label: "Project") {
            Text("Control")
        }
        let filter = TextFilterField(environment: environment, text: .constant("abc"))
        let autosuggest = AutosuggestField(
            environment: environment,
            placeholder: "Search",
            suggestions: ["Alpha", "Beta"],
            text: .constant("a")
        )
        let dateField = DateField(environment: environment, value: .constant(Date()))
        let timeField = TimeField(environment: environment, value: .constant(Date()))
        let rangeField = DateRangeField(environment: environment, startDate: .constant(Date()), endDate: .constant(Date()))
        let tagEditor = TagEditor(environment: environment, tags: .constant(["UI", "Theme"]))
        let tilePicker = TilePicker(
            environment: environment,
            options: [
                .init(label: "One", value: 1),
                .init(label: "Two", value: 2)
            ],
            selection: .constant(1)
        )

        XCTAssertEqual(checkbox.title, "Enable")
        XCTAssertEqual(radio.options.count, 2)
        XCTAssertEqual(toggle.title, "Active")
        XCTAssertEqual(select.options.count, 2)
        XCTAssertEqual(multi.options.count, 2)
        XCTAssertEqual(toggleButton.title, "Pinned")
        XCTAssertEqual(buttonGroup.options.count, 2)
        XCTAssertEqual(slider.title, "Contrast")
        XCTAssertEqual(textArea.placeholder, "Notes")
        XCTAssertEqual(formField.label, "Project")
        XCTAssertEqual(filter.placeholder, "Filter")
        XCTAssertEqual(autosuggest.suggestions.count, 2)
        XCTAssertNotNil(dateField)
        XCTAssertNotNil(timeField)
        XCTAssertNotNil(rangeField)
        XCTAssertNotNil(tagEditor)
        XCTAssertEqual(tilePicker.options.count, 2)
    }

    func testExpandedNavigationSurfaceAndContentComponentsInstantiate() {
        let breadcrumbs = BreadcrumbGroup(environment: environment, items: [
            .init(title: "Home"),
            .init(title: "Components", isCurrent: true)
        ])
        let topNav = TopNavigationBar(environment: environment) {
            Text("Leading")
        } trailing: {
            Text("Trailing")
        }
        let anchors = AnchorNavigation(
            environment: environment,
            items: [.init(title: "General"), .init(title: "Appearance")],
            selection: .constant("General")
        )
        let tree = TreeView(
            environment: environment,
            nodes: [
                .init(title: "System", children: [.init(title: "Colors"), .init(title: "Type")])
            ],
            selection: .constant("System")
        )
        let tabs = Tabs(environment: environment, items: [
            .init(title: "One", value: "one"),
            .init(title: "Two", value: "two")
        ], selection: .constant("one"))
        let pagination = PaginationControl(environment: environment, page: .constant(2), pageCount: 5)
        let appLayout = AppLayout(environment: environment) {
            Text("Sidebar")
        } content: {
            Text("Content")
        }
        let contentLayout = ContentLayout(environment: environment) {
            Text("Header")
        } content: {
            Text("Content")
        }
        let columns = ColumnLayout(environment: environment) {
            Text("Primary")
        } secondary: {
            Text("Secondary")
        }
        let split = SplitPanel(environment: environment) {
            Text("Primary")
        } secondary: {
            Text("Secondary")
        }
        let container = ContainerBox(environment: environment) {
            Text("Body")
        }
        let cards = CardGrid(environment: environment, data: [DemoCard(id: "a", title: "A"), DemoCard(id: "b", title: "B")]) { card in
            Text(card.title)
        }
        let header = HeaderBlock(environment: environment, title: "Overview") {
            Text("Actions")
        }
        let pairs = KeyValuePairs(environment: environment, pairs: [.init(key: "Theme", value: "Dark")])
        let expandable = ExpandableSection(environment: environment, title: "Advanced", isExpanded: .constant(true)) {
            Text("Content")
        }
        let codeView = CodeView(environment: environment, code: "let x = 1")
        let codeEditor = CodeEditorSurface(environment: environment, code: .constant("let y = 2"))
        let steps = StepsView(environment: environment, steps: [.init(title: "Setup"), .init(title: "Verify")], currentStepID: "Setup")
        let wizard = WizardLayout(environment: environment, title: "Create flow", steps: [.init(title: "Setup"), .init(title: "Verify")], currentStepID: "Setup") {
            Text("Body")
        }

        XCTAssertEqual(breadcrumbs.items.count, 2)
        XCTAssertNotNil(topNav)
        XCTAssertEqual(anchors.items.count, 2)
        XCTAssertEqual(tree.nodes.count, 1)
        XCTAssertEqual(tabs.items.count, 2)
        XCTAssertEqual(pagination.pageCount, 5)
        XCTAssertEqual(appLayout.sidebarWidth, 280)
        XCTAssertEqual(contentLayout.maxWidth, 980)
        XCTAssertEqual(columns.secondaryWidth, 280)
        XCTAssertEqual(split.secondaryWidth, 320)
        XCTAssertFalse(container.inset)
        XCTAssertEqual(cards.columns, 3)
        XCTAssertEqual(header.title, "Overview")
        XCTAssertEqual(pairs.pairs.count, 1)
        XCTAssertEqual(expandable.title, "Advanced")
        XCTAssertEqual(codeView.code, "let x = 1")
        XCTAssertEqual(codeEditor.minHeight, 180)
        XCTAssertEqual(steps.steps.count, 2)
        XCTAssertEqual(wizard.title, "Create flow")
    }

    func testExpandedFeedbackAndOverlayComponentsInstantiate() {
        let status = StatusIndicator(environment: environment, label: "Ready", tone: .success)
        let alert = AlertBanner(environment: environment, title: "Saved", message: "Changes were saved.", tone: .success)
        let notices = NoticeStack(environment: environment, notices: [
            .init(title: "Ready", message: "All checks passed.", tone: .success)
        ])
        let progress = ProgressBar(environment: environment, value: 0.6)
        let loadingBar = LoadingBar(environment: environment, label: "Refreshing metrics", detail: "Duration is not yet known.")
        let spinner = LoadingSpinner(environment: environment, label: "Loading")
        let modal = ModalSurface(environment: environment, title: "Modal") {
            Text("Body")
        }
        let drawer = DrawerSurface(environment: environment, title: "Drawer") {
            Text("Body")
        }
        let popover = PopoverSurface(environment: environment, title: "Popover") {
            Text("Body")
        }
        let live = LiveRegionMessage(environment: environment, message: "Status updated")
        let error = ErrorStateView(environment: environment, title: "Failed", message: "Try again")
        let table = DataTable(
            environment: environment,
            columns: [
                .init(title: "Name"),
                .init(title: "ID")
            ],
            rows: [.init(id: "1", cells: ["Overview", "1"])],
            selectedRowID: .constant(nil)
        )

        XCTAssertEqual(status.label, "Ready")
        XCTAssertEqual(alert.title, "Saved")
        XCTAssertEqual(notices.notices.count, 1)
        XCTAssertEqual(progress.value, 0.6)
        XCTAssertEqual(loadingBar.label, "Refreshing metrics")
        XCTAssertEqual(spinner.label, "Loading")
        XCTAssertEqual(modal.title, "Modal")
        XCTAssertEqual(drawer.title, "Drawer")
        XCTAssertEqual(popover.title, "Popover")
        XCTAssertEqual(live.message, "Status updated")
        XCTAssertEqual(error.title, "Failed")
        XCTAssertEqual(table.rows.count, 1)
    }

    func testExactNameSurfaceAndUtilityComponentsInstantiate() {
        let toolbar = AppLayoutToolbar(environment: environment) {
            Text("Toolbar")
        }
        let panelLayout = PanelLayout(environment: environment) {
            Text("Panel")
        }
        let contextPanel = ContextPanel(environment: environment, title: "Inspector") {
            Text("Body")
        }
        let board = Board(environment: environment, columns: [
            .init(title: "Backlog", cards: ["Alert", "Button"]),
            .init(title: "In progress", cards: ["Table"])
        ])
        let grid = GridLayout(environment: environment, columns: 2) {
            Text("A")
            Text("B")
        }
        let list = ListSurface(environment: environment, items: ["Overview", "Patterns"])
        let textContent = TextContentBlock(environment: environment, title: "Summary", bodyText: "Quiet text layout.")
        let chart = ChartPanel(environment: environment, title: "Coverage", points: [
            .init(label: "Components", value: 80, color: .blue)
        ])
        let calendar = CalendarPanel(environment: environment, date: .constant(Date()))
        let spaceBetween = SpaceBetween(environment: environment) {
            Text("One")
            Text("Two")
        }
        let box = Box(environment: environment) {
            Text("Body")
        }
        let copy = CopyToClipboardButton(environment: environment, value: "hello")
        let tokenGroup = TokenGroup(environment: environment, titles: ["accent.primary", "surface.grouped"])
        let attributeEditor = AttributeEditor(
            environment: environment,
            attributes: .constant([.init(key: "Accent", value: "#339CFF")])
        )
        let preferences = ViewPreferencesPanel(environment: environment, denseMode: .constant(false), showsMetadata: .constant(true))
        let propertyFilter = PropertyFilterBar(environment: environment, query: .constant("shell"), activeTokens: ["shell", "grouped"])
        let resourceSelector = ResourceSelector(environment: environment, resources: ["Design system", "Showcase"], selection: .constant("Design system"))
        let fileDropZone = FileDropZone(environment: environment)

        XCTAssertNotNil(toolbar)
        XCTAssertNotNil(panelLayout)
        XCTAssertEqual(contextPanel.title, "Inspector")
        XCTAssertEqual(board.columns.count, 2)
        XCTAssertEqual(grid.columns, 2)
        XCTAssertEqual(list.items.count, 2)
        XCTAssertEqual(textContent.bodyText, "Quiet text layout.")
        XCTAssertEqual(chart.title, "Coverage")
        XCTAssertNotNil(calendar)
        XCTAssertNotNil(spaceBetween)
        XCTAssertNotNil(box)
        XCTAssertEqual(copy.value, "hello")
        XCTAssertEqual(tokenGroup.titles.count, 2)
        XCTAssertEqual(attributeEditor.attributes.count, 1)
        XCTAssertNotNil(preferences)
        XCTAssertEqual(propertyFilter.activeTokens.count, 2)
        XCTAssertEqual(resourceSelector.resources.count, 2)
        XCTAssertEqual(fileDropZone.title, "Drop files")
    }

    func testAdvancedMetricsWorkflowAndAIComponentsInstantiate() {
        let selectedMetric = MetricSelection(
            kind: .point,
            seriesID: "Coverage",
            seriesTitle: "Coverage",
            datumID: "Tokens",
            label: "Tokens",
            value: 82,
            formattedValue: "82%"
        )
        let barChart = BarChartPanel(
            environment: environment,
            title: "Coverage",
            state: .ready,
            series: [
                .init(title: "Coverage", color: .blue, points: [
                    .init(label: "Tokens", value: 82),
                    .init(label: "Components", value: 80)
                ])
            ],
            selection: .constant(Optional(selectedMetric)),
            visibleSeriesIDs: .constant(["Coverage"]),
            valueFormatter: { value in "\(Int(value))%" }
        )
        let lineChart = LineChartPanel(
            environment: environment,
            title: "Trend",
            state: .loading(.init(label: "Refreshing trend", detail: "Loading uses the shared async contract.")),
            series: [
                .init(title: "Adoption", color: .green, points: [
                    .init(label: "Mon", value: 12),
                    .init(label: "Tue", value: 18)
                ])
            ],
            selection: .constant(nil),
            visibleSeriesIDs: .constant(["Adoption"])
        )
        let areaChart = AreaChartPanel(
            environment: environment,
            title: "Area",
            state: .empty(.init(title: "No trend", message: "The filter removed every series.")),
            series: [
                .init(title: "Coverage", color: .purple, points: [
                    .init(label: "Mon", value: 42),
                    .init(label: "Tue", value: 48)
                ])
            ]
        )
        let donutChart = DonutChartPanel(
            environment: environment,
            title: "Status mix",
            state: .error(.init(title: "Unable to load status mix", message: "Retry after the dataset refresh completes.")),
            slices: [
                .init(title: "Ready", value: 18, color: .green),
                .init(title: "Review", value: 7, color: .orange)
            ],
            selection: .constant(nil),
            visibleSeriesIDs: .constant(["Ready", "Review"])
        )
        let mixedChart = MixedChartPanel(
            environment: environment,
            title: "Mixed",
            state: .ready,
            barSeries: [
                .init(title: "Coverage", color: .blue, points: [
                    .init(label: "Tokens", value: 82)
                ])
            ],
            lineSeries: [
                .init(title: "Target", color: .teal, points: [
                    .init(label: "Tokens", value: 90)
                ])
            ],
            selection: .constant(Optional(selectedMetric)),
            visibleSeriesIDs: .constant(["Coverage", "Target"]),
            valueFormatter: { value in "\(Int(value))%" }
        )
        let helpPanel = HelpPanel(
            environment: environment,
            title: "Help",
            state: .loading(.init(label: "Refreshing guidance", detail: "Support surfaces share the same async contract."))
        ) {
            Text("Guidance")
        }
        let filePicker = FilePickerButton(environment: environment, title: "Browse files") {}
        let fileTokens = FileTokenGroup(environment: environment, items: [
            .init(title: "release-notes.md", detail: "18 KB", status: .success)
        ])
        let fileUpload = FileUploadField(
            environment: environment,
            title: "Attach release notes",
            items: [.init(title: "release-notes.md", detail: "18 KB", status: .success)],
            state: .empty(.init(title: "No files selected", message: "Pick a file to continue.")),
            onPick: {}
        )
        let board = Board(environment: environment, columns: [
            .init(title: "Backlog", items: [
                .init(title: "Alert", detail: "Feedback work", status: "Review", statusColor: .orange),
                .init(title: "Charts", detail: "Metrics work", status: "Ready", statusColor: .green)
            ])
        ])
        let boardItem = BoardItemView(environment: environment, item: .init(title: "Alert", detail: "Feedback work"))
        let itemsPalette = ItemsPalette(environment: environment, items: [.init(title: "Metric card", detail: "Reusable dashboard tile.")])
        let avatar = AvatarView(environment: environment, title: "Builder assistant", symbol: "sparkles")
        let promptInput = PromptInput(environment: environment, prompt: .constant("Summarize")) {}
        let supportPrompts = SupportPromptGroup(environment: environment, prompts: [.init(title: "Summarize")]) { _ in }
        let chatBubble = ChatBubble(environment: environment, role: .assistant, author: "Builder assistant", message: "Review is ready.")
        let tutorialPanel = TutorialPanel(
            environment: environment,
            title: "Rollout guidance",
            state: .error(.init(title: "Unable to load steps", message: "Retry after restoring the checklist source.")),
            steps: [.init(id: "audit", title: "Audit"), .init(id: "verify", title: "Verify")],
            currentStepID: "audit"
        ) {
            Text("Step content")
        }

        XCTAssertEqual(barChart.title, "Coverage")
        XCTAssertEqual(barChart.state, .ready)
        XCTAssertEqual(barChart.selection?.wrappedValue, selectedMetric)
        XCTAssertEqual(lineChart.series.count, 1)
        XCTAssertEqual(lineChart.state, .loading(.init(label: "Refreshing trend", detail: "Loading uses the shared async contract.")))
        XCTAssertEqual(areaChart.series.count, 1)
        XCTAssertEqual(areaChart.state, .empty(.init(title: "No trend", message: "The filter removed every series.")))
        XCTAssertEqual(donutChart.slices.count, 2)
        XCTAssertEqual(donutChart.state, .error(.init(title: "Unable to load status mix", message: "Retry after the dataset refresh completes.")))
        XCTAssertEqual(mixedChart.lineSeries.count, 1)
        XCTAssertEqual(mixedChart.visibleSeriesIDs?.wrappedValue, Set(["Coverage", "Target"]))
        XCTAssertEqual(helpPanel.title, "Help")
        XCTAssertEqual(helpPanel.state, .loading(.init(label: "Refreshing guidance", detail: "Support surfaces share the same async contract.")))
        XCTAssertEqual(filePicker.title, "Browse files")
        XCTAssertEqual(fileTokens.items.count, 1)
        XCTAssertEqual(fileUpload.items.count, 1)
        XCTAssertEqual(fileUpload.state, .empty(.init(title: "No files selected", message: "Pick a file to continue.")))
        XCTAssertEqual(board.columns.count, 1)
        XCTAssertEqual(boardItem.item.title, "Alert")
        XCTAssertEqual(itemsPalette.items.count, 1)
        XCTAssertEqual(avatar.title, "Builder assistant")
        XCTAssertEqual(promptInput.placeholder, "Prompt")
        XCTAssertEqual(supportPrompts.prompts.count, 1)
        XCTAssertEqual(chatBubble.author, "Builder assistant")
        XCTAssertEqual(tutorialPanel.title, "Rollout guidance")
        XCTAssertEqual(tutorialPanel.state, .error(.init(title: "Unable to load steps", message: "Retry after restoring the checklist source.")))
    }

    func testAsyncContentStateAndMetricSelectionModels() {
        let loadingState = AsyncContentState.loading(.init(label: "Refreshing metrics", detail: "Layout should remain stable."))
        let emptyState = AsyncContentState.empty(.init(title: "No visible series", message: "Choose a legend item to restore the chart."))
        let errorState = AsyncContentState.error(.init(title: "Unable to load metrics", message: "Retry after the dataset refresh completes."))
        let selection = MetricSelection(
            kind: .point,
            seriesID: "Coverage",
            seriesTitle: "Coverage",
            datumID: "Tokens",
            label: "Tokens",
            value: 82,
            formattedValue: "82%"
        )

        XCTAssertEqual(loadingState, .loading(.init(label: "Refreshing metrics", detail: "Layout should remain stable.")))
        XCTAssertEqual(emptyState, .empty(.init(title: "No visible series", message: "Choose a legend item to restore the chart.")))
        XCTAssertEqual(errorState, .error(.init(title: "Unable to load metrics", message: "Retry after the dataset refresh completes.")))
        XCTAssertFalse(loadingState.isReady)
        XCTAssertEqual(selection.id, "Coverage::Tokens")
        XCTAssertEqual(selection.seriesTitle, "Coverage")
        XCTAssertEqual(selection.formattedValue, "82%")
    }

    func testNativeNavigationViewsDisableDefaultFocusRingAndTranslateReturn() throws {
        let table = NavigationTableView()
        let outline = NavigationOutlineView()
        var tableActivated = false
        var outlineActivated = false

        table.activationHandler = { tableActivated = true }
        outline.activationHandler = { outlineActivated = true }

        let returnEvent = try XCTUnwrap(
            NSEvent.keyEvent(
                with: .keyDown,
                location: .zero,
                modifierFlags: [],
                timestamp: 0,
                windowNumber: 0,
                context: nil,
                characters: "\r",
                charactersIgnoringModifiers: "\r",
                isARepeat: false,
                keyCode: 36
            )
        )

        table.keyDown(with: returnEvent)
        outline.keyDown(with: returnEvent)

        XCTAssertEqual(table.focusRingType, .none)
        XCTAssertEqual(outline.focusRingType, .none)
        XCTAssertTrue(tableActivated)
        XCTAssertTrue(outlineActivated)
    }
}
