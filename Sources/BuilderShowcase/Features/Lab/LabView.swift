import SwiftUI
import BuilderDesignSystem
import BuilderReferenceExamples

struct LabView: View {
    let env: DesignSystemEnvironment
    @EnvironmentObject private var model: ShowcaseModel

    @State private var preset: LabPreset = .settingsForm
    @State private var showNotice = true
    @State private var showInspector = true
    @State private var showOverlay = false
    @State private var showSidebar = true
    @State private var selectedRowID: String? = "tokens"
    @State private var activeStepID = "Tune"
    @State private var projectName = "Builder Showcase"

    private let inspectorWidth: CGFloat = 360
    private var inspectorContentWidth: CGFloat { inspectorWidth - 44 }

    var body: some View {
        VStack(spacing: 0) {
            ShowcaseRouteHeader(
                environment: env,
                eyebrow: "Lab",
                title: "Prototype product surfaces with live system controls",
                subtitle: "Switch presets, tune shell settings, and test how components behave together before you codify a workflow."
            ) {
                HStack(spacing: 10) {
                    SelectMenu(
                        environment: env,
                        options: LabPreset.allCases.map { .init(label: $0.title, value: $0) },
                        selection: $preset,
                        leadingSymbol: "square.stack.3d.up",
                        width: 200
                    )
                    SystemButton(
                        environment: env,
                        title: showInspector ? "Hide inspector" : "Show inspector",
                        tone: .secondary,
                        leadingSymbol: "sidebar.right"
                    ) {
                        showInspector.toggle()
                    }
                    SystemButton(environment: env, title: "Reset", tone: .secondary, leadingSymbol: "arrow.counterclockwise") {
                        reset()
                    }
                }
            }

            Rectangle()
                .fill(env.theme.color(.subtleBorder))
                .frame(height: 1)

            HStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        PreviewCanvasFrame(environment: labEnvironment) {
                            ZStack(alignment: .topTrailing) {
                                labPresetCanvas

                                if showOverlay {
                                    overlayPreview
                                        .padding(16)
                                }
                            }
                        }
                    }
                    .padding(28)
                }

