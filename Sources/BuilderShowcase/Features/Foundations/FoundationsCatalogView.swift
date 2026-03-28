import SwiftUI
import BuilderDesignSystem
import BuilderCatalog

struct FoundationsCatalogView: View {
    let env: DesignSystemEnvironment
    @EnvironmentObject private var model: ShowcaseModel
    @StateObject private var inspectorState = FoundationInspectorState()
    @State private var selectedTopic: FoundationTopic = CatalogContent.foundations.first?.topic ?? .visualFoundation

    var body: some View {
        VStack(spacing: 0) {
            ShowcaseRouteHeader(
                environment: env,
                eyebrow: "Foundations",
                title: "Inspect the rules behind the surfaces",
                subtitle: "Compare light and dark logic, inspect semantic tokens, and verify how type, materials, motion, and spacing shape the same product."
            ) {
                HStack(spacing: 10) {
                    SegmentedPicker(
                        environment: env,
                        options: FoundationInspectorState.ThemePreviewMode.allCases.map { ($0.rawValue, $0) },
                        selection: $inspectorState.previewMode,
                        style: .neutral
                    )
                    .frame(width: 190)

                    SystemButton(environment: env, title: "Theme & tokens", tone: .secondary, leadingSymbol: "paintpalette") {
                        model.selectedSettingsSection = .themeTokens
                        model.route = .settings
                    }
                }
            }

            Rectangle()
                .fill(env.theme.color(.subtleBorder))
                .frame(height: 1)

            HStack(spacing: 0) {
                topicColumn

                Rectangle()
                    .fill(env.theme.color(.subtleBorder))
                    .frame(width: 1)

                specimenColumn

                Rectangle()
                    .fill(env.theme.color(.subtleBorder))
                    .frame(width: 1)

                inspectorColumn
            }
        }
        .onAppear(perform: syncSelection)
        .onChange(of: model.searchText) { _, _ in
            syncSelection()
        }
        .onChange(of: model.pendingFoundationTopic) { _, _ in
            syncSelection()
        }
    }

    private var filteredFoundations: [FoundationDetail] {
        model.filteredFoundations()
    }

    private var selectedDetail: FoundationDetail {
        filteredFoundations.first(where: { $0.topic == selectedTopic }) ?? filteredFoundations.first ?? CatalogContent.foundations[0]
    }

    private var topicColumn: some View {
        NavigationBrowserList(
            environment: env,
            items: topicItems,
            selection: $selectedTopic,
            rowHeight: 44
        ) { item, isSelected in
            FoundationTopicRow(environment: env, item: item, isSelected: isSelected)
        }
        .padding(22)
        .frame(width: 250)
    }

    private var specimenColumn: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HeaderBlock(environment: env, title: selectedDetail.topic.rawValue, subtitle: selectedDetail.summary) {
                    TokenBadge(environment: env, title: "\(selectedDetail.tokenReferences.count) references", tint: nil)
                }

                comparisonStrip

