import SwiftUI
import BuilderDesignSystem

struct ShowcaseRootView: View {
    @EnvironmentObject private var model: ShowcaseModel
    @State private var isSearchFocused = false
    @State private var sidebarFocusRequest = 0

    var body: some View {
        let env = model.environment
        let shellTheme = AppTheme(mode: model.themeMode, contrast: env.contrast)
        let shellEnv = DesignSystemEnvironment(
            theme: shellTheme,
            mode: model.themeMode,
            contrast: env.contrast,
            density: env.density,
            visualContext: .shell,
            reduceMotion: env.reduceMotion,
            highContrast: env.highContrast
        )

        return HStack(spacing: 0) {
            sidebar(environment: shellEnv)
                .frame(width: 272)

            Rectangle()
                .fill(shellEnv.theme.color(.subtleBorder))
                .frame(width: 1)

            ZStack {
                shellEnv.theme.color(.workspaceBackground)
                    .ignoresSafeArea()

                detailView(environment: env)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
        .background(shellEnv.theme.color(.appBackground))
        .onAppear {
            isSearchFocused = false
            DispatchQueue.main.async {
                sidebarFocusRequest += 1
            }
        }
    }

    private func sidebar(environment: DesignSystemEnvironment) -> some View {
        let searchResultTopOffset: CGFloat = 46
        let searchResultSpacing: CGFloat = 8
        let searchResultsInsetTop =
            22
            + environment.theme.typography(.title).lineHeight
            + 6
            + environment.theme.typography(.caption).lineHeight
            + environment.theme.spacing(.md, density: environment.density)
            + searchResultTopOffset
            + searchResultSpacing

        return ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: environment.theme.spacing(.md, density: environment.density)) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Builder Showcase")
                        .font(environment.theme.typography(.title).font)
                        .foregroundStyle(environment.theme.color(.textPrimary))

                    Text("Builder sandbox")
                        .font(environment.theme.typography(.caption).font)
                        .foregroundStyle(environment.theme.color(.textMuted))
                }
                .padding(.top, 22)

                searchArea(environment: environment)

                NavigationSidebarList(
                    environment: environment,
                    sections: workspaceSections,
                    selection: primaryRouteSelection,
                    rowHeight: 44,
                    sectionHeaderHeight: 28,
                    focusRequest: sidebarFocusRequest,
                    onActivate: { item in
                        activatePrimaryRoute(item.id)
                    }
                ) { item, isSelected in
                    let route = item.id
                    ShowcaseNavigationRow(environment: environment, route: route, isSelected: isSelected)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                Spacer()

                Text("Settings")
                    .font(environment.theme.typography(.caption).font)
                    .foregroundStyle(environment.theme.color(.textMuted))

                Button {
                    isSearchFocused = false
                    withAnimation(.easeInOut(duration: environment.theme.motion(.selection, reduceMotion: environment.reduceMotion))) {
                        model.selectedSettingsSection = .appearance
                        model.route = .settings
                    }
                } label: {
                    ShowcaseNavigationRow(environment: environment, route: .settings, isSelected: model.route == .settings)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .frame(maxHeight: .infinity, alignment: .top)

            if !model.searchSections.isEmpty {
                ScrollView(showsIndicators: true) {
                    SearchJumpResultsView(environment: environment, sections: model.searchSections) { item in
                        isSearchFocused = false
                        withAnimation(.easeInOut(duration: environment.theme.motion(.selection, reduceMotion: environment.reduceMotion))) {
                            model.open(item)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 420, alignment: .topLeading)
                .padding(.top, searchResultsInsetTop)
                .padding(.horizontal, 16)
                .shadow(color: environment.mode == .dark ? .black.opacity(0.22) : .black.opacity(0.08), radius: 18, x: 0, y: 10)
                .transition(.opacity.combined(with: .move(edge: .top)))
                .zIndex(30)
            }
        }
        .background(SidebarBackdrop(environment: environment))
    }

    private func searchArea(environment: DesignSystemEnvironment) -> some View {
        TextInputField(
            environment: environment,
            placeholder: "Jump to routes, components, or recipes",
            text: $model.searchText,
            isFocused: $isSearchFocused,
            leadingSymbol: "magnifyingglass",
            onEscape: {
                sidebarFocusRequest += 1
            }
        )
        .zIndex(20)
    }

    @ViewBuilder
    private func detailView(environment: DesignSystemEnvironment) -> some View {
        switch model.route {
        case .home:
            HomeView(env: environment)
        case .components:
            ComponentsCatalogView(env: environment)
        case .recipes:
            RecipesCatalogView(env: environment)
        case .foundations:
            FoundationsCatalogView(env: environment)
        case .lab:
            LabView(env: environment)
        case .settings:
            SettingsCatalogView(env: environment)
        }
    }

    private var workspaceSections: [NavigationSection<ShowcaseRoute>] {
        [
            NavigationSection(
                id: "workspace",
                title: "Workspace",
                items: ShowcaseRoute.primaryRoutes.map {
                    NavigationItem(id: $0, title: $0.title, symbol: $0.symbol)
                }
            )
        ]
    }

    private var primaryRouteSelection: Binding<ShowcaseRoute?> {
        Binding(
            get: {
                ShowcaseRoute.primaryRoutes.contains(model.route) ? model.route : nil
            },
            set: { newValue in
                guard let newValue else { return }
                activatePrimaryRoute(newValue)
            }
        )
    }

    private func activatePrimaryRoute(_ route: ShowcaseRoute) {
        isSearchFocused = false
        withAnimation(.easeInOut(duration: model.environment.theme.motion(.selection, reduceMotion: model.environment.reduceMotion))) {
            model.route = route
        }
    }
}
