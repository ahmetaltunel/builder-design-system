import Foundation

struct ExactComponentContent {
    let summary: String
    let code: String
}

struct ExactPatternContent {
    let summary: String
    let code: String
}

enum ExactReferenceContent {
    static func component(
        id: ComponentExampleID,
        displayName: String,
        family: ComponentExampleFamily,
        fallbackCode: String
    ) -> ExactComponentContent {
        .init(
            summary: componentSummary(displayName: displayName, family: family),
            code: componentCode(for: id, displayName: displayName) ?? fallbackCode
        )
    }

    static func pattern(
        id: PatternExampleID,
        displayName: String,
        family: PatternExampleFamily,
        fallbackCode: String
    ) -> ExactPatternContent {
        .init(
            summary: patternSummary(displayName: displayName, family: family),
            code: patternCode(for: id, displayName: displayName) ?? fallbackCode
        )
    }

    private static func componentSummary(displayName: String, family: ComponentExampleFamily) -> String {
        switch family {
        case .shell:
            return "Use \(displayName) to frame workspace structure without leaving the shared shell language."
        case .toolbar:
            return "Use \(displayName) when actions and context need to stay dense, quiet, and desktop-native."
        case .navigation:
            return "Use \(displayName) when hierarchy, current location, and keyboard travel need to stay aligned."
        case .form:
            return "Use \(displayName) when fields, helper text, and validation need one clear rhythm."
        case .selection:
            return "Use \(displayName) when selection state must stay legible across dense product surfaces."
        case .feedback:
            return "Use \(displayName) when status needs to be explicit without taking over the workspace."
        case .overlay:
            return "Use \(displayName) when temporary surfaces should keep focus, context, and dismissal predictable."
        case .content:
            return "Use \(displayName) to organize content before reaching for bespoke layout or decorative chrome."
        case .data:
            return "Use \(displayName) when analytical content needs to stay readable and token-driven."
        case .ai:
            return "Use \(displayName) when generated output, review state, and next actions must remain explicit."
        case .tutorial:
            return "Use \(displayName) when a guided flow needs visible progress inside the same shell language."
        case .utility:
            return "Use \(displayName) for quiet supporting actions that still need system-level clarity."
        case .specialized:
            return "Use \(displayName) when a domain-specific workflow still needs the core system's spacing, state, and feedback rules."
        }
    }

    private static func patternSummary(displayName: String, family: PatternExampleFamily) -> String {
        switch family {
        case .actionFlow:
            return "Use \(displayName) when the interface needs a clear next step, stable validation, and explicit completion language."
        case .announcement:
            return "Use \(displayName) to introduce change without turning the product shell into a marketing surface."
        case .unsavedChanges:
            return "Use \(displayName) when user work is at risk and recovery choices must stay unambiguous."
        case .dataVisualization:
            return "Use \(displayName) when charts, filters, and dense analytical detail need one shared operating surface."
        case .density:
            return "Use \(displayName) when teams need to change information density without changing the visual language."
        case .stateHandling:
            return "Use \(displayName) when blocked, empty, or error conditions must still orient the user toward recovery."
        case .dragAndDrop:
            return "Use \(displayName) when file intake or rearrangement should feel spatially obvious on desktop."
        case .filtering:
            return "Use \(displayName) when search, filters, and results need to behave like one connected workflow."
        case .hero:
            return "Use \(displayName) only when a strong opening state improves orientation and the copy stays utility-led."
        case .support:
            return "Use \(displayName) when help, inspection, or magnified context should stay adjacent to the work."
        case .loading:
            return "Use \(displayName) when refresh and in-flight work need to preserve layout stability and status clarity."
        case .onboarding:
            return "Use \(displayName) when the first-run journey needs guided progress inside the same system language."
        case .navigation:
            return "Use \(displayName) when primary navigation, secondary context, and content must feel like one desktop workspace."
        case .dashboard:
            return "Use \(displayName) when metrics, lists, and summaries share one calm operating surface."
        case .timeAndFeedback:
            return "Use \(displayName) when recency and outcome messaging need to stay concise enough for repeated exposure."
        }
    }