                if showInspector {
                    Rectangle()
                        .fill(env.theme.color(.subtleBorder))
                        .frame(width: 1)

                    inspector
                }
            }
        }
        .onAppear(perform: syncPresetFromSearch)
        .onChange(of: model.searchText) { _, _ in
            syncPresetFromSearch()
        }
    }

    private var labEnvironment: DesignSystemEnvironment {
        DesignSystemEnvironment(
            theme: AppTheme(mode: model.themeMode, contrast: model.effectiveContrast),
            mode: model.themeMode,
            contrast: model.effectiveContrast,
            density: model.densityMode,
            visualContext: preset.visualContext,
            reduceMotion: model.reduceMotion,
            highContrast: model.highContrast
        )
    }

    @ViewBuilder
    private var labPresetCanvas: some View {
        switch preset {
        case .settingsForm:
            SettingsGroup(environment: labEnvironment) {
                SettingsRow(environment: labEnvironment, title: "Workspace name", detail: "Keep the current workspace identifiable across the product") {
                    TextInputField(environment: labEnvironment, placeholder: "Workspace name", text: $projectName, width: 240, height: 36)
                }
                divider
                SettingsRow(environment: labEnvironment, title: "Theme mode", detail: "Change shell surfaces without breaking control contrast") {
                    SegmentedPicker(
                        environment: labEnvironment,
                        options: ThemeMode.allCases.map { ($0.title, $0) },
                        selection: $model.themeMode,
                        style: .neutral
                    )
                    .frame(width: 220)
                }
                divider
                SettingsRow(environment: labEnvironment, title: "Density", detail: "Keep row height and whitespace in sync across the system") {
                    SegmentedPicker(
                        environment: labEnvironment,
                        options: DensityMode.allCases.map { ($0.title, $0) },
                        selection: $model.densityMode,
                        style: .neutral
                    )
                    .frame(width: 300)
                }
                divider
                SettingsRow(environment: labEnvironment, title: "Persistent notices", detail: "Test whether inline status keeps the workflow oriented") {
                    Toggle("", isOn: $showNotice)
                        .labelsHidden()
                }
            }
        case .dataExplorer:
            VStack(alignment: .leading, spacing: 16) {
                if showNotice {
                    AlertBanner(environment: labEnvironment, title: "Review in progress", message: "Filters, charts, and tables should keep their hierarchy even as data changes.", tone: .info)
                }

                HStack(spacing: 12) {
                    TextInputField(environment: labEnvironment, placeholder: "Filter components", text: .constant(""), leadingSymbol: "magnifyingglass")
                    SelectMenu(
                        environment: labEnvironment,
                        options: [
                            .init(label: "All statuses", value: "all"),
                            .init(label: "Ready", value: "ready"),
                            .init(label: "Pending", value: "pending")
                        ],
                        selection: .constant("all"),
                        width: 160
                    )
                }

                DataTable(
                    environment: labEnvironment,
                    columns: [
                        .init(title: "Surface"),
                        .init(title: "Owner"),
                        .init(title: "Status"),
                        .init(title: "Updated")
                    ],
                    rows: [
                        .init(id: "tokens", cells: ["Theme tokens", "Design systems", "Ready", "Now"]),
                        .init(id: "settings", cells: ["Settings form", "Product design", "Review", "3h"]),
                        .init(id: "nav", cells: ["Navigation shell", "Platform", "Pending", "1d"])
                    ],
                    selectedRowID: $selectedRowID
                )
            }
        case .editorWorkspace:
            AppLayout(environment: labEnvironment, sidebarWidth: showSidebar ? 220 : 0) {
                if showSidebar {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(["Home", "Components", "Recipes", "Foundations"], id: \.self) { item in
                            SidebarRow(environment: labEnvironment, title: item, symbol: "square.grid.2x2", isSelected: item == "Components")
                        }
                    }
                    .padding(18)
                }
            } content: {
                VStack(alignment: .leading, spacing: 14) {
                    HeaderBlock(environment: labEnvironment, title: "Editor workspace", subtitle: "Exercise code, content, and review controls inside the same shell.") {
                        HStack(spacing: 10) {
                            ToolbarButton(environment: labEnvironment, title: "Review", symbol: "checkmark.circle") {}
                            ToolbarButton(environment: labEnvironment, title: "Share", symbol: "square.and.arrow.up") {}
                        }
                    }
                    CodeEditorSurface(environment: labEnvironment, code: .constant("let system = BuilderDesignSystem()"))
                        .frame(height: 240)
                }
                .padding(18)
            }
        case .onboardingFlow:
            VStack(alignment: .leading, spacing: 18) {
                StepsView(
                    environment: labEnvironment,
                    steps: [.init(title: "Choose"), .init(title: "Tune"), .init(title: "Validate")],
                    currentStepID: activeStepID
                )
                WizardLayout(
                    environment: labEnvironment,
                    title: "Guide a team into the system",
                    steps: [.init(title: "Choose"), .init(title: "Tune"), .init(title: "Validate")],
                    currentStepID: activeStepID
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Onboarding should use the same surfaces and tone as the rest of the product.")
                            .foregroundStyle(labEnvironment.theme.color(.textSecondary))
                        HStack(spacing: 10) {
                            SystemButton(environment: labEnvironment, title: "Back", tone: .secondary) {
                                activeStepID = "Choose"
                            }
                            SystemButton(environment: labEnvironment, title: "Continue", tone: .primary) {
                                activeStepID = "Validate"
                            }
                        }
                    }
                }
            }
        case .contentReview:
            VStack(alignment: .leading, spacing: 14) {
                NoticeStack(environment: labEnvironment, notices: [
                    .init(title: "Ready for review", message: "Content surfaces and status patterns are aligned.", tone: .success),
                    .init(title: "Needs input", message: "Double-check whether the selected copy works in compact density.", tone: .warning)
                ])
                HStack(spacing: 12) {
                    SystemButton(environment: labEnvironment, title: "Approve", tone: .primary) {}
                    SystemButton(environment: labEnvironment, title: "Request changes", tone: .secondary) {}
                }
                CardGrid(environment: labEnvironment, data: reviewCards) { card in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(card.title)
                            .font(labEnvironment.theme.typography(.labelStrong).font)
                        Text(card.detail)
                            .font(labEnvironment.theme.typography(.body).font)
                            .foregroundStyle(labEnvironment.theme.color(.textSecondary))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    private var inspector: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                ShowcaseInspectorSection(environment: env, title: "Preset", subtitle: preset.subtitle) {
                    VStack(alignment: .leading, spacing: 12) {
                        ToggleSwitch(environment: env, title: "Show notices", isOn: $showNotice)
                        ToggleSwitch(environment: env, title: "Show overlay", isOn: $showOverlay)
                        ToggleSwitch(environment: env, title: "Show sidebar", isOn: $showSidebar)
                    }
                }

                Divider()
                    .overlay(env.theme.color(.subtleBorder))

                ShowcaseInspectorSection(environment: env, title: "Global environment") {
                    VStack(alignment: .leading, spacing: 12) {
                        SegmentedPicker(
                            environment: env,
                            options: ThemeMode.allCases.map { ($0.title, $0) },
                            selection: $model.themeMode,
                            style: .neutral
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)

                        SegmentedPicker(
                            environment: env,
                            options: DensityMode.allCases.map { ($0.title, $0) },
                            selection: $model.densityMode,
                            style: .neutral
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                Divider()
                    .overlay(env.theme.color(.subtleBorder))

                ShowcaseInspectorSection(environment: env, title: "Reference recipe", subtitle: "This lab preset stays anchored to a shared pattern example.") {
                    BuilderReferenceExamples.patternPreview(
                        id: referencePatternID,
                        displayName: referencePatternName,
                        family: referencePatternFamily,
                        environment: env
                    )
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Divider()
                    .overlay(env.theme.color(.subtleBorder))

                ShowcaseInspectorSection(environment: env, title: "Design checks") {
                    BulletList(environment: env, items: [
                        "Preserve one dominant workspace and keep secondary panels optional.",
                        "Ensure the current preset still feels coherent in both light and dark mode.",
                        "Test full-hit-target interactions before trusting the surface."
                    ])
                }
            }
            .frame(width: inspectorContentWidth, alignment: .topLeading)
            .padding(22)
        }
        .frame(width: inspectorWidth, alignment: .topLeading)
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .background(env.theme.color(.groupedSurface))
    }

    private var overlayPreview: some View {
        PopoverSurface(environment: labEnvironment, title: "Quick review") {
            VStack(alignment: .leading, spacing: 10) {
                Text("Overlays should feel related to the canvas without taking over the shell.")
                    .font(labEnvironment.theme.typography(.body).font)
                    .foregroundStyle(labEnvironment.theme.color(.textSecondary))
                SystemButton(environment: labEnvironment, title: "Dismiss", tone: .secondary) {
                    showOverlay = false
                }
            }
        }
        .frame(width: 280)
    }

    private var reviewCards: [ReviewCard] {
        [
            .init(id: "a", title: "Review shell", detail: "Check layout hierarchy, emphasis, and click targets."),
            .init(id: "b", title: "Review data", detail: "Verify rows, labels, and states in compact density."),
            .init(id: "c", title: "Review feedback", detail: "Make sure notices and alerts stay helpful rather than loud.")
        ]
    }

    private var divider: some View {
        Rectangle()
            .fill(labEnvironment.theme.color(.subtleBorder))
            .frame(height: 1)
    }

    private var referencePatternID: PatternExampleID {
        switch preset {
        case .settingsForm:
            .init(rawValue: "density-settings")
        case .dataExplorer:
            .init(rawValue: "data-visualization")
        case .editorWorkspace:
            .init(rawValue: "workspace-navigation")
        case .onboardingFlow:
            .init(rawValue: "onboarding")
        case .contentReview:
            .init(rawValue: "user-feedback")
        }
    }

    private var referencePatternName: String {
        switch preset {
        case .settingsForm:
            "Density settings"
        case .dataExplorer:
            "Data visualization"
        case .editorWorkspace:
            "Workspace navigation"
        case .onboardingFlow:
            "Onboarding"
        case .contentReview:
            "User feedback"
        }
    }

    private var referencePatternFamily: PatternExampleFamily {
        switch preset {
        case .settingsForm:
            .density
        case .dataExplorer:
            .dataVisualization
        case .editorWorkspace:
            .navigation
        case .onboardingFlow:
            .onboarding
        case .contentReview:
            .timeAndFeedback
        }
    }

    private func reset() {
        showNotice = true
        showInspector = true
        showOverlay = false
        showSidebar = true
        selectedRowID = "tokens"
        activeStepID = "Tune"
        projectName = "Builder Showcase"
    }

    private func syncPresetFromSearch() {
        guard let matched = LabPreset.allCases.first(where: { $0.title.localizedCaseInsensitiveContains(model.searchText) }) else {
            return
        }
        preset = matched
    }
}

private struct ReviewCard: Identifiable {
    let id: String
    let title: String
    let detail: String
}
