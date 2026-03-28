import SwiftUI
import BuilderDesignSystem

struct SettingsCatalogView: View {
    let env: DesignSystemEnvironment
    @EnvironmentObject private var model: ShowcaseModel

    var body: some View {
        VStack(spacing: 0) {
            ShowcaseRouteHeader(
                environment: env,
                eyebrow: "Settings",
                title: "Tune the system without leaving the product",
                subtitle: "Appearance, accessibility, and theme inspection live together so builders can verify the same surfaces they are actively shaping."
            ) {
                TokenBadge(environment: env, title: model.selectedSettingsSection.title, tint: env.theme.color(.accentPrimary))
            }

            Rectangle()
                .fill(env.theme.color(.subtleBorder))
                .frame(height: 1)

            HStack(spacing: 0) {
                settingsMenu

                Rectangle()
                    .fill(env.theme.color(.subtleBorder))
                    .frame(width: 1)

                settingsDetail
            }
        }
    }

    private var settingsMenu: some View {
        return NavigationSidebarList(
            environment: env,
            sections: settingsSections,
            selection: $model.selectedSettingsSection,
            rowHeight: 44,
            sectionHeaderHeight: 28
        ) { item, isSelected in
            SidebarRow(
                environment: env,
                title: item.title,
                symbol: item.symbol ?? "gearshape",
                isSelected: isSelected
            )
        }
        .padding(20)
        .frame(width: 252)
        .background(env.theme.color(.workspaceBackground))
    }

    @ViewBuilder
    private var settingsDetail: some View {
        switch model.selectedSettingsSection {
        case .appearance:
            appearanceDetail
        case .accessibility:
            accessibilityDetail
        case .themeTokens:
            WorkbenchView(env: env)
        }
    }

    private var appearanceDetail: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                PanelSurface(environment: env, title: "Appearance", subtitle: "Tune the shell and working surfaces the same way a product team would tune a real desktop tool.") {
                    SettingsGroup(environment: env) {
                        SettingsRow(environment: env, title: "Theme mode", detail: "Sets the active visual mode for the shell and all connected surfaces") {
                            SegmentedPicker(
                                environment: env,
                                options: ThemeMode.allCases.map { (label: $0.title, value: $0) },
                                selection: $model.themeMode,
                                style: .neutral
                            )
                            .frame(width: 220)
                        }
                        rowDivider
                        SettingsRow(environment: env, title: "Density", detail: "Changes spacing, row heights, and grouped panel rhythm across the showcase") {
                            SegmentedPicker(
                                environment: env,
                                options: DensityMode.allCases.map { (label: $0.title, value: $0) },
                                selection: $model.densityMode,
                                style: .neutral
                            )
                            .frame(width: 300)
                        }
                        rowDivider
                        SettingsRow(environment: env, title: "Contrast", detail: "Increases supporting-text and border legibility without redesigning the layout") {
                            SegmentedPicker(
                                environment: env,
                                options: ThemeContrast.allCases.map { (label: $0.title, value: $0) },
                                selection: $model.themeContrast,
                                style: .neutral
                            )
                            .frame(width: 220)
                        }
                    }
                }

                PanelSurface(environment: env, title: "Light and dark parity", subtitle: "Both modes should feel like siblings instead of separate products.") {
                    BulletList(environment: env, items: [
                        "Keep light mode soft and warm rather than stark white.",
                        "Keep the dark shell low-chrome and graphite rather than blue-heavy.",
                        "Let spacing and typography carry hierarchy before adding new containers."
                    ])
                }
            }
            .padding(24)
        }
    }

    private var accessibilityDetail: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                PanelSurface(environment: env, title: "Accessibility", subtitle: "Interaction comfort and assistive behavior sit beside appearance controls so both can be verified together.") {
                    SettingsGroup(environment: env) {
                        SettingsRow(environment: env, title: "Reduced motion", detail: "Minimizes animated transitions across route changes and state updates") {
                            Toggle("", isOn: $model.reduceMotion)
                                .labelsHidden()
                                .toggleStyle(.switch)
                        }
                        rowDivider
                        SettingsRow(environment: env, title: "High contrast", detail: "Raises legibility for muted labels, borders, and supporting copy") {
                            Toggle("", isOn: $model.highContrast)
                                .labelsHidden()
                                .toggleStyle(.switch)
                        }
                    }
                }

                PanelSurface(environment: env, title: "Focus and disabled states", subtitle: "State changes remain visible without breaking the shell.") {
                    VStack(alignment: .leading, spacing: 16) {
                        focusRow(label: "Focused field", border: env.theme.color(.focusRing), opacity: 1.0)
                        focusRow(label: "Read-only field", border: env.theme.color(.subtleBorder), opacity: 0.9)
                        focusRow(label: "Disabled field", border: env.theme.color(.subtleBorder), opacity: 0.55)
                    }
                }

                PanelSurface(environment: env, title: "Keyboard & VoiceOver notes", subtitle: "Operational UI should be understandable by scanning labels, values, and focus order alone.") {
                    BulletList(environment: env, items: [
                        "Toolbar controls, navigation rows, and settings controls should follow a stable left-to-right, top-to-bottom order.",
                        "Status changes should be announced through live-region patterns or persistent inline messaging when important.",
                        "Chart and table examples should expose textual summaries so color is not the only cue."
                    ])
                }
            }
            .padding(24)
        }
    }

    private var rowDivider: some View {
        Rectangle()
            .fill(env.theme.color(.subtleBorder))
            .frame(height: 1)
    }

    private func focusRow(label: String, border: Color, opacity: Double) -> some View {
        RoundedRectangle(cornerRadius: env.theme.radius(.large), style: .continuous)
            .fill(env.theme.color(.inputSurface).opacity(opacity))
            .frame(height: 52)
            .overlay(
                HStack {
                    Text(label)
                        .foregroundStyle(env.theme.color(.textPrimary).opacity(opacity))
                    Spacer()
                    Image(systemName: "checkmark.circle")
                        .foregroundStyle(env.theme.color(.textSecondary).opacity(opacity))
                }
                .padding(.horizontal, 16)
            )
            .overlay(
                RoundedRectangle(cornerRadius: env.theme.radius(.large), style: .continuous)
                    .stroke(border, lineWidth: 1.5)
            )
    }

    private var settingsSections: [NavigationSection<SettingsSection>] {
        [
            NavigationSection(
                id: "utility",
                title: "Utility areas",
                items: SettingsSection.allCases.map {
                    NavigationItem(id: $0, title: $0.title, symbol: $0.symbol)
                }
            )
        ]
    }
}
