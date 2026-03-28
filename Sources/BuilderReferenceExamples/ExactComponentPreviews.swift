import Foundation
import SwiftUI
import UniformTypeIdentifiers
import BuilderDesignSystem

private typealias ExactComponentPreviewFactory = @MainActor (
    _ displayName: String,
    _ environment: DesignSystemEnvironment,
    _ options: ComponentPreviewOptions
) -> AnyView

extension BuilderReferenceExamples {
    package static func hasExactComponentPreview(id: ComponentExampleID) -> Bool {
        exactComponentPreviewFactory(for: id) != nil
    }

    @MainActor
    static func exactComponentPreview(
        id: ComponentExampleID,
        displayName: String,
        environment: DesignSystemEnvironment,
        options: ComponentPreviewOptions
    ) -> AnyView? {
        exactComponentPreviewFactory(for: id)?(displayName, environment, options)
    }

    private static func exactComponentPreviewFactory(for id: ComponentExampleID) -> ExactComponentPreviewFactory? {
        switch id.rawValue {
        case "alert":
            return { _, environment, options in
                AnyView(
                    previewColumn {
                        AlertBanner(
                            environment: environment,
                            title: options.showLoadingState ? "Refreshing guidance" : "Validation needs review",
                            message: options.showLoadingState
                            ? "Loading keeps the action affordance visible while the state refreshes."
                            : "Keep recovery text explicit and attach it to the next safe action.",
                            tone: options.showDisabledState ? .warning : .info,
                            actionTitle: "Inspect",
                            action: {},
                            isDismissible: true,
                            onDismiss: {}
                        )
                    }
                )
            }
        case "anchor-navigation":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        AnchorNavigation(
                            environment: environment,
                            items: [
                                .init(title: "Overview"),
                                .init(title: "Tokens"),
                                .init(title: "Accessibility")
                            ],
                            selection: .constant("Overview")
                        )
                    }
                )
            }
        case "area-chart":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        AreaChartPanel(
                            environment: environment,
                            title: "Coverage trend",
                            state: .ready,
                            series: [coverageMetricSeries(environment: environment)],
                            selection: .constant(nil),
                            visibleSeriesIDs: .constant(["Coverage"]),
                            valueFormatter: percentageFormatter
                        )
                    }
                )
            }
        case "app-layout":
            return { _, environment, _ in
                AnyView(
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
                )
            }
        case "app-layout-toolbar":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        AppLayoutToolbar(environment: environment) {
                            ToolbarButton(environment: environment, title: "Refresh", symbol: "arrow.clockwise") {}
                            ToolbarButton(environment: environment, title: "Inspect", symbol: "sidebar.right") {}
                            SegmentedPicker(
                                environment: environment,
                                options: [("Preview", "preview"), ("Inspect", "inspect")],
                                selection: .constant("preview"),
                                style: .neutral
                            )
                            .frame(width: 220)
                        }
                    }
                )
            }
        case "attribute-editor":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        AttributeEditor(
                            environment: environment,
                            attributes: .constant([
                                .init(key: "Accent", value: "#339CFF"),
                                .init(key: "Density", value: "Compact")
                            ])
                        )
                    }
                )
            }
        case "autosuggest":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        AutosuggestField(
                            environment: environment,
                            placeholder: "Search components",
                            suggestions: ["Button", "Tabs", "Table", "Token group"],
                            text: .constant("But")
                        )
                    }
                )
            }
        case "avatar":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        HStack(spacing: 12) {
                            AvatarView(environment: environment, title: "Builder assistant", symbol: "sparkles")
                            AvatarView(environment: environment, title: "Design system", tint: environment.theme.color(.chartTeal))
                        }
                    }
                )
            }
        case "badge":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        HStack(spacing: 10) {
                            StatusBadge(environment: environment, label: "Ready", color: environment.theme.color(.success))
                            StatusBadge(environment: environment, label: "Preview", color: environment.theme.color(.warning))
                        }
                    }
                )
            }
        case "bar-chart":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        BarChartPanel(
                            environment: environment,
                            title: "Coverage",
                            state: .ready,
                            series: [coverageMetricSeries(environment: environment)],
                            selection: .constant(nil),
                            visibleSeriesIDs: .constant(["Coverage"]),
                            valueFormatter: percentageFormatter
                        )
                    }
                )
            }
        case "board":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        Board(
                            environment: environment,
                            columns: previewBoardColumns(environment: environment),
                            selectedItemID: .constant("review-docs"),
                            onActivateItem: { _ in },
                            onMoveItem: { _, _, _ in }
                        )
                    }
                )
            }
        case "board-item":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        BoardItemView(
                            environment: environment,
                            item: .init(
                                id: "review-docs",
                                title: "Review docs",
                                detail: "Match examples to the public API.",
                                status: "Review",
                                statusColor: environment.theme.color(.warning)
                            ),
                            isSelected: true,
                            isFocused: false,
                            moveDestinations: [
                                .init(title: "Move to Ready", columnID: "ready", columnTitle: "Ready", index: 0)
                            ],
                            onMove: { _ in },
                            dragPayload: nil
                        )
                    }
                )
            }
        case "box":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        Box(environment: environment) {
                            Text("Use Box to group related utility content without inventing new chrome.")
                                .font(environment.theme.typography(.body).font)
                                .foregroundStyle(environment.theme.color(.textSecondary))
                        }
                    }
                )
            }
        case "breadcrumb-group":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        BreadcrumbGroup(
                            environment: environment,
                            items: [
                                .init(title: "Library"),
                                .init(title: "Components"),
                                .init(title: "Breadcrumb group", isCurrent: true)
                            ]
                        )
                    }
                )
            }
        case "button":
            return { _, environment, options in
                AnyView(
                    previewColumn {
                        HStack(spacing: 12) {
                            SystemButton(
                                environment: environment,
                                title: "Save changes",
                                tone: .primary,
                                isEnabled: !options.showDisabledState,
                                isLoading: options.showLoadingState
                            ) {}
                            SystemButton(
                                environment: environment,
                                title: "Cancel",
                                tone: .secondary,
                                isEnabled: !options.showDisabledState
                            ) {}
                        }
                    }
                )
            }
        case "button-dropdown":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        ButtonDropdown(
                            environment: environment,
                            title: "Create",
                            tone: .secondary,
                            items: [
                                .init(title: "Component", symbol: "square.grid.2x2", action: {}),
                                .init(title: "Pattern", symbol: "rectangle.3.group", action: {}),
                                .init(title: "Foundation note", symbol: "book", action: {})
                            ]
                        )
                    }
                )
            }
        case "button-group":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        ButtonGroup(
                            environment: environment,
                            options: [
                                .init(label: "Preview", value: "preview"),
                                .init(label: "Inspect", value: "inspect")
                            ],
                            selection: .constant("preview")
                        )
                    }
                )
            }
        case "calendar":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        CalendarPanel(environment: environment, date: .constant(sampleDate))
                    }
                )
            }
        case "cards":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        CardGrid(environment: environment, data: previewCards, columns: 3) { card in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(card.title)
                                    .font(environment.theme.typography(.bodyStrong).font)
                                    .foregroundStyle(environment.theme.color(.textPrimary))
                                Text(card.subtitle)
                                    .font(environment.theme.typography(.caption).font)
                                    .foregroundStyle(environment.theme.color(.textSecondary))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                )
            }
        case "chat-bubble":
            return { _, environment, options in
                AnyView(
                    previewColumn {
                        ChatBubble(environment: environment, role: .user, author: "Builder", message: "Summarize the rollout risks.")
                        ChatBubble(
                            environment: environment,
                            role: .assistant,
                            author: "Builder assistant",
                            message: "The component browser now resolves exact previews before falling back to family examples.",
                            detail: options.showLoadingState ? "Draft output is still streaming." : nil,
                            state: options.showLoadingState ? .streaming : .complete,
                            footerMetadata: [
                                .init(label: "Model", value: "Builder review"),
                                .init(label: "Updated", value: "Now")
                            ],
                            showsCopyAction: true
                        )
                    }
                )
            }
        case "charts":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        ChartPanel(
                            environment: environment,
                            title: "Coverage",
                            points: [
                                .init(label: "Components", value: 80, color: environment.theme.color(.chartBlue)),
                                .init(label: "Patterns", value: 24, color: environment.theme.color(.chartTeal)),
                                .init(label: "Examples", value: 92, color: environment.theme.color(.chartGreen))
                            ]
                        )
                    }
                )
            }
        case "checkbox":
            return { _, environment, options in
                AnyView(
                    previewColumn {
                        Checkbox(
                            environment: environment,
                            title: "Enable grouped settings",
                            detail: options.showReadOnlyState ? "Mixed state previews a partially applied setting." : nil,
                            isOn: .constant(true),
                            isMixed: options.showReadOnlyState,
                            isEnabled: !options.showDisabledState
                        )
                    }
                )
            }
        case "code-editor":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        CodeEditorSurface(environment: environment, code: .constant(sampleCode))
                    }
                )
            }
        case "code-view":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        CodeView(environment: environment, code: sampleCode)
                    }
                )
            }
        case "column-layout":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        ColumnLayout(environment: environment) {
                            PanelSurface(environment: environment, title: "Primary", subtitle: "Main workspace") {
                                Text("Structure should come from shared layout primitives.")
                            }
                        } secondary: {
                            ContextPanel(environment: environment, title: "Inspector") {
                                Text("Secondary details stay visually related without duplicating panel chrome.")
                            }
                        }
                    }
                )
            }
        case "container":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        ContainerBox(environment: environment) {
                            Text("ContainerBox groups dense content without creating a new surface language.")
                                .font(environment.theme.typography(.body).font)
                                .foregroundStyle(environment.theme.color(.textSecondary))
                        }
                    }
                )
            }
        case "content-layout":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        ContentLayout(environment: environment) {
                            HeaderBlock(environment: environment, title: "Content layout", subtitle: "Header and body stay aligned.") {
                                SystemButton(environment: environment, title: "Review", tone: .secondary) {}
                            }
                        } content: {
                            TextContentBlock(
                                environment: environment,
                                title: "Usage",
                                bodyText: "Keep hierarchy explicit before adding view-local styling."
                            )
                        }
                    }
                )
            }
        case "context-panel":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        ContextPanel(environment: environment, title: "Inspector") {
                            TextContentBlock(
                                environment: environment,
                                title: "Selection",
                                bodyText: "Use a context panel when supporting detail should stay adjacent to the current workspace."
                            )
                        }
                    }
                )
            }
        case "copy-to-clipboard":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        CopyToClipboardButton(environment: environment, title: "Copy token name", value: "accentPrimary")
                    }
                )
            }
        case "date-input", "date-picker":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        DateField(environment: environment, value: .constant(sampleDate))
                    }
                )
            }
        case "date-range-picker":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        DateRangeField(
                            environment: environment,
                            startDate: .constant(sampleDate),
                            endDate: .constant(sampleEndDate)
                        )
                    }
                )
            }
        case "donut-chart":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
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
                            valueFormatter: itemsFormatter
                        )
                    }
                )
            }
        case "drawer":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        DrawerSurface(environment: environment, title: "Inspector") {
                            Text("Drawer surfaces keep temporary detail visible without leaving the shared material system.")
                        }
                    }
                )
            }
        case "empty-state":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        EmptyStateView(
                            environment: environment,
                            title: "No components found",
                            message: "Clear the current filter or broaden the query to restore the full inventory.",
                            symbol: "square.grid.3x3",
                            actionTitle: "Clear filters",
                            action: {}
                        )
                    }
                )
            }
        case "error-boundary":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        ErrorStateView(
                            environment: environment,
                            title: "Unable to load previews",
                            message: "Retry after the example registry finishes rebuilding.",
                            actionTitle: "Retry",
                            action: {}
                        )
                    }
                )
            }
        case "expandable-section":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        ExpandableSection(
                            environment: environment,
                            title: "Advanced notes",
                            subtitle: "Expandable sections should preserve reading order.",
                            isExpanded: .constant(true)
                        ) {
                            Text("Structure should come from shared content primitives instead of local card stacks.")
                        }
                    }
                )
            }
        case "file-picker-button":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        FilePickerButton(environment: environment, title: "Browse files") {}
                    }
                )
            }
        case "file-token-group":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        FileTokenGroup(
                            environment: environment,
                            items: previewUploadItems,
                            onRetry: { _ in },
                            onRemove: { _ in }
                        )
                    }
                )
            }
        case "file-upload-field":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        FileUploadField(
                            environment: environment,
                            title: "Attach release notes",
                            subtitle: "Drop handling and item updates stay with the consumer.",
                            dropTitle: "Drop release notes",
                            dropDetail: "Accept Markdown, PDF, and image files.",
                            items: previewUploadItems,
                            acceptedContentTypes: [.plainText, .pdf, .image],
                            isTargeted: .constant(false),
                            onDropURLs: { _ in },
                            onPick: {},
                            onRetry: { _ in },
                            onRemove: { _ in }
                        )
                    }
                )
            }
        case "file-uploading-components":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        FileDropZone(
                            environment: environment,
                            title: "Drop release notes",
                            detail: "Accept Markdown, PDF, and image files.",
                            state: .ready,
                            acceptedContentTypes: [.plainText, .pdf, .image],
                            isTargeted: .constant(false),
                            onDropURLs: { _ in },
                            actionTitle: "Browse",
                            action: {}
                        )
                        FileTokenGroup(
                            environment: environment,
                            items: previewUploadItems,
                            onRetry: { _ in },
                            onRemove: { _ in }
                        )
                    }
                )
            }
        case "filter-select", "select":
            return { _, environment, options in
                AnyView(
                    previewColumn {
                        SelectMenu(
                            environment: environment,
                            options: [
                                .init(label: "Automatic", value: "automatic"),
                                .init(label: "Manual", value: "manual"),
                                .init(label: "Pinned", value: "pinned")
                            ],
                            selection: .constant("automatic"),
                            placeholder: "Choose mode",
                            isEnabled: !options.showDisabledState
                        )
                    }
                )
            }
        case "form":
            return { _, environment, options in
                AnyView(ExactFormPreview(environment: environment, options: options))
            }
        case "form-field":
            return { _, environment, options in
                AnyView(
                    previewColumn {
                        FormField(environment: environment, label: "Project name", description: "Keep field, help text, and validation in one rhythm.") {
                            TextInputField(
                                environment: environment,
                                placeholder: "Project name",
                                text: .constant("Builder system"),
                                status: options.showDisabledState ? .error : .normal,
                                message: options.showDisabledState ? "Enter a readable project name." : nil,
                                isReadOnly: options.showReadOnlyState,
                                isEnabled: !options.showDisabledState
                            )
                        }
                    }
                )
            }
        case "generative-ai-components":
            return { _, environment, _ in
                AnyView(ExactAIComponentsPreview(environment: environment))
            }
        case "grid":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        GridLayout(environment: environment, columns: 2) {
                            Box(environment: environment) {
                                Text("Preview")
                            }
                            Box(environment: environment) {
                                Text("Inspect")
                            }
                            Box(environment: environment) {
                                Text("Validate")
                            }
                            Box(environment: environment) {
                                Text("Ship")
                            }
                        }
                    }
                )
            }
        case "header":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        HeaderBlock(environment: environment, title: "Components", subtitle: "Inspect the system contract without leaving the workspace.") {
                            HStack(spacing: 10) {
                                StatusBadge(environment: environment, label: "Implemented", color: environment.theme.color(.success))
                                SystemButton(environment: environment, title: "Inspect", tone: .secondary) {}
                            }
                        }
                    }
                )
            }
        case "help-panel":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        HelpPanel(environment: environment, title: "Help", subtitle: "Keep guidance adjacent to the active task.") {
                            BulletList(
                                environment: environment,
                                items: [
                                    "Explain the current decision clearly.",
                                    "Tie recovery steps to the current selection.",
                                    "Avoid hiding support behind a route change."
                                ]
                            )
                        } footer: {
                            HStack(spacing: 10) {
                                SystemButton(environment: environment, title: "Open docs", tone: .primary) {}
                                SystemButton(environment: environment, title: "Dismiss", tone: .secondary) {}
                            }
                        }
                    }
                )
            }
        case "icon":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        HStack(spacing: 16) {
                            Image(systemName: "square.grid.2x2")
                            Image(systemName: "paintpalette")
                            Image(systemName: "checkmark.seal")
                        }
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(environment.theme.color(.accentPrimary))
                    }
                )
            }
        case "input":
            return { _, environment, options in
                AnyView(
                    previewColumn {
                        TextInputField(
                            environment: environment,
                            placeholder: "Project name",
                            text: .constant("Builder system"),
                            status: options.showDisabledState ? .error : .normal,
                            message: options.showDisabledState ? "Enter a readable project name." : nil,
                            isReadOnly: options.showReadOnlyState,
                            isEnabled: !options.showDisabledState
                        )
                    }
                )
            }
        case "items-palette":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        ItemsPalette(
                            environment: environment,
                            title: "Insert items",
                            subtitle: "Select a reusable tile or insert it into the current board.",
                            items: previewPaletteItems(environment: environment),
                            selectedItemID: .constant("metric-card"),
                            insertDestinations: [
                                .init(title: "Insert into Queued", columnID: "queued", columnTitle: "Queued", index: 1)
                            ],
                            onActivateItem: { _ in },
                            onInsertItem: { _, _, _ in }
                        )
                    }
                )
            }
        case "keyvalue-pairs":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        KeyValuePairs(
                            environment: environment,
                            pairs: [
                                .init(key: "Mode", value: "Compact"),
                                .init(key: "Contrast", value: "Standard"),
                                .init(key: "Density", value: "Default")
                            ]
                        )
                    }
                )
            }
        case "line-chart":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        LineChartPanel(
                            environment: environment,
                            title: "Adoption trend",
                            state: .ready,
                            series: [adoptionMetricSeries(environment: environment)],
                            selection: .constant(nil),
                            visibleSeriesIDs: .constant(["Adoption"]),
                            valueFormatter: percentageFormatter
                        )
                    }
                )
            }
        case "link":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        Link("Open design-system docs", destination: URL(string: "https://example.com/design-system")!)
                            .font(environment.theme.typography(.body).font)
                    }
                )
            }
        case "list":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        ListSurface(environment: environment, items: ["Tokens", "Patterns", "Accessibility"])
                    }
                )
            }
        case "live-region":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        LiveRegionMessage(
                            environment: environment,
                            message: "Status updates stay readable without relying on color alone."
                        )
                    }
                )
            }
        case "loading-bar":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        LoadingBar(
                            environment: environment,
                            label: "Refreshing examples",
                            detail: "Generated references are rebuilding."
                        )
                    }
                )
            }
        case "modal":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        ModalSurface(environment: environment, title: "Confirm changes") {
                            Text("Modal surfaces should keep focus, context, and dismissal predictable.")
                        }
                    }
                )
            }
        case "mixed-chart":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        MixedChartPanel(
                            environment: environment,
                            title: "Coverage and adoption",
                            subtitle: "Selection stays synchronized across the chart and detail pane.",
                            state: .ready,
                            barSeries: [coverageMetricSeries(environment: environment)],
                            lineSeries: [adoptionMetricSeries(environment: environment)],
                            selection: .constant(sampleMetricSelection()),
                            visibleSeriesIDs: .constant(["Coverage", "Adoption"]),
                            valueFormatter: percentageFormatter
                        )
                    }
                )
            }
        case "multiselect":
            return { _, environment, options in
                AnyView(
                    previewColumn {
                        MultiselectMenu(
                            environment: environment,
                            options: [
                                .init(label: "Shell", value: "Shell"),
                                .init(label: "Content", value: "Content"),
                                .init(label: "Feedback", value: "Feedback")
                            ],
                            selection: .constant(Set(["Shell", "Feedback"])),
                            placeholder: "Pick areas",
                            isEnabled: !options.showDisabledState
                        )
                    }
                )
            }
        case "notice-stack":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        NoticeStack(
                            environment: environment,
                            notices: [
                                .init(title: "Tokens updated", message: "Review the latest export before release.", tone: .info),
                                .init(title: "Contrast check passed", message: "Accessibility acceptance is still green.", tone: .success)
                            ]
                        )
                    }
                )
            }
        case "pagination":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        PaginationControl(environment: environment, page: .constant(2), pageCount: 5)
                    }
                )
            }
        case "panel-layout":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        PanelLayout(environment: environment) {
                            PanelSurface(environment: environment, title: "Overview") {
                                Text("Group related panels without adding extra chrome.")
                            }
                            PanelSurface(environment: environment, title: "Tokens") {
                                Text("Panel layout keeps the vertical rhythm shared across surfaces.")
                            }
                        }
                    }
                )
            }
        case "popover":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        PopoverSurface(environment: environment, title: "Quick action") {
                            Text("Popover surfaces stay visually related to the rest of the shell.")
                        }
                    }
                )
            }
        case "progress-bar":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        ProgressBar(environment: environment, value: 0.64)
                    }
                )
            }
        case "prompt-input":
            return { _, environment, options in
                AnyView(
                    previewColumn {
                        PromptInput(
                            environment: environment,
                            prompt: .constant("Summarize the rollout risks."),
                            actionTitle: "Draft",
                            supportingText: "Command-Return submits. Keep authored input visible while the draft is generating.",
                            isEnabled: !options.showDisabledState,
                            isSubmitting: options.showLoadingState,
                            isMultiline: true,
                            minHeight: 110,
                            submitShortcutBehavior: .commandReturn,
                            secondaryActionTitle: "Clear",
                            secondaryActionSymbol: "xmark",
                            onSecondaryAction: {},
                            onSubmit: {}
                        )
                    }
                )
            }
        case "property-filter":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        PropertyFilterBar(
                            environment: environment,
                            query: .constant("shell"),
                            activeTokens: ["shell", "grouped", "dense"]
                        )
                    }
                )
            }
        case "radio-group":
            return { _, environment, options in
                AnyView(
                    previewColumn {
                        RadioGroup(
                            environment: environment,
                            options: [
                                .init(label: "Compact", value: 0),
                                .init(label: "Default", value: 1, isEnabled: !options.showDisabledState),
                                .init(label: "Comfortable", value: 2, isEnabled: !options.showDisabledState)
                            ],
                            selection: .constant(1)
                        )
                    }
                )
            }
        case "resource-selector":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        ResourceSelector(
                            environment: environment,
                            resources: ["Design system", "Showcase", "Artifact generator"],
                            selection: .constant("Design system")
                        )
                    }
                )
            }
        case "segmented-control":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        SegmentedPicker(
                            environment: environment,
                            options: [("Compact", "compact"), ("Default", "default"), ("Comfortable", "comfortable")],
                            selection: .constant("default"),
                            style: .neutral
                        )
                        .frame(width: 280)
                    }
                )
            }
        case "side-navigation":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        NavigationSidebarList(
                            environment: environment,
                            sections: [
                                .init(
                                    id: "workspace",
                                    title: "Workspace",
                                    items: [
                                        .init(id: "home", title: "Home", symbol: "house"),
                                        .init(id: "components", title: "Components", symbol: "square.grid.2x2"),
                                        .init(id: "recipes", title: "Recipes", symbol: "rectangle.3.group")
                                    ]
                                )
                            ],
                            selection: .constant("components"),
                            rowHeight: 44
                        ) { item, isSelected in
                            SidebarRow(
                                environment: environment,
                                title: item.title,
                                symbol: item.symbol ?? "circle",
                                isSelected: isSelected
                            )
                        }
                        .frame(width: 240, height: 184)
                    }
                )
            }
        case "slider":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        SliderField(environment: environment, title: "Contrast", value: .constant(42), in: 0...100)
                    }
                )
            }
        case "space-between":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        SpaceBetween(environment: environment) {
                            Text("Overview")
                            TokenBadge(environment: environment, title: "Selected", tint: environment.theme.color(.accentPrimary))
                        }
                    }
                )
            }
        case "spinner":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        LoadingSpinner(environment: environment, label: "Refreshing")
                    }
                )
            }
        case "split-panel":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        SplitPanel(environment: environment) {
                            PanelSurface(environment: environment, title: "Canvas") {
                                Text("Primary content remains stable while secondary detail opens alongside it.")
                            }
                        } secondary: {
                            PanelSurface(environment: environment, title: "Details") {
                                Text("Use split panels when both regions need to stay visible.")
                            }
                        }
                    }
                )
            }
        case "status-indicator":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        StatusIndicator(
                            environment: environment,
                            label: "System healthy",
                            detail: "All exports and docs resolve.",
                            tone: .success
                        )
                    }
                )
            }
        case "steps":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        StepsView(
                            environment: environment,
                            steps: [
                                .init(id: "audit", title: "Audit", detail: "Review API shape.", status: .complete),
                                .init(id: "build", title: "Build", detail: "Add reusable surfaces.", status: .current),
                                .init(id: "verify", title: "Verify", detail: "Run validation.", status: .warning, isOptional: true)
                            ]
                        )
                    }
                )
            }
        case "support-prompt-group":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        SupportPromptGroup(
                            environment: environment,
                            title: "Suggested prompts",
                            prompts: [
                                .init(id: "summarize", title: "Summarize", detail: "Condense the latest changes.", isSelected: true, isRecommended: true),
                                .init(id: "find-gaps", title: "Find gaps", detail: "Inspect missing showcase coverage."),
                                .init(id: "compare", title: "Explain tradeoffs", detail: "Compare candidate APIs.", isEnabled: false)
                            ]
                        ) { _ in }
                    }
                )
            }
        case "table":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
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
                            selectedRowID: .constant("Components")
                        )
                    }
                )
            }
        case "tabs":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        Tabs(
                            environment: environment,
                            items: [
                                .init(title: "Overview", value: "overview"),
                                .init(title: "Tokens", value: "tokens"),
                                .init(title: "Usage", value: "usage")
                            ],
                            selection: .constant("overview")
                        )
                    }
                )
            }
        case "tag-editor":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        TagEditor(environment: environment, tags: .constant(["UI", "Theme", "Review"]))
                    }
                )
            }
        case "text-area":
            return { _, environment, options in
                AnyView(
                    previewColumn {
                        TextAreaField(
                            environment: environment,
                            placeholder: "Notes",
                            text: .constant("Fields should keep validation and helper text in one rhythm."),
                            status: options.showDisabledState ? .warning : .normal,
                            message: options.showDisabledState ? "Resolve the field warning before continuing." : nil,
                            isReadOnly: options.showReadOnlyState,
                            isEnabled: !options.showDisabledState
                        )
                    }
                )
            }
        case "text-content":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        TextContentBlock(
                            environment: environment,
                            title: "Usage",
                            bodyText: "Use text content blocks for editorial guidance inside grouped surfaces."
                        )
                    }
                )
            }
        case "text-filter":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        TextFilterField(environment: environment, placeholder: "Filter components", text: .constant("button"))
                    }
                )
            }
        case "tiles":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        TilePicker(
                            environment: environment,
                            options: [
                                .init(label: "Overview", detail: "Primary browser", symbol: "square.grid.2x2", value: "overview"),
                                .init(label: "Tokens", detail: "Design references", symbol: "paintpalette", value: "tokens")
                            ],
                            selection: .constant("overview")
                        )
                    }
                )
            }
        case "time-input":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        TimeField(environment: environment, value: .constant(sampleDate))
                    }
                )
            }
        case "toggle":
            return { _, environment, options in
                AnyView(
                    previewColumn {
                        ToggleSwitch(
                            environment: environment,
                            title: "Use native transitions",
                            detail: options.showLoadingState ? "Loading preserves the selected value context." : nil,
                            isOn: .constant(true),
                            isEnabled: !options.showDisabledState,
                            isLoading: options.showLoadingState
                        )
                    }
                )
            }
        case "toggle-button":
            return { _, environment, options in
                AnyView(
                    previewColumn {
                        ToggleButton(
                            environment: environment,
                            title: "Pinned",
                            isOn: .constant(true)
                        )
                    }
                )
            }
        case "token":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        TokenBadge(environment: environment, title: "accentPrimary", tint: environment.theme.color(.accentPrimary))
                    }
                )
            }
        case "token-group":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        TokenGroup(environment: environment, titles: ["accentPrimary", "groupedSurface", "panelPadding"])
                    }
                )
            }
        case "top-navigation":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        TopNavigationBar(environment: environment) {
                            Text("Builder workspace")
                                .font(environment.theme.typography(.sectionTitle).font)
                        } trailing: {
                            HStack(spacing: 10) {
                                ToolbarButton(environment: environment, title: "Search", symbol: "magnifyingglass") {}
                                ToolbarButton(environment: environment, title: "Inspect", symbol: "sidebar.right") {}
                            }
                        }
                    }
                )
            }
        case "tree-view":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        TreeView(
                            environment: environment,
                            nodes: [
                                .init(title: "System", children: [
                                    .init(title: "Colors"),
                                    .init(title: "Typography"),
                                    .init(title: "Spacing")
                                ])
                            ],
                            selection: .constant("System")
                        )
                    }
                )
            }
        case "tutorial-components":
            return { _, environment, _ in
                AnyView(ExactTutorialComponentsPreview(environment: environment))
            }
        case "tutorial-panel":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        TutorialPanel(
                            environment: environment,
                            title: "Rollout guidance",
                            subtitle: "Keep progression visible without leaving the current workflow.",
                            steps: [
                                .init(id: "audit", title: "Audit", detail: "Review API shape."),
                                .init(id: "build", title: "Build", detail: "Add reusable surfaces."),
                                .init(id: "verify", title: "Verify", detail: "Run validation.", status: .warning, isOptional: true)
                            ],
                            currentStepID: .constant("build"),
                            completedStepIDs: ["audit"],
                            stepChangeAnnouncement: { step, index, total in
                                "Step \(index) of \(total): \(step.title)."
                            }
                        ) {
                            Text("Tutorial flows should guide builders without leaving the shared shell language.")
                        } primaryActions: {
                            SystemButton(environment: environment, title: "Continue", tone: .primary) {}
                        } secondaryActions: {
                            SystemButton(environment: environment, title: "Back", tone: .secondary) {}
                        }
                    }
                )
            }
        case "view-preferences":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
                        ViewPreferencesPanel(
                            environment: environment,
                            denseMode: .constant(true),
                            showsMetadata: .constant(true)
                        )
                    }
                )
            }
        case "wizard":
            return { _, environment, _ in
                AnyView(
                    previewColumn {
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
                            Text("Wizard layout keeps the current task visible while steps stay anchored in a secondary region.")
                        }
                    }
                )
            }
        default:
            return nil
        }
    }
}