                specimenContent
            }
            .padding(28)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    @ViewBuilder
    private var comparisonStrip: some View {
        if inspectorState.previewMode == .compare {
            HStack(spacing: 14) {
                themeSampleCard(mode: env.mode, title: env.mode.title)
                themeSampleCard(mode: env.mode == .dark ? .light : .dark, title: env.mode == .dark ? "Light" : "Dark")
            }
        }
    }

    @ViewBuilder
    private var specimenContent: some View {
        switch selectedTopic {
        case .colors, .dataVisualizationColors:
            colorSpecimen
        case .typography:
            typographySpecimen
        case .spacing:
            spacingSpecimen
        case .motion:
            motionSpecimen
        case .materials:
            materialSpecimen
        case .iconography:
            iconSpecimen
        case .layout:
            gridSpecimen
        case .visualFoundation:
            structuralSpecimen
        default:
            structuralSpecimen
        }
    }

    private var colorSpecimen: some View {
        VStack(alignment: .leading, spacing: 18) {
            specimenGroup(title: "Core surfaces", subtitle: "Base shell, workspace, grouped panels, and input surfaces.") {
                swatchGrid(tokens: [.appBackground, .sidebarBackground, .workspaceBackground, .groupedSurface, .raisedSurface, .inputSurface, .selectedSurface, .overlaySurface])
            }

            specimenGroup(title: "Text and states", subtitle: "Hierarchy, accent, focus, and semantic status roles.") {
                swatchGrid(tokens: [.textPrimary, .textSecondary, .textMuted, .accentPrimary, .focusRing, .success, .warning, .danger, .info])
            }

            specimenGroup(title: "Data visualization", subtitle: "Chart hues that belong to the same calm shell.") {
                swatchGrid(tokens: [.chartBlue, .chartTeal, .chartAmber, .chartRed, .chartPurple, .chartGreen, .chartNeutral])
            }
        }
    }

    private var typographySpecimen: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(TypographyToken.allCases) { token in
                let spec = env.theme.typography(token)

                Button {
                    inspectorState.selectedTypography = token
                } label: {
                    HStack(alignment: .firstTextBaseline, spacing: 16) {
                        Text(token.rawValue)
                            .frame(width: 150, alignment: .leading)
                            .font(env.theme.typography(.captionStrong).font)
                            .foregroundStyle(env.theme.color(.textSecondary))

                        Text(sampleText(for: token))
                            .font(spec.font)
                            .foregroundStyle(env.theme.color(.textPrimary))

                        Spacer()

                        Text("\(Int(spec.size)) pt")
                            .font(env.theme.typography(.caption).font)
                            .foregroundStyle(env.theme.color(.textMuted))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: env.theme.radius(.medium), style: .continuous)
                            .fill(inspectorState.selectedTypography == token ? env.theme.color(.selectedSurface) : env.theme.color(.groupedSurface))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: env.theme.radius(.medium), style: .continuous)
                            .stroke(env.theme.color(.subtleBorder), lineWidth: 1)
                    )
                    .contentShape(RoundedRectangle(cornerRadius: env.theme.radius(.medium), style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var spacingSpecimen: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(SpacingToken.allCases) { token in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(token.rawValue)
                            .font(env.theme.typography(.captionStrong).font)
                            .foregroundStyle(env.theme.color(.textSecondary))
                        Spacer()
                        Text("\(Int(env.theme.spacing(token, density: env.density))) pt")
                            .font(env.theme.typography(.caption).font)
                            .foregroundStyle(env.theme.color(.textMuted))
                    }

                    RoundedRectangle(cornerRadius: env.theme.radius(.small), style: .continuous)
                        .fill(env.theme.color(.accentPrimary))
                        .frame(width: max(env.theme.spacing(token, density: env.density) * 4, 12), height: 12)
                }
                .padding(.bottom, 4)
            }
        }
    }

    private var motionSpecimen: some View {
        VStack(alignment: .leading, spacing: 16) {
            specimenGroup(title: "Durations", subtitle: "Use fast, restrained durations before reaching for louder easing changes.") {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(MotionToken.allCases) { token in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(token.rawValue)
                                    .font(env.theme.typography(.labelStrong).font)
                                    .foregroundStyle(env.theme.color(.textPrimary))
                                Spacer()
                                Text("\(String(format: "%.2fs", env.theme.motion(token, reduceMotion: false)))")
                                    .font(env.theme.typography(.caption).font)
                                    .foregroundStyle(env.theme.color(.textMuted))
                            }

                            RoundedRectangle(cornerRadius: env.theme.radius(.medium), style: .continuous)
                                .fill(env.theme.color(.inputSurface))
                                .frame(height: 18)
                                .overlay(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: env.theme.radius(.medium), style: .continuous)
                                        .fill(env.theme.color(.accentPrimary))
                                        .frame(width: max(env.theme.motion(token, reduceMotion: false) * 320, 22))
                                }
                        }
                    }
                }
            }

            specimenGroup(title: "Motion curves", subtitle: "Easing is a first-class token now, not an implicit choice hidden inside transitions.") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 180), spacing: 14)], spacing: 14) {
                    ForEach(MotionCurveToken.allCases) { token in
                        let curve = env.theme.motionCurve(token)

                        Button {
                            inspectorState.selectedMotionCurve = token
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(curve.name)
                                    .font(env.theme.typography(.bodySmallStrong).font)
                                    .foregroundStyle(env.theme.color(.textPrimary))
                                Text(token.rawValue)
                                    .font(env.theme.typography(.caption).font)
                                    .foregroundStyle(env.theme.color(.textMuted))
                                Text("[\(String(format: "%.2f", curve.x1)), \(String(format: "%.2f", curve.y1)), \(String(format: "%.2f", curve.x2)), \(String(format: "%.2f", curve.y2))]")
                                    .font(env.theme.typography(.monoCaption).font)
                                    .foregroundStyle(env.theme.color(.textSecondary))
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: env.theme.radius(.medium), style: .continuous)
                                    .fill(inspectorState.selectedMotionCurve == token ? env.theme.color(.selectedSurface) : env.theme.color(.inputSurface))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: env.theme.radius(.medium), style: .continuous)
                                    .stroke(env.theme.color(.subtleBorder), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var materialSpecimen: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 180), spacing: 16)], spacing: 16) {
            ForEach(MaterialToken.allCases) { token in
                let material = theme(for: env.mode).material(token)

                Button {
                    inspectorState.selectedMaterial = token
                } label: {
                    VStack(alignment: .leading, spacing: 10) {
                        RoundedRectangle(cornerRadius: env.theme.radius(material.radius), style: .continuous)
                            .fill(material.fill.opacity(material.fillOpacity))
                            .frame(height: 88)
                            .overlay(
                                RoundedRectangle(cornerRadius: env.theme.radius(material.radius), style: .continuous)
                                    .stroke(material.border, lineWidth: material.borderWidth)
                            )

                        Text(token.rawValue)
                            .font(env.theme.typography(.captionStrong).font)
                            .foregroundStyle(env.theme.color(.textPrimary))
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: env.theme.radius(.large), style: .continuous)
                            .fill(inspectorState.selectedMaterial == token ? env.theme.color(.selectedSurface) : env.theme.color(.groupedSurface))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: env.theme.radius(.large), style: .continuous)
                            .stroke(env.theme.color(.subtleBorder), lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var iconSpecimen: some View {
        specimenGroup(title: "Icon rhythm", subtitle: "Iconography now has explicit semantic roles so navigation, utility, and status use a coherent symbol language.") {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 146), spacing: 14)], spacing: 14) {
                ForEach(IconToken.allCases) { token in
                    let spec = env.theme.icon(token)

                    Button {
                        inspectorState.selectedIcon = token
                    } label: {
                        VStack(alignment: .leading, spacing: 10) {
                            Image(systemName: spec.symbol)
                                .font(.system(size: spec.pointSize, weight: spec.weight))
                                .foregroundStyle(token == .accentAction ? env.theme.color(.accentPrimary) : env.theme.color(.textSecondary))
                            Text(token.rawValue)
                                .font(env.theme.typography(.captionStrong).font)
                                .foregroundStyle(env.theme.color(.textPrimary))
                            Text(spec.semanticRole)
                                .font(env.theme.typography(.caption).font)
                                .foregroundStyle(env.theme.color(.textSecondary))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: env.theme.radius(.medium), style: .continuous)
                                .fill(inspectorState.selectedIcon == token ? env.theme.color(.selectedSurface) : env.theme.color(.inputSurface))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: env.theme.radius(.medium), style: .continuous)
                                .stroke(env.theme.color(.subtleBorder), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var gridSpecimen: some View {
        specimenGroup(title: "Layout grids", subtitle: "Grid roles define the shell widths and working regions used across the showcase.") {
            VStack(alignment: .leading, spacing: 14) {
                ForEach(GridToken.allCases) { token in
                    let grid = env.theme.grid(token)
                    Button {
                        inspectorState.selectedGrid = token
                    } label: {
                        HStack(spacing: 14) {
                            HStack(spacing: 4) {
                                ForEach(0..<min(grid.columns, 8), id: \.self) { _ in
                                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                                        .fill(env.theme.color(token == inspectorState.selectedGrid ? .accentPrimary : .hoverSurface))
                                        .frame(width: 14, height: 26)
                                }
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(token.rawValue)
                                    .font(env.theme.typography(.bodySmallStrong).font)
                                    .foregroundStyle(env.theme.color(.textPrimary))
                                Text(grid.description)
                                    .font(env.theme.typography(.caption).font)
                                    .foregroundStyle(env.theme.color(.textSecondary))
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            Spacer()

                            Text(grid.maxWidth.map { "\(Int($0)) pt" } ?? "Fluid")
                                .font(env.theme.typography(.captionStrong).font)
                                .foregroundStyle(env.theme.color(.textMuted))
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: env.theme.radius(.medium), style: .continuous)
                                .fill(inspectorState.selectedGrid == token ? env.theme.color(.selectedSurface) : env.theme.color(.inputSurface))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: env.theme.radius(.medium), style: .continuous)
                                .stroke(env.theme.color(.subtleBorder), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var structuralSpecimen: some View {
        VStack(alignment: .leading, spacing: 18) {
            specimenGroup(title: "Shell composition", subtitle: "One dominant workspace, one quieter navigation rail, and grouped panels used sparingly.") {
                HStack(spacing: 14) {
                    RoundedRectangle(cornerRadius: env.theme.radius(.large), style: .continuous)
                        .fill(env.theme.color(.sidebarBackground))
                        .frame(width: 180, height: 220)
                        .overlay(alignment: .topLeading) {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(["Home", "Components", "Recipes", "Foundations"], id: \.self) { item in
                                    Text(item)
                                        .font(env.theme.typography(.body).font)
                                        .foregroundStyle(env.theme.color(.textPrimary))
                                        .padding(.horizontal, 12)
                                        .frame(height: 34)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(
                                            RoundedRectangle(cornerRadius: env.theme.radius(.medium), style: .continuous)
                                                .fill(item == "Components" ? env.theme.color(.sidebarSelection) : .clear)
                                        )
                                }
                            }
                            .padding(14)
                        }

                    VStack(spacing: 14) {
                        RoundedRectangle(cornerRadius: env.theme.radius(.large), style: .continuous)
                            .fill(env.theme.color(.groupedSurface))
                            .frame(height: 116)
                        RoundedRectangle(cornerRadius: env.theme.radius(.large), style: .continuous)
                            .fill(env.theme.color(.raisedSurface))
                            .frame(height: 90)
                    }
                }
            }

            specimenGroup(title: "Shadow hierarchy", subtitle: "Depth stays restrained and is reserved for genuinely lifted surfaces rather than everyday panels.") {
                HStack(spacing: 14) {
                    ForEach(ShadowToken.allCases) { token in
                        let spec = env.theme.shadowTokenSpec(token)
                        let active = inspectorState.selectedShadow == token

                        Button {
                            inspectorState.selectedShadow = token
                        } label: {
                            VStack(alignment: .leading, spacing: 10) {
                                RoundedRectangle(cornerRadius: env.theme.radius(.medium), style: .continuous)
                                    .fill(env.theme.color(.groupedSurface))
                                    .frame(height: 78)
                                    .shadow(
                                        color: env.mode == .dark ? spec.dark.color : spec.light.color,
                                        radius: env.mode == .dark ? spec.dark.radius : spec.light.radius,
                                        x: env.mode == .dark ? spec.dark.x : spec.light.x,
                                        y: env.mode == .dark ? spec.dark.y : spec.light.y
                                    )

                                Text(token.rawValue)
                                    .font(env.theme.typography(.captionStrong).font)
                                    .foregroundStyle(env.theme.color(.textPrimary))
                                Text(spec.description)
                                    .font(env.theme.typography(.caption).font)
                                    .foregroundStyle(env.theme.color(.textSecondary))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: env.theme.radius(.medium), style: .continuous)
                                    .fill(env.theme.color(.inputSurface))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: env.theme.radius(.medium), style: .continuous)
                                    .stroke(active ? env.theme.color(.strongBorder) : env.theme.color(.subtleBorder), lineWidth: active ? 1.5 : 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            specimenGroup(title: "Applied rules", subtitle: "The topic still resolves into implementation and calibration guidance.") {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(selectedDetail.calibrationNotes, id: \.self) { note in
                        HStack(alignment: .top, spacing: 10) {
                            Circle()
                                .fill(env.theme.color(.accentPrimary))
                                .frame(width: 6, height: 6)
                                .padding(.top, 8)
                            Text(note)
                                .font(env.theme.typography(.body).font)
                                .foregroundStyle(env.theme.color(.textSecondary))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
    }

    private var inspectorColumn: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                ShowcaseInspectorSection(environment: env, title: "Calibration notes") {
                    BulletList(environment: env, items: selectedDetail.calibrationNotes)
                }

                Divider()
                    .overlay(env.theme.color(.subtleBorder))

                ShowcaseInspectorSection(environment: env, title: "Implementation guidance") {
                    BulletList(environment: env, items: selectedDetail.implementationGuidelines)
                }

                Divider()
                    .overlay(env.theme.color(.subtleBorder))

                ShowcaseInspectorSection(environment: env, title: "Token references") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 118), spacing: 8)], spacing: 8) {
                        ForEach(selectedDetail.tokenReferences.prefix(18), id: \.self) { token in
                            TokenBadge(environment: env, title: token, tint: token.contains("accent") ? env.theme.color(.accentPrimary) : nil)
                        }
                    }
                }

                if selectedTopic == .materials {
                    Divider()
                        .overlay(env.theme.color(.subtleBorder))

                    ShowcaseInspectorSection(environment: env, title: "Selected material") {
                        let spec = theme(for: env.mode).material(inspectorState.selectedMaterial)

                        VStack(alignment: .leading, spacing: 6) {
                            Text(inspectorState.selectedMaterial.rawValue)
                                .font(env.theme.typography(.bodyStrong).font)
                                .foregroundStyle(env.theme.color(.textPrimary))
                            Text("Elevation: \(spec.elevation.rawValue)")
                            Text("Radius: \(spec.radius.rawValue)")
                            Text("Opacity: \(String(format: "%.2f", spec.fillOpacity))")
                            Text(spec.isTranslucent ? "Translucent" : "Opaque")
                            Text(spec.isInteractive ? "Interactive role" : "Structural role")
                        }
                        .font(env.theme.typography(.caption).font)
                        .foregroundStyle(env.theme.color(.textSecondary))
                    }
                }

                if selectedTopic == .typography {
                    Divider()
                        .overlay(env.theme.color(.subtleBorder))

                    ShowcaseInspectorSection(environment: env, title: "Selected type role") {
                        let spec = env.theme.typography(inspectorState.selectedTypography)
                        VStack(alignment: .leading, spacing: 6) {
                            Text(inspectorState.selectedTypography.rawValue)
                                .font(env.theme.typography(.bodyStrong).font)
                                .foregroundStyle(env.theme.color(.textPrimary))
                            Text("Size: \(Int(spec.size)) pt")
                            Text("Line height: \(Int(spec.lineHeight)) pt")
                            Text("Tracking: \(String(format: "%.1f", spec.tracking))")
                            Text(spec.isMonospaced ? "Monospaced companion" : "System UI family")
                        }
                        .font(env.theme.typography(.caption).font)
                        .foregroundStyle(env.theme.color(.textSecondary))
                    }
                }

                if selectedTopic == .iconography {
                    Divider()
                        .overlay(env.theme.color(.subtleBorder))

                    ShowcaseInspectorSection(environment: env, title: "Selected icon role") {
                        let spec = env.theme.icon(inspectorState.selectedIcon)
                        VStack(alignment: .leading, spacing: 6) {
                            Text(inspectorState.selectedIcon.rawValue)
                                .font(env.theme.typography(.bodyStrong).font)
                                .foregroundStyle(env.theme.color(.textPrimary))
                            Text("Symbol: \(spec.symbol)")
                            Text("Point size: \(Int(spec.pointSize)) pt")
                            Text("Role: \(spec.semanticRole)")
                        }
                        .font(env.theme.typography(.caption).font)
                        .foregroundStyle(env.theme.color(.textSecondary))
                    }
                }

                if selectedTopic == .layout {
                    Divider()
                        .overlay(env.theme.color(.subtleBorder))

                    ShowcaseInspectorSection(environment: env, title: "Selected grid") {
                        let spec = env.theme.grid(inspectorState.selectedGrid)
                        VStack(alignment: .leading, spacing: 6) {
                            Text(inspectorState.selectedGrid.rawValue)
                                .font(env.theme.typography(.bodyStrong).font)
                                .foregroundStyle(env.theme.color(.textPrimary))
                            Text("Columns: \(spec.columns)")
                            Text("Gutter: \(Int(spec.gutter)) pt")
                            Text("Margin: \(Int(spec.margin)) pt")
                            Text(spec.maxWidth.map { "Max width: \(Int($0)) pt" } ?? "Max width: Fluid")
                        }
                        .font(env.theme.typography(.caption).font)
                        .foregroundStyle(env.theme.color(.textSecondary))
                    }
                }

                if selectedTopic == .motion {
                    Divider()
                        .overlay(env.theme.color(.subtleBorder))

                    ShowcaseInspectorSection(environment: env, title: "Selected motion curve") {
                        let spec = env.theme.motionCurve(inspectorState.selectedMotionCurve)
                        VStack(alignment: .leading, spacing: 6) {
                            Text(spec.name)
                                .font(env.theme.typography(.bodyStrong).font)
                                .foregroundStyle(env.theme.color(.textPrimary))
                            Text("Curve: [\(String(format: "%.2f", spec.x1)), \(String(format: "%.2f", spec.y1)), \(String(format: "%.2f", spec.x2)), \(String(format: "%.2f", spec.y2))]")
                            Text(spec.notes)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .font(env.theme.typography(.caption).font)
                        .foregroundStyle(env.theme.color(.textSecondary))
                    }
                }

                if selectedTopic == .visualFoundation {
                    Divider()
                        .overlay(env.theme.color(.subtleBorder))

                    ShowcaseInspectorSection(environment: env, title: "Selected shadow role") {
                        let spec = env.theme.shadowTokenSpec(inspectorState.selectedShadow)
                        VStack(alignment: .leading, spacing: 6) {
                            Text(inspectorState.selectedShadow.rawValue)
                                .font(env.theme.typography(.bodyStrong).font)
                                .foregroundStyle(env.theme.color(.textPrimary))
                            Text(spec.description)
                            Text("Dark radius: \(String(format: "%.1f", spec.dark.radius))")
                            Text("Light radius: \(String(format: "%.1f", spec.light.radius))")
                        }
                        .font(env.theme.typography(.caption).font)
                        .foregroundStyle(env.theme.color(.textSecondary))
                    }
                }
            }
            .padding(22)
        }
        .frame(width: 330, alignment: .topLeading)
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .background(env.theme.color(.groupedSurface))
    }

    private func swatchGrid(tokens: [ColorToken]) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 14)], spacing: 14) {
            ForEach(tokens, id: \.self) { token in
                VStack(alignment: .leading, spacing: 8) {
                    RoundedRectangle(cornerRadius: env.theme.radius(.medium), style: .continuous)
                        .fill(env.theme.color(token))
                        .frame(height: 74)
                        .overlay(
                            RoundedRectangle(cornerRadius: env.theme.radius(.medium), style: .continuous)
                                .stroke(env.theme.color(.subtleBorder), lineWidth: 1)
                        )
                    Text(token.rawValue)
                        .font(env.theme.typography(.caption).font)
                        .foregroundStyle(env.theme.color(.textSecondary))
                }
            }
        }
    }

    private func specimenGroup<Content: View>(title: String, subtitle: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(env.theme.typography(.titleCompact).font)
                    .foregroundStyle(env.theme.color(.textPrimary))
                Text(subtitle)
                    .font(env.theme.typography(.body).font)
                    .foregroundStyle(env.theme.color(.textSecondary))
            }
            content()
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: env.theme.radius(.large), style: .continuous)
                .fill(env.theme.color(.groupedSurface))
        )
        .overlay(
            RoundedRectangle(cornerRadius: env.theme.radius(.large), style: .continuous)
                .stroke(env.theme.color(.subtleBorder), lineWidth: 1)
        )
    }

    private func sampleText(for token: TypographyToken) -> String {
        switch token {
        case .displayLarge, .display, .displaySmall, .hero:
            "Desktop system language"
        case .pageTitle, .title, .titleCompact, .sectionTitle:
            "System heading"
        case .sectionSubtitle:
            "Supporting description for a stronger section title."
        case .eyebrow:
            "FOUNDATION"
        case .bodyLarge, .body, .bodyStrong, .bodySmall, .bodySmallStrong:
            "Use this role when product copy needs to explain, orient, or annotate a working surface."
        case .label, .labelStrong:
            "Field label"
        case .caption, .captionStrong, .helper, .tableMeta:
            "Supporting metadata"
        case .buttonLarge, .button, .buttonSmall:
            "Primary action"
        case .mono, .monoSmall, .monoCaption:
            "theme.material(.panel)"
        case .numeric:
            "128.4 ms"
        }
    }

    private func themeSampleCard(mode: ThemeMode, title: String) -> some View {
        let sampleTheme = theme(for: mode)
        return VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(env.theme.typography(.labelStrong).font)
                .foregroundStyle(env.theme.color(.textPrimary))

            RoundedRectangle(cornerRadius: env.theme.radius(.large), style: .continuous)
                .fill(sampleTheme.color(.sidebarBackground))
                .frame(height: 90)
                .overlay(
                    RoundedRectangle(cornerRadius: env.theme.radius(.large), style: .continuous)
                        .stroke(sampleTheme.color(.subtleBorder), lineWidth: 1)
                )
                .overlay(alignment: .bottomTrailing) {
                    RoundedRectangle(cornerRadius: env.theme.radius(.medium), style: .continuous)
                        .fill(sampleTheme.color(.groupedSurface))
                        .frame(width: 82, height: 42)
                        .padding(10)
                }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: env.theme.radius(.large), style: .continuous)
                .fill(env.theme.color(.groupedSurface))
        )
        .overlay(
            RoundedRectangle(cornerRadius: env.theme.radius(.large), style: .continuous)
                .stroke(env.theme.color(.subtleBorder), lineWidth: 1)
        )
    }

    private func theme(for mode: ThemeMode) -> AppTheme {
        AppTheme(mode: mode, contrast: env.contrast)
    }

    private func syncSelection() {
        let candidates = filteredFoundations
        guard !candidates.isEmpty else {
            selectedTopic = CatalogContent.foundations[0].topic
            return
        }

        if let pendingTopic = model.pendingFoundationTopic,
           candidates.contains(where: { $0.topic == pendingTopic }) {
            selectedTopic = pendingTopic
            model.pendingFoundationTopic = nil
            return
        }

        if !candidates.contains(where: { $0.topic == selectedTopic }) {
            selectedTopic = candidates[0].topic
        }
    }

    private var topicItems: [NavigationItem<FoundationTopic>] {
        filteredFoundations.map {
            NavigationItem(id: $0.topic, title: $0.topic.rawValue)
        }
    }

}

private struct FoundationTopicRow: View {
    let environment: DesignSystemEnvironment
    let item: NavigationItem<FoundationTopic>
    let isSelected: Bool

    var body: some View {
        HStack {
            Text(item.title)
                .font(environment.theme.typography(.bodyStrong).font)
                .foregroundStyle(isSelected ? environment.theme.color(.textPrimary) : environment.theme.color(.textSecondary))
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                .fill(isSelected ? environment.theme.color(.selectedSurface) : .clear)
        )
        .contentShape(RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous))
    }
}