    private static func componentCode(for id: ComponentExampleID, displayName: String) -> String? {
        switch id.rawValue {
        case "alert":
            return code([
                "AlertBanner(environment: environment, title: \"\(displayName)\", message: \"Review validation before continuing.\", tone: .warning) {}"
            ])
        case "anchor-navigation":
            return code([
                "AnchorNavigation(environment: environment, items: [",
                "    .init(title: \"Overview\", anchor: \"overview\"),",
                "    .init(title: \"Tokens\", anchor: \"tokens\"),",
                "    .init(title: \"Accessibility\", anchor: \"accessibility\")",
                "])"
            ])
        case "area-chart":
            return code([
                "AreaChartPanel(environment: environment, title: \"\(displayName)\", series: [",
                "    .init(title: \"Coverage\", color: environment.theme.color(.chartBlue), points: [",
                "        .init(label: \"Mon\", value: 64),",
                "        .init(label: \"Tue\", value: 68),",
                "        .init(label: \"Wed\", value: 74)",
                "    ])",
                "], selection: .constant(nil), visibleSeriesIDs: .constant([\"Coverage\"]), valueFormatter: { value in \"\\(Int(value))%\" })"
            ])
        case "app-layout":
            return code([
                "AppLayout(environment: environment, sidebarWidth: 240) {",
                "    SidebarRow(environment: environment, title: \"Components\", symbol: \"square.grid.2x2\", isSelected: true)",
                "} content: {",
                "    PanelSurface(environment: environment, title: \"\(displayName)\") {",
                "        Text(\"Shell structure stays token-driven.\")",
                "    }",
                "}"
            ])
        case "app-layout-toolbar":
            return code([
                "AppLayoutToolbar(environment: environment) {",
                "    ToolbarButton(environment: environment, title: \"Refresh\", symbol: \"arrow.clockwise\") {}",
                "    ToolbarButton(environment: environment, title: \"Inspect\", symbol: \"sidebar.right\") {}",
                "}"
            ])
        case "attribute-editor":
            return code([
                "AttributeEditor(environment: environment, attributes: [",
                "    .init(id: \"title\", name: \"Title\", value: \"Builder surface\"),",
                "    .init(id: \"status\", name: \"Status\", value: \"Ready\")",
                "], selectedAttributeID: $selectedAttributeID)"
            ])
        case "autosuggest":
            return code([
                "AutosuggestField(environment: environment, placeholder: \"Search components\", text: $query, suggestions: [\"Button\", \"Tabs\", \"Table\"])"
            ])
        case "avatar":
            return code([
                "AvatarView(environment: environment, title: \"Builder assistant\", symbol: \"sparkles\")"
            ])
        case "badge":
            return code([
                "StatusBadge(environment: environment, label: \"Ready\", tone: .success)"
            ])
        case "bar-chart":
            return code([
                "BarChartPanel(environment: environment, title: \"\(displayName)\", state: .ready, series: [",
                "    .init(title: \"Coverage\", color: environment.theme.color(.chartBlue), points: [",
                "        .init(label: \"Tokens\", value: 82),",
                "        .init(label: \"Components\", value: 80),",
                "        .init(label: \"Patterns\", value: 24)",
                "    ])",
                "], selection: .constant(nil), visibleSeriesIDs: .constant([\"Coverage\"]), valueFormatter: { value in \"\\(Int(value))%\" })"
            ])
        case "board":
            return code([
                "Board(environment: environment, columns: [",
                "    .init(id: \"queued\", title: \"Queued\", items: [",
                "        .init(id: \"review-tokens\", title: \"Review tokens\", detail: \"Validation and docs\", status: \"Review\", statusColor: environment.theme.color(.warning)),",
                "        .init(id: \"verify-docs\", title: \"Verify docs\", detail: \"Generated references\", status: \"Ready\", statusColor: environment.theme.color(.success))",
                "    ]),",
                "    .init(id: \"done\", title: \"Done\", cards: [\"Ship foundations\"])",
                "], selectedItemID: .constant(\"review-tokens\"), onActivateItem: { item in",
                "    print(item.title)",
                "}, onMoveItem: { itemID, destinationColumnID, destinationIndex in",
                "    print(itemID, destinationColumnID, destinationIndex)",
                "])"
            ])
        case "board-item":
            return code([
                "BoardItemView(environment: environment, item: .init(title: \"Review tokens\", detail: \"Validation and docs\", status: \"Review\", statusColor: environment.theme.color(.warning)), isSelected: true, moveDestinations: [",
                "    .init(title: \"Move to Done\", columnID: \"done\", columnTitle: \"Done\", index: 0)",
                "], onMove: { destination in",
                "    print(destination.columnID)",
                "})"
            ])
        case "box":
            return code([
                "Box(environment: environment) {",
                "    Text(\"\(displayName) keeps grouped content calm and readable.\")",
                "}"
            ])
        case "breadcrumb-group":
            return code([
                "BreadcrumbGroup(environment: environment, items: [",
                "    .init(title: \"Library\"),",
                "    .init(title: \"Components\"),",
                "    .init(title: \"\(displayName)\", isCurrent: true)",
                "])"
            ])
        case "button":
            return code([
                "SystemButton(environment: environment, title: \"Save changes\", tone: .primary) {}"
            ])
        case "button-dropdown":
            return code([
                "ButtonDropdown(environment: environment, title: \"Create\", items: [",
                "    .init(title: \"Component\"),",
                "    .init(title: \"Pattern\"),",
                "    .init(title: \"Foundation note\")",
                "]) { item in",
                "    print(item.title)",
                "}"
            ])
        case "button-group":
            return code([
                "ButtonGroup(environment: environment, options: [",
                "    .init(label: \"Preview\", value: \"preview\"),",
                "    .init(label: \"Inspect\", value: \"inspect\")",
                "], selection: $selection)"
            ])
        case "calendar":
            return code([
                "CalendarPanel(environment: environment, title: \"\(displayName)\", highlightedDates: [Date()])"
            ])
        case "cards":
            return code([
                "CardGrid(environment: environment, items: cards) { card in",
                "    PanelSurface(environment: environment, title: card.title, subtitle: card.subtitle) {",
                "        Text(card.body)",
                "    }",
                "}"
            ])
        case "chat-bubble":
            return code([
                "ChatBubble(environment: environment, role: .assistant, author: \"Builder assistant\", message: \"Review is ready.\", detail: \"Draft output is still streaming.\", state: .streaming, footerMetadata: [",
                "    .init(label: \"Model\", value: \"Builder review\"),",
                "    .init(label: \"Updated\", value: \"Now\")",
                "], showsCopyAction: true)"
            ])
        case "charts":
            return code([
                "BarChartPanel(environment: environment, title: \"\(displayName)\", state: .ready, series: [",
                "    .init(title: \"Coverage\", color: environment.theme.color(.chartBlue), points: [",
                "        .init(label: \"Quality\", value: 78),",
                "        .init(label: \"Coverage\", value: 92)",
                "    ])",
                "], selection: .constant(nil), visibleSeriesIDs: .constant([\"Coverage\"]), valueFormatter: { value in \"\\(Int(value))%\" })"
            ])
        case "checkbox":
            return code([
                "Checkbox(environment: environment, title: \"Enable grouped settings\", isOn: $isEnabled)"
            ])
        case "code-editor":
            return code([
                "CodeEditorSurface(environment: environment, title: \"\(displayName)\", code: sampleCode)"
            ])
        case "code-view":
            return code([
                "CodeView(environment: environment, code: sampleCode, language: \"swift\")"
            ])
        case "view-preferences":
            return code([
                "ViewPreferencesPanel(environment: environment, densitySelection: $density, sortSelection: $sort)"
            ])
        case "filter-select", "select":
            return code([
                "SelectMenu(environment: environment, options: [",
                "    .init(label: \"Automatic\", value: \"automatic\"),",
                "    .init(label: \"Manual\", value: \"manual\")",
                "], selection: $selection)"
            ])
        case "column-layout":
            return code([
                "ColumnLayout(environment: environment) {",
                "    PanelSurface(environment: environment, title: \"Primary\") { Text(\"Main workspace\") }",
                "} secondary: {",
                "    ContextPanel(environment: environment, title: \"Inspector\") { Text(\"Secondary details\") }",
                "}"
            ])
        case "container":
            return code([
                "ContainerBox(environment: environment) {",
                "    Text(\"\(displayName) groups content without inventing new chrome.\")",
                "}"
            ])
        case "content-layout":
            return code([
                "ContentLayout(environment: environment) {",
                "    HeaderBlock(environment: environment, title: \"\(displayName)\", subtitle: \"Header and content stay aligned.\")",
                "} content: {",
                "    TextContentBlock(environment: environment, title: \"Usage\", body: \"Keep layout structure explicit before styling.\")",
                "}"
            ])
        case "copy-to-clipboard":
            return code([
                "CopyToClipboardButton(environment: environment, title: \"Copy token name\", value: \"accentAction\")"
            ])
        case "date-input", "date-picker":
            return code([
                "DateField(environment: environment, label: \"Release date\", value: $date)"
            ])
        case "date-range-picker":
            return code([
                "DateRangeField(environment: environment, label: \"Review window\", startDate: $startDate, endDate: $endDate)"
            ])
        case "donut-chart":
            return code([
                "DonutChartPanel(environment: environment, title: \"\(displayName)\", state: .ready, slices: [",
                "    .init(title: \"Ready\", value: 18, color: environment.theme.color(.chartGreen)),",
                "    .init(title: \"Review\", value: 7, color: environment.theme.color(.chartAmber)),",
                "    .init(title: \"Blocked\", value: 3, color: environment.theme.color(.chartRed))",
                "], selection: .constant(nil), visibleSeriesIDs: .constant([\"Ready\", \"Review\", \"Blocked\"]), valueFormatter: { value in \"\\(Int(value)) items\" })"
            ])
        case "drawer":
            return code([
                "DrawerSurface(environment: environment, title: \"\(displayName)\") {",
                "    ValidationSummary(environment: environment, items: validationItems)",
                "}"
            ])
        case "empty-state":
            return code([
                "EmptyStateView(environment: environment, title: \"Nothing matches the current filter\", message: \"Clear filters or broaden the search.\")"
            ])
        case "error-boundary":
            return code([
                "ErrorStateView(environment: environment, title: \"\(displayName)\", message: \"Recover the workspace without losing context.\", actionTitle: \"Retry\") {}"
            ])
        case "expandable-section":
            return code([
                "ExpandableSection(environment: environment, title: \"\(displayName)\", isExpanded: $isExpanded) {",
                "    Text(\"Nested guidance remains readable when expanded.\")",
                "}"
            ])
        case "file-picker-button":
            return code([
                "FilePickerButton(environment: environment, title: \"Browse files\") {}"
            ])
        case "file-token-group":
            return code([
                "FileTokenGroup(environment: environment, items: [",
                "    .init(title: \"release-notes.md\", detail: \"18 KB\", status: .success, message: \"Uploaded successfully.\", symbol: \"doc.text\"),",
                "    .init(title: \"screenshots.zip\", detail: \"2 files\", status: .uploading, progress: 0.64, message: \"Uploading archive...\", symbol: \"archivebox\"),",
                "    .init(title: \"hero.png\", detail: \"4.2 MB\", status: .error, message: \"The file exceeds the current size limit.\", symbol: \"photo\", canRetry: true)",
                "], onRetry: { item in",
                "    print(item.id)",
                "}, onRemove: { item in",
                "    print(item.id)",
                "})"
            ])
        case "file-upload-field":
            return code([
                "FileUploadField(environment: environment, title: \"Attach release notes\", subtitle: \"Drop handling and item updates stay with the consumer.\", dropTitle: \"Drop release notes\", dropDetail: \"Accept Markdown, PDF, and image files.\", items: [",
                "    .init(title: \"release-notes.md\", detail: \"18 KB\", status: .success, message: \"Uploaded successfully.\", symbol: \"doc.text\"),",
                "    .init(title: \"hero.png\", detail: \"4.2 MB\", status: .error, message: \"The file exceeds the current size limit.\", symbol: \"photo\", canRetry: true)",
                "], acceptedContentTypes: [.plainText, .pdf, .image], isTargeted: .constant(false), onDropURLs: { urls in",
                "    print(urls.count)",
                "}, onPick: {}, onRetry: { item in",
                "    print(item.id)",
                "}, onRemove: { item in",
                "    print(item.id)",
                "})"
            ])
        case "file-uploading-components":
            return code([
                "VStack(spacing: 12) {",
                "    FileDropZone(environment: environment, title: \"Drop release notes\", detail: \"Accept Markdown, PDF, and image files.\", acceptedContentTypes: [.plainText, .pdf, .image], isTargeted: .constant(true), onDropURLs: { urls in",
                "        print(urls.count)",
                "    }, actionTitle: \"Browse\") {}",
                "    FileTokenGroup(environment: environment, items: [",
                "        .init(title: \"release-notes.md\", detail: \"18 KB\", status: .success, message: \"Uploaded successfully.\", symbol: \"doc.text\"),",
                "        .init(title: \"hero.png\", detail: \"4.2 MB\", status: .error, message: \"The file exceeds the current size limit.\", symbol: \"photo\", canRetry: true)",
                "    ])",
                "}"
            ])
        case "notice-stack":
            return code([
                "NoticeStack(environment: environment, notices: [",
                "    .init(title: \"Tokens updated\", message: \"Review the latest export before release.\", tone: .info),",
                "    .init(title: \"Contrast check passed\", message: \"Accessibility acceptance is still green.\", tone: .success)",
                "])"
            ])
        case "form":
            return code([
                "SettingsGroup(environment: environment) {",
                "    FormField(environment: environment, label: \"Project name\") {",
                "        TextInputField(environment: environment, placeholder: \"Project name\", text: $name)",
                "    }",
                "}"
            ])
        case "form-field":
            return code([
                "FormField(environment: environment, label: \"Owner\", description: \"Use a readable display name.\") {",
                "    TextInputField(environment: environment, placeholder: \"Owner\", text: $owner)",
                "}"
            ])
        case "generative-ai-components":
            return code([
                "VStack(spacing: 12) {",
                "    PromptInput(environment: environment, prompt: $prompt, actionTitle: \"Draft\", supportingText: \"Command-Return submits.\", isSubmitting: isSubmitting, isMultiline: true, submitShortcutBehavior: .commandReturn, secondaryActionTitle: \"Clear\", onSecondaryAction: {",
                "        prompt = \"\"",
                "    }) {",
                "        isSubmitting = true",
                "    }",
                "    SupportPromptGroup(environment: environment, prompts: [",
                "        .init(id: \"summarize\", title: \"Summarize\", detail: \"Condense the latest changes.\", isSelected: true, isRecommended: true),",
                "        .init(id: \"find-gaps\", title: \"Find gaps\", detail: \"Inspect missing inventory.\")",
                "    ]) { prompt in",
                "        print(prompt.id)",
                "    }",
                "    ChatBubble(environment: environment, role: .assistant, author: \"Builder assistant\", message: output, detail: \"Retry after the export job finishes.\", state: .error, onRetry: {",
                "        print(\"retry\")",
                "    })",
                "}"
            ])
        case "grid":
            return code([
                "GridLayout(environment: environment, columns: 3) {",
                "    ForEach(0..<6, id: \\.self) { index in",
                "        ContainerBox(environment: environment) { Text(\"Card \\(index + 1)\") }",
                "    }",
                "}"
            ])
        case "header":
            return code([
                "HeaderBlock(environment: environment, title: \"\(displayName)\", subtitle: \"Orient the workspace before dense detail.\")"
            ])
        case "help-panel":
            return code([
                "HelpPanel(environment: environment, title: \"\(displayName)\", topics: [",
                "    .init(id: \"context\", title: \"Current context\", detail: \"Tie guidance to the active workflow.\", symbol: \"scope\"),",
                "    .init(id: \"recovery\", title: \"Recovery\", detail: \"Name the next safe action.\", symbol: \"arrow.uturn.backward\")",
                "], selectedTopicID: .constant(\"context\")) {",
                "    BulletList(environment: environment, items: [\"Explain the current decision\", \"Keep guidance adjacent to work\"])",
                "}"
            ])
        case "context-panel":
            return code([
                "ContextPanel(environment: environment, title: \"\(displayName)\") {",
                "    BulletList(environment: environment, items: [\"Keep hierarchy calm\", \"Tie guidance to the current task\"])",
                "}"
            ])
        case "icon":
            return code([
                "PanelSurface(environment: environment, title: \"\(displayName)\") {",
                "    Image(systemName: environment.theme.icon(.navigationPrimary).symbol)",
                "        .font(environment.theme.icon(.navigationPrimary).font)",
                "        .foregroundStyle(environment.theme.color(.textPrimary))",
                "}"
            ])
        case "input":
            return code([
                "TextInputField(environment: environment, placeholder: \"Component name\", text: $text)"
            ])
        case "items-palette":
            return code([
                "ItemsPalette(environment: environment, title: \"Insert items\", items: [",
                "    .init(id: \"metric-card\", title: \"Metric card\", detail: \"Reusable dashboard tile.\"),",
                "    .init(id: \"status-list\", title: \"Status list\", detail: \"Dense collection summary.\")",
                "], selectedItemID: .constant(\"metric-card\"), insertDestinations: [",
                "    .init(title: \"Insert into Queued\", columnID: \"queued\", columnTitle: \"Queued\", index: 2)",
                "], onActivateItem: { item in",
                "    print(item.title)",
                "}, onInsertItem: { item, destinationColumnID, destinationIndex in",
                "    print(item.id, destinationColumnID, destinationIndex)",
                "})"
            ])
        case "keyvalue-pairs":
            return code([
                "KeyValuePairs(environment: environment, items: [",
                "    .init(id: \"mode\", key: \"Mode\", value: \"Compact\"),",
                "    .init(id: \"contrast\", key: \"Contrast\", value: \"Standard\")",
                "])"
            ])
        case "line-chart":
            return code([
                "LineChartPanel(environment: environment, title: \"\(displayName)\", state: .ready, series: [",
                "    .init(title: \"Coverage\", color: environment.theme.color(.chartBlue), points: [",
                "        .init(label: \"Mon\", value: 64),",
                "        .init(label: \"Tue\", value: 68),",
                "        .init(label: \"Wed\", value: 74)",
                "    ]),",
                "    .init(title: \"Adoption\", color: environment.theme.color(.chartTeal), points: [",
                "        .init(label: \"Mon\", value: 52),",
                "        .init(label: \"Tue\", value: 55),",
                "        .init(label: \"Wed\", value: 61)",
                "    ])",
                "], selection: .constant(nil), visibleSeriesIDs: .constant([\"Coverage\", \"Adoption\"]), valueFormatter: { value in \"\\(Int(value))%\" })"
            ])
        case "link":
            return code([
                "PanelSurface(environment: environment, title: \"\(displayName)\") {",
                "    Text(\"Open the canonical reference\")",
                "        .font(environment.theme.typography(.body).font)",
                "        .foregroundStyle(environment.theme.color(.accentAction))",
                "}"
            ])
        case "list":
            return code([
                "ListSurface(environment: environment, title: \"\(displayName)\", items: [\"Tokens\", \"Patterns\", \"Accessibility\"] )"
            ])
        case "live-region":
            return code([
                "LiveRegionMessage(environment: environment, message: \"\(displayName) announced that the latest validation checks passed.\")"
            ])
        case "loading-bar":
            return code([
                "LoadingBar(environment: environment, label: \"Indexing references\", detail: \"Duration is not yet known.\")"
            ])
        case "modal":
            return code([
                "ModalSurface(environment: environment, title: \"\(displayName)\") {",
                "    ValidationSummary(environment: environment, items: validationItems)",
                "} footer: {",
                "    SystemButton(environment: environment, title: \"Continue\", tone: .primary) {}",
                "}"
            ])
        case "mixed-chart":
            return code([
                "MixedChartPanel(environment: environment, title: \"\(displayName)\", state: .ready, barSeries: [",
                "    .init(title: \"Coverage\", color: environment.theme.color(.chartBlue), points: [",
                "        .init(label: \"Tokens\", value: 82),",
                "        .init(label: \"Docs\", value: 74)",
                "    ])",
                "], lineSeries: [",
                "    .init(title: \"Target\", color: environment.theme.color(.chartTeal), points: [",
                "        .init(label: \"Tokens\", value: 90),",
                "        .init(label: \"Docs\", value: 85)",
                "    ])",
                "], selection: .constant(nil), visibleSeriesIDs: .constant([\"Coverage\", \"Target\"]), valueFormatter: { value in \"\\(Int(value))%\" })"
            ])
        case "multiselect":
            return code([
                "MultiselectMenu(environment: environment, options: [",
                "    .init(label: \"Foundations\", value: \"foundations\"),",
                "    .init(label: \"Components\", value: \"components\"),",
                "    .init(label: \"Patterns\", value: \"patterns\")",
                "], selection: $selection)"
            ])
        case "pagination":
            return code([
                "PaginationControl(environment: environment, currentPage: $page, pageCount: 12)"
            ])
        case "panel-layout":
            return code([
                "PanelLayout(environment: environment, title: \"\(displayName)\", subtitle: \"Group related content before reaching for new chrome.\") {",
                "    TextContentBlock(environment: environment, title: \"Guidance\", body: \"Keep supporting detail aligned to the main task.\")",
                "}"
            ])
        case "popover":
            return code([
                "PopoverSurface(environment: environment, title: \"\(displayName)\") {",
                "    Text(\"Use popovers for lightweight contextual guidance.\")",
                "}"
            ])
        case "progress-bar":
            return code([
                "ProgressBar(environment: environment, value: 0.72, label: \"Publishing docs\")"
            ])
        case "prompt-input":
            return code([
                "PromptInput(environment: environment, prompt: $prompt, actionTitle: \"Draft\", supportingText: \"Command-Return submits.\", isSubmitting: isSubmitting, isMultiline: true, submitShortcutBehavior: .commandReturn, secondaryActionTitle: \"Clear\", onSecondaryAction: {",
                "    prompt = \"\"",
                "}) {",
                "    isSubmitting = true",
                "}"
            ])
        case "property-filter":
            return code([
                "PropertyFilterBar(environment: environment, filters: filters, selection: $activeFilters)"
            ])
        case "radio-group":
            return code([
                "RadioGroup(environment: environment, title: \"Mode\", options: [",
                "    .init(label: \"Automatic\", value: \"automatic\"),",
                "    .init(label: \"Manual\", value: \"manual\")",
                "], selection: $selection)"
            ])
        case "resource-selector":
            return code([
                "ResourceSelector(environment: environment, resources: [\"Design system\", \"Showcase\"], selection: $selectedResourceID)"
            ])
        case "segmented-control":
            return code([
                "SegmentedPicker(environment: environment, options: [(\"Compact\", 0), (\"Default\", 1), (\"Comfortable\", 2)], selection: $selection)"
            ])
        case "side-navigation":
            return code([
                "NavigationSidebarList(environment: environment, sections: sections, selection: $route) { item, isSelected in",
                "    SidebarRow(environment: environment, title: item.title, symbol: item.symbol ?? \"circle\", isSelected: isSelected)",
                "}"
            ])
        case "slider":
            return code([
                "SliderField(environment: environment, title: \"Radius\", value: $radius, range: 0...24)"
            ])
        case "space-between":
            return code([
                "SpaceBetween {",
                "    Text(\"\(displayName)\")",
                "    TokenBadge(environment: environment, label: \"Compact\")",
                "}"
            ])
        case "spinner":
            return code([
                "LoadingSpinner(environment: environment, label: \"Refreshing metrics\")"
            ])
        case "split-panel":
            return code([
                "SplitPanel(environment: environment) {",
                "    PanelSurface(environment: environment, title: \"Primary\") { Text(\"Main workspace\") }",
                "} secondary: {",
                "    ContextPanel(environment: environment, title: \"Inspector\") { Text(\"Selection details\") }",
                "}"
            ])
        case "status-indicator":
            return code([
                "StatusIndicator(environment: environment, label: \"Ready\", detail: \"All checks passed.\", tone: .success)"
            ])
        case "steps":
            return code([
                "StepsView(environment: environment, steps: [",
                "    .init(id: \"audit\", title: \"Audit\", detail: \"Review the API and states.\", status: .complete),",
                "    .init(id: \"verify\", title: \"Verify\", detail: \"Run tests and inspect the showcase.\", status: .current),",
                "    .init(id: \"ship\", title: \"Ship\", detail: \"Publish the updated docs.\", status: .warning, isOptional: true)",
                "])"
            ])
        case "support-prompt-group":
            return code([
                "SupportPromptGroup(environment: environment, prompts: [",
                "    .init(id: \"summarize\", title: \"Summarize\", detail: \"Condense the latest changes.\", isSelected: true, isRecommended: true),",
                "    .init(id: \"find-gaps\", title: \"Find gaps\", detail: \"Inspect missing inventory.\"),",
                "    .init(id: \"compare\", title: \"Explain tradeoffs\", detail: \"Compare candidate APIs.\", isEnabled: false)",
                "]) { prompt in",
                "    print(prompt.title)",
                "}"
            ])
        case "table":
            return code([
                "DataTable(environment: environment, columns: [",
                "    .init(title: \"Area\"),",
                "    .init(title: \"Status\")",
                "], rows: [",
                "    .init(id: \"tokens\", cells: [\"Tokens\", \"Ready\"]),",
                "    .init(id: \"docs\", cells: [\"Docs\", \"Needs review\"])",
                "], selectedRowID: $selectedRowID)"
            ])
        case "tabs":
            return code([
                "Tabs(environment: environment, items: [",
                "    .init(title: \"Overview\", value: \"overview\"),",
                "    .init(title: \"Tokens\", value: \"tokens\"),",
                "    .init(title: \"Notes\", value: \"notes\")",
                "], selection: $tab)"
            ])
        case "tag-editor":
            return code([
                "TagEditor(environment: environment, title: \"Release tags\", tags: $tags)"
            ])
        case "text-content":
            return code([
                "TextContentBlock(environment: environment, title: \"\(displayName)\", body: \"Use content blocks for editorial guidance inside grouped surfaces.\")"
            ])
        case "text-filter":
            return code([
                "TextFilterField(environment: environment, placeholder: \"Filter components\", text: $query)"
            ])
        case "text-area":
            return code([
                "TextAreaField(environment: environment, placeholder: \"Write a rollout note\", text: $note)"
            ])
        case "tiles":
            return code([
                "TilePicker(environment: environment, title: \"\(displayName)\", options: [",
                "    .init(label: \"Compact\", value: \"compact\"),",
                "    .init(label: \"Default\", value: \"default\")",
                "], selection: $selection)"
            ])
        case "time-input":
            return code([
                "TimeField(environment: environment, label: \"Publish time\", value: $time)"
            ])
        case "toggle":
            return code([
                "ToggleSwitch(environment: environment, title: \"Enable native navigation\", isOn: $isEnabled)"
            ])
        case "toggle-button":
            return code([
                "ToggleButton(environment: environment, title: \"Show inspector\", isOn: $isEnabled)"
            ])
        case "token":
            return code([
                "TokenBadge(environment: environment, label: \"accentAction\")"
            ])
        case "token-group":
            return code([
                "TokenGroup(environment: environment, tokens: [\"bg.sidebar\", \"surface.grouped\", \"text.primary\"])"
            ])
        case "top-navigation":
            return code([
                "TopNavigationBar(environment: environment) {",
                "    BreadcrumbGroup(environment: environment, items: [.init(title: \"Library\"), .init(title: \"\(displayName)\", isCurrent: true)])",
                "} trailing: {",
                "    ToolbarButton(environment: environment, title: \"Inspect\", symbol: \"sidebar.right\") {}",
                "}"
            ])
        case "tree-view":
            return code([
                "TreeView(environment: environment, nodes: [",
                "    .init(id: \"foundations\", title: \"Foundations\", children: [.init(id: \"color\", title: \"Color\"), .init(id: \"motion\", title: \"Motion\")]),",
                "    .init(id: \"components\", title: \"Components\")",
                "], selection: $selection)"
            ])
        case "tutorial-components":
            return code([
                "WizardLayout(environment: environment, title: \"\(displayName)\", steps: steps, currentStepID: \"audit\") {",
                "    TutorialPanel(environment: environment, title: \"Rollout guidance\", steps: steps, currentStepID: $currentStepID, completedStepIDs: [\"audit\"]) {",
                "        Text(\"Keep progression visible inside the same shell language.\")",
                "    } primaryActions: {",
                "        SystemButton(environment: environment, title: \"Continue\", tone: .primary) {}",
                "    } secondaryActions: {",
                "        SystemButton(environment: environment, title: \"Back\", tone: .secondary) {}",
                "    }",
                "}"
            ])
        case "tutorial-panel":
            return code([
                "TutorialPanel(environment: environment, title: \"\(displayName)\", steps: steps, currentStepID: $currentStepID, completedStepIDs: [\"audit\"], stepChangeAnnouncement: { step, index, total in",
                "    \"Tutorial progress updated. Step \\(index) of \\(total): \\(step.title).\"",
                "}) {",
                "    Text(\"Keep progression visible inside the current workflow.\")",
                "} primaryActions: {",
                "    SystemButton(environment: environment, title: \"Continue\", tone: .primary) {}",
                "} secondaryActions: {",
                "    SystemButton(environment: environment, title: \"Back\", tone: .secondary) {}",
                "}"
            ])
        case "wizard":
            return code([
                "WizardLayout(environment: environment, title: \"\(displayName)\", steps: steps, currentStepID: \"tokens\") {",
                "    Text(\"Guide the team through the rollout in one consistent shell.\")",
                "}"
            ])
        default:
            return nil
        }
    }