private struct PreviewCard: Identifiable {
    let id: String
    let title: String
    let subtitle: String
}

private func previewColumn<Content: View>(@ViewBuilder content: () -> Content) -> some View {
    VStack(alignment: .leading, spacing: 14) {
        content()
    }
    .frame(maxWidth: .infinity, alignment: .leading)
}

private let sampleCode = """
struct ExampleView: View {
    var body: some View {
        Text("Builder")
    }
}
"""

private let sampleDate = Date(timeIntervalSince1970: 1_720_000_000)
private let sampleEndDate = Date(timeIntervalSince1970: 1_720_086_400)

private let previewCards: [PreviewCard] = [
    .init(id: "overview", title: "Overview", subtitle: "Primary browser surface"),
    .init(id: "tokens", title: "Tokens", subtitle: "Generated references"),
    .init(id: "accessibility", title: "Accessibility", subtitle: "Acceptance and QA notes")
]

private func sampleMetricSelection() -> MetricSelection {
    MetricSelection(
        kind: .point,
        seriesID: "Coverage",
        seriesTitle: "Coverage",
        datumID: "Tokens",
        label: "Tokens",
        value: 82,
        formattedValue: "82%"
    )
}

private func percentageFormatter(_ value: Double) -> String {
    "\(Int(value))%"
}

