import SwiftUI
import BuilderDesignSystem
import BuilderCatalog

struct HomeView: View {
    let env: DesignSystemEnvironment
    @EnvironmentObject private var model: ShowcaseModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ShowcaseRouteHeader(
                    environment: env,
                    eyebrow: "Builder showcase",
                    title: "Build with the system, not around it",
                    subtitle: "Use live canvases, recipes, foundations, and settings tools to shape desktop product UI quickly."
                ) {
                    HStack(spacing: 10) {
                        SystemButton(environment: env, title: "Open lab", tone: .primary, leadingSymbol: "flask") {
                            model.route = .lab
                        }
                        SystemButton(environment: env, title: "Browse components", tone: .secondary, leadingSymbol: "square.grid.3x3") {
                            model.route = .components
                        }
                    }
                }

                ShowcaseStatStrip(
                    environment: env,
                    items: [
                        ("System", "\(CatalogContent.components.count) components, \(TypographyToken.allCases.count) type roles, \(MaterialToken.allCases.count) material roles"),
                        ("Focus", "Product-grade desktop workflows"),
                        ("Modes", "\(env.mode.title) • \(env.density.title)")
                    ]
                )

                LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 14) {
                    launchCard(
                        title: "Components",
                        subtitle: "Browse the public component surface with a live canvas, preset switching, and inspector notes.",
                        symbol: "square.grid.3x3",
                        accent: env.theme.color(.accentPrimary)
                    ) {
                        model.route = .components
                    }

                    launchCard(
                        title: "Recipes",
                        subtitle: "See composed scenarios like settings, data exploration, onboarding, and feedback working as products.",
                        symbol: "square.on.square.squareshape.controlhandles",
                        accent: env.theme.color(.chartAmber)
                    ) {
                        model.route = .recipes
                    }

                    launchCard(
                        title: "Foundations",
                        subtitle: "Inspect color, type, spacing, motion, and materials with real specimens instead of abstract docs.",
                        symbol: "square.stack.3d.up",
                        accent: env.theme.color(.chartTeal)
                    ) {
                        model.route = .foundations
                    }

                    launchCard(
                        title: "Lab",
                        subtitle: "Combine components into working desktop layouts and test interaction, hierarchy, and context together.",
                        symbol: "flask",
                        accent: env.theme.color(.chartPurple)
                    ) {
                        model.route = .lab
                    }
                }

                HStack(alignment: .top, spacing: 16) {
                    PanelSurface(environment: env, title: "Start building", subtitle: "A practical route through the showcase for a builder adopting the system.") {
                        VStack(alignment: .leading, spacing: 14) {
                            workflowStep(number: "01", title: "Pick a route", body: "Open Components when you need a specific primitive, Recipes when you need composition, and Lab when you want to prototype a real surface.")
                            workflowStep(number: "02", title: "Inspect the system", body: "Use Foundations and Theme & tokens to understand the semantic rules that keep light and dark mode aligned.")
                            workflowStep(number: "03", title: "Stress the UI", body: "Change density, contrast, and context so the same components behave well before you ship them.")
                        }
                    }

                    PanelSurface(environment: env, title: "What changed", subtitle: "The showcase is now optimized as a builder tool instead of a documentation stack.") {
                        VStack(alignment: .leading, spacing: 12) {
                            bullet("The shell now prioritizes live canvases, inspectors, and jump search over long card stacks.")
                            bullet("Settings owns appearance, accessibility, and token inspection in one utility destination.")
                            bullet("Recipes and Lab now translate the system into realistic product surfaces instead of generic demos.")
                        }
                    }
                    .frame(maxWidth: 420)
                }
            }
            .padding(24)
            .frame(maxWidth: 1280, alignment: .leading)
        }
    }

    private func launchCard(title: String, subtitle: String, symbol: String, accent: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Image(systemName: symbol)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(accent)
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(env.theme.color(.textMuted))
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(env.theme.typography(.titleCompact).font)
                        .foregroundStyle(env.theme.color(.textPrimary))
                    Text(subtitle)
                        .font(env.theme.typography(.body).font)
                        .foregroundStyle(env.theme.color(.textSecondary))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(18)
            .frame(maxWidth: .infinity, minHeight: 164, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: env.theme.radius(.large), style: .continuous)
                    .fill(env.theme.color(.groupedSurface))
            )
            .overlay(
                RoundedRectangle(cornerRadius: env.theme.radius(.large), style: .continuous)
                    .stroke(env.theme.color(.subtleBorder), lineWidth: 1)
            )
            .contentShape(RoundedRectangle(cornerRadius: env.theme.radius(.large), style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private func workflowStep(number: String, title: String, body: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(env.theme.typography(.monoCaption).font)
                .foregroundStyle(env.theme.color(.textMuted))
                .frame(width: 28, alignment: .leading)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(env.theme.typography(.labelStrong).font)
                    .foregroundStyle(env.theme.color(.textPrimary))
                Text(body)
                    .font(env.theme.typography(.body).font)
                    .foregroundStyle(env.theme.color(.textSecondary))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(env.theme.color(.accentPrimary))
                .frame(width: 6, height: 6)
                .padding(.top, 8)

            Text(text)
                .font(env.theme.typography(.body).font)
                .foregroundStyle(env.theme.color(.textSecondary))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