    private static func patternCode(for id: PatternExampleID, displayName: String) -> String? {
        switch id.rawValue {
        case "general":
            return code([
                "PanelSurface(environment: environment, title: \"\(displayName)\") {",
                "    ValidationSummary(environment: environment, items: validationItems)",
                "    SystemButton(environment: environment, title: \"Continue\", tone: .primary) {}",
                "}"
            ])
        case "actions":
            return code([
                "ButtonGroup(environment: environment, options: [",
                "    .init(label: \"Preview\", value: \"preview\"),",
                "    .init(label: \"Publish\", value: \"publish\")",
                "], selection: $selection)"
            ])
        case "announcing-new-features":
            return code([
                "NoticeStack(environment: environment, notices: [",
                "    .init(title: \"New workflow\", message: \"Open Recipes to inspect the latest example-backed patterns.\", tone: .info)",
                "])"
            ])
        case "announcing-beta-and-preview-features":
            return code([
                "NoticeStack(environment: environment, notices: [",
                "    .init(title: \"Preview feature\", message: \"Enable it for testing before broad rollout.\", tone: .warning)",
                "])",
                "StatusBadge(environment: environment, label: \"Preview\", tone: .warning)"
            ])
        case "communicating-unsaved-changes":
            return code([
                "ModalSurface(environment: environment, title: \"Leave without saving\") {",
                "    AlertBanner(environment: environment, title: \"Unsaved changes\", message: \"Save or discard before leaving.\", tone: .warning) {}",
                "} footer: {",
                "    ButtonGroup(environment: environment, options: [.init(label: \"Save\", value: \"save\"), .init(label: \"Discard\", value: \"discard\")], selection: $decision)",
                "}"
            ])
        case "data-visualization":
            return code([
                "VStack(spacing: 16) {",
                "    MixedChartPanel(environment: environment, title: \"Coverage and adoption\", state: .ready, barSeries: coverageSeries, lineSeries: adoptionSeries, selection: $selection, visibleSeriesIDs: $visibleSeriesIDs, valueFormatter: { value in \"\\(Int(value))%\" })",
                "    KeyValuePairs(environment: environment, pairs: metricPairs)",
                "    DataTable(environment: environment, columns: columns, rows: rows, selectedRowID: $selectedRowID)",
                "}"
            ])
        case "density-settings":
            return code([
                "SettingsGroup(environment: environment) {",
                "    SettingsRow(environment: environment, title: \"Density\", detail: \"Adjust shell rhythm\") {",
                "        SegmentedPicker(environment: environment, options: [(\"Compact\", 0), (\"Default\", 1), (\"Comfortable\", 2)], selection: $density)",
                "    }",
                "}"
            ])
        case "disabled-and-readonly-states":
            return code([
                "VStack(spacing: 14) {",
                "    TextInputField(environment: environment, placeholder: \"Project name\", text: $name, status: .error, message: \"Provide a readable name.\")",
                "    ReadOnlyField(environment: environment, label: \"Owner\", value: \"Platform Design\")",
                "}"
            ])
        case "draganddrop":
            return code([
                "VStack(alignment: .leading, spacing: 16) {",
                "    FileUploadField(environment: environment, title: \"Drop release notes\", subtitle: \"Provide a visible target, item state, and keyboard fallback.\", items: [",
                "        .init(title: \"release-notes.md\", detail: \"18 KB\", status: .success, message: \"Uploaded successfully.\", symbol: \"doc.text\")",
                "    ], onPick: {})",
                "    HStack(alignment: .top, spacing: 16) {",
                "        Board(environment: environment, columns: [",
                "            .init(id: \"incoming\", title: \"Incoming\", items: [.init(id: \"review-docs\", title: \"Review docs\", detail: \"Match snippets to the real API.\", status: \"Review\", statusColor: environment.theme.color(.warning))]),",
                "            .init(id: \"ready\", title: \"Ready\", items: [.init(title: \"Publish catalog\", detail: \"Regenerate docs and examples.\", status: \"Queued\", statusColor: environment.theme.color(.info))])",
                "        ], selectedItemID: .constant(\"review-docs\"), onMoveItem: { itemID, destinationColumnID, destinationIndex in",
                "            print(itemID, destinationColumnID, destinationIndex)",
                "        })",
                "        ItemsPalette(environment: environment, items: [.init(id: \"metric-card\", title: \"Metric card\", detail: \"Reusable dashboard tile.\")], insertDestinations: [",
                "            .init(title: \"Insert into Incoming\", columnID: \"incoming\", columnTitle: \"Incoming\", index: 1)",
                "        ], onInsertItem: { item, destinationColumnID, destinationIndex in",
                "            print(item.id, destinationColumnID, destinationIndex)",
                "        })",
                "    }",
                "}"
            ])
        case "errors":
            return code([
                "VStack(spacing: 14) {",
                "    AlertBanner(environment: environment, title: \"Validation failed\", message: \"Resolve field issues before publishing.\", tone: .danger) {}",
                "    ErrorStateView(environment: environment, title: \"Preview unavailable\", message: \"Retry after restoring the connection.\", actionTitle: \"Retry\") {}",
                "}"
            ])
        case "empty-states":
            return code([
                "EmptyStateView(environment: environment, title: \"Nothing matches the current filter\", message: \"Clear filters or broaden the search.\")",
                "SystemButton(environment: environment, title: \"Reset filters\", tone: .secondary) {}"
            ])
        case "feedback-mechanisms":
            return code([
                "VStack(spacing: 12) {",
                "    NoticeStack(environment: environment, notices: notices)",
                "    StatusIndicator(environment: environment, label: \"Saved\", detail: \"All token updates were exported.\", tone: .success)",
                "}"
            ])
        case "filtering-patterns":
            return code([
                "PropertyFilterBar(environment: environment, filters: filters, selection: $selection)",
                "SearchResultsOverlay(environment: environment, sections: sections) { item in",
                "    print(item.title)",
                "}"
            ])
        case "hero-header":
            return code([
                "HeaderBlock(environment: environment, title: \"\(displayName)\", subtitle: \"Orient the workspace and present one clear next step.\")",
                "SystemButton(environment: environment, title: \"Browse components\", tone: .primary) {}"
            ])
        case "help-system":
            return code([
                "HelpPanel(environment: environment, title: \"Help\", topics: [",
                "    .init(id: \"context\", title: \"Current context\", detail: \"Tie guidance to the active workflow.\"),",
                "    .init(id: \"recovery\", title: \"Recovery\", detail: \"Name the next safe action.\")",
                "], selectedTopicID: .constant(\"context\")) {",
                "    BulletList(environment: environment, items: [\"Explain the current decision\", \"Keep guidance adjacent to work\"])",
                "}"
            ])
        case "image-magnifier":
            return code([
                "PopoverSurface(environment: environment, title: \"Zoomed preview\") {",
                "    Text(\"Magnified asset detail stays adjacent to the current workspace.\")",
                "}"
            ])
        case "loading-and-refreshing":
            return code([
                "VStack(spacing: 12) {",
                "    LoadingSpinner(environment: environment, label: \"Refreshing metrics\")",
                "    LoadingBar(environment: environment, label: \"Indexing references\", detail: \"Duration is not yet known.\")",
                "    ProgressBar(environment: environment, value: 0.64, label: \"Publishing docs\")",
                "    StatusIndicator(environment: environment, label: \"Refresh in progress\", tone: .info)",
                "}"
            ])
        case "onboarding":
            return code([
                "WizardLayout(environment: environment, title: \"Team onboarding\", steps: steps, currentStepID: \"review\") {",
                "    TutorialPanel(environment: environment, title: \"Rollout guidance\", steps: steps, currentStepID: $currentStepID, completedStepIDs: [\"choose\"]) {",
                "        Text(\"Keep the next action obvious.\")",
                "    } primaryActions: {",
                "        SystemButton(environment: environment, title: \"Continue\", tone: .primary) {}",
                "    } secondaryActions: {",
                "        SystemButton(environment: environment, title: \"Back\", tone: .secondary) {}",
                "    }",
                "}"
            ])
        case "selection-in-forms":
            return code([
                "SettingsGroup(environment: environment) {",
                "    SettingsRow(environment: environment, title: \"Notifications\", detail: \"Choose how updates are delivered.\") {",
                "        RadioGroup(environment: environment, title: \"Delivery\", options: options, selection: $selection)",
                "    }",
                "    SettingsRow(environment: environment, title: \"Release notes\", detail: \"Toggle summary emails.\") {",
                "        Checkbox(environment: environment, title: \"Email weekly recap\", isOn: $isEnabled)",
                "    }",
                "}"
            ])
        case "workspace-navigation":
            return code([
                "AppLayout(environment: environment, sidebarWidth: 240) {",
                "    NavigationSidebarList(environment: environment, sections: sections, selection: $route) { item, isSelected in",
                "        SidebarRow(environment: environment, title: item.title, symbol: item.symbol ?? \"circle\", isSelected: isSelected)",
                "    }",
                "} content: {",
                "    SplitPanel(environment: environment) {",
                "        PanelSurface(environment: environment, title: \"Workspace\") { Text(\"Current route\") }",
                "    } secondary: {",
                "        ContextPanel(environment: environment, title: \"Inspector\") { Text(\"Selection details\") }",
                "    }",
                "}"
            ])
        case "workspace-dashboard":
            return code([
                "VStack(spacing: 16) {",
                "    StatusIndicator(environment: environment, label: \"Release candidate\", detail: \"Ready for review.\", tone: .success)",
                "    MixedChartPanel(environment: environment, title: \"Coverage\", state: .ready, barSeries: barSeries, lineSeries: lineSeries, selection: $selection, visibleSeriesIDs: $visibleSeriesIDs, valueFormatter: { value in \"\\(Int(value))%\" })",
                "    DataTable(environment: environment, columns: columns, rows: rows, selectedRowID: $selectedRowID)",
                "}"
            ])
        case "secondary-panels":
            return code([
                "SplitPanel(environment: environment) {",
                "    PanelSurface(environment: environment, title: \"Main workspace\") { Text(\"Editing surface\") }",
                "} secondary: {",
                "    ContextPanel(environment: environment, title: \"Inspector\") {",
                "        BulletList(environment: environment, items: [\"Tokens in use\", \"Accessibility notes\", \"Related patterns\"])",
                "    }",
                "}"
            ])
        case "timestamps":
            return code([
                "VStack(spacing: 12) {",
                "    LiveRegionMessage(environment: environment, message: \"Updated 2 hours ago\")",
                "    StatusIndicator(environment: environment, label: \"Last published\", detail: \"Today at 14:20\", tone: .info)",
                "}"
            ])
        case "user-feedback":
            return code([
                "VStack(spacing: 14) {",
                "    AlertBanner(environment: environment, title: \"Feedback sent\", message: \"The design-system team received your notes.\", tone: .success) {}",
                "    ValidationSummary(environment: environment, items: feedbackItems)",
                "}"
            ])
        default:
            return nil
        }
    }

    private static func code(_ lines: [String]) -> String {
        (["let environment = DesignSystemEnvironment.preview(.dark)", ""] + lines).joined(separator: "\n")
    }
}