private func itemsFormatter(_ value: Double) -> String {
    "\(Int(value)) items"
}

private func coverageMetricSeries(environment: DesignSystemEnvironment) -> MetricSeries {
    .init(
        title: "Coverage",
        color: environment.theme.color(.chartBlue),
        points: [
            .init(label: "Tokens", value: 82),
            .init(label: "Components", value: 80),
            .init(label: "Patterns", value: 24)
        ]
    )
}

private func adoptionMetricSeries(environment: DesignSystemEnvironment) -> MetricSeries {
    .init(
        title: "Adoption",
        color: environment.theme.color(.chartTeal),
        points: [
            .init(label: "Tokens", value: 64),
            .init(label: "Components", value: 58),
            .init(label: "Patterns", value: 18)
        ]
    )
}

private func previewBoardColumns(environment: DesignSystemEnvironment) -> [Board.Column] {
    [
        .init(
            id: "queued",
            title: "Queued",
            items: [
                .init(
                    id: "review-docs",
                    title: "Review docs",
                    detail: "Match snippets to the real API.",
                    status: "Review",
                    statusColor: environment.theme.color(.warning)
                ),
                .init(
                    id: "sync-showcase",
                    title: "Sync showcase",
                    detail: "Confirm every component appears in the browser.",
                    status: "Ready",
                    statusColor: environment.theme.color(.success)
                )
            ]
        ),
        .init(
            id: "ready",
            title: "Ready",
            items: [
                .init(
                    id: "publish-catalog",
                    title: "Publish catalog",
                    detail: "Regenerate docs and snapshots.",
                    status: "Queued",
                    statusColor: environment.theme.color(.info)
                )
            ]
        )
    ]
}

private func previewPaletteItems(environment: DesignSystemEnvironment) -> [Board.Item] {
    [
        .init(
            id: "metric-card",
            title: "Metric card",
            detail: "Reusable dashboard tile.",
            status: "Ready",
            statusColor: environment.theme.color(.success)
        ),
        .init(
            id: "status-list",
            title: "Status list",
            detail: "Dense collection summary.",
            status: "Review",
            statusColor: environment.theme.color(.warning)
        )
    ]
}

private let previewUploadItems: [FileUploadItem] = [
    .init(
        id: "release-notes",
        title: "release-notes.md",
        detail: "18 KB",
        status: .success,
        message: "Upload complete.",
        symbol: "doc.text"
    ),
    .init(
        id: "screenshots",
        title: "screenshots.zip",
        detail: "2 files",
        status: .uploading,
        progress: 0.64,
        message: "Uploading archive...",
        symbol: "archivebox",
        canRetry: false
    )
]

private struct ExactFormPreview: View {
    let environment: DesignSystemEnvironment
    let options: ComponentPreviewOptions

    var body: some View {
        previewColumn {
            FormField(environment: environment, label: "Project name", description: "Editable field with shared status semantics.") {
                TextInputField(
                    environment: environment,
                    placeholder: "Project name",
                    text: .constant("Builder system"),
                    status: options.showDisabledState ? .error : .normal,
                    message: options.showDisabledState ? "Enter a valid project name." : nil,
                    isReadOnly: options.showReadOnlyState,
                    isEnabled: !options.showDisabledState
                )
            }

            FormField(environment: environment, label: "Search", description: "Search should remain related to field validation and density.") {
                TextFilterField(environment: environment, placeholder: "Search the system", text: .constant("button"))
            }

            FormField(environment: environment, label: "Notes", hint: options.showReadOnlyState ? "This example is showing the read-only state." : nil) {
                TextAreaField(
                    environment: environment,
                    placeholder: "Notes",
                    text: .constant("Fields should keep validation and helper text in one rhythm."),
                    status: options.showDisabledState ? .warning : .normal,
                    message: options.showDisabledState ? "Resolve the field warning before continuing." : nil,
                    isReadOnly: options.showReadOnlyState,
                    isEnabled: !options.showDisabledState
                )
            }
        }
    }
}

private struct ExactAIComponentsPreview: View {
    let environment: DesignSystemEnvironment

    var body: some View {
        PanelSurface(environment: environment, title: "Generative workflow", subtitle: "Keep prompt, output, and review actions explicit.") {
            HStack(spacing: 10) {
                AvatarView(environment: environment, title: "Builder assistant", symbol: "sparkles")
                TokenBadge(environment: environment, title: "Review required", tint: nil)
            }

            PromptInput(
                environment: environment,
                prompt: .constant("Summarize the component contract and call out review risks."),
                actionTitle: "Draft",
                supportingText: "Command-Return submits. Keep authored input visible while the draft is generating.",
                isEnabled: true,
                isSubmitting: false,
                isMultiline: true,
                minHeight: 110,
                submitShortcutBehavior: .commandReturn,
                secondaryActionTitle: "Clear",
                secondaryActionSymbol: "xmark",
                onSecondaryAction: {},
                onSubmit: {}
            )

            SupportPromptGroup(
                environment: environment,
                title: "Suggested prompts",
                prompts: [
                    .init(id: "summarize", title: "Summarize", detail: "Condense the latest changes.", isSelected: true, isRecommended: true),
                    .init(id: "find-gaps", title: "Find gaps", detail: "Inspect missing inventory."),
                    .init(id: "compare", title: "Explain tradeoffs", detail: "Compare candidate APIs.", isEnabled: false)
                ]
            ) { _ in }

            ChatBubble(environment: environment, role: .user, author: "Builder", message: "Summarize the rollout risks.")
            ChatBubble(
                environment: environment,
                role: .assistant,
                author: "Builder assistant",
                message: "BuilderDesignSystem now resolves exact component previews before falling back to family examples.",
                detail: "Keep prompt, generated content, and next-step actions explicit.",
                state: .complete,
                footerMetadata: [
                    .init(label: "Model", value: "Builder review"),
                    .init(label: "Updated", value: "Now")
                ],
                showsCopyAction: true
            )
        }
    }
}

private struct ExactTutorialComponentsPreview: View {
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
                    .init(id: "verify", title: "Verify", detail: "Run validation before release.", status: .warning, isOptional: true)
                ],
                currentStepID: .constant("build"),
                completedStepIDs: ["audit"],
                stepChangeAnnouncement: { step, index, total in
                    "Tutorial progress updated. Step \(index) of \(total): \(step.title)."
                }
            ) {
                Text("Tutorial flows should guide builders without leaving the shared shell language.")
            } primaryActions: {
                SystemButton(environment: environment, title: "Continue", tone: .primary) {}
            } secondaryActions: {
                SystemButton(environment: environment, title: "Back", tone: .secondary) {}
            }
        }
    }
}
