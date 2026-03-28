import SwiftUI
import BuilderDesignSystem
import BuilderCatalog

struct WorkbenchView: View {
    let env: DesignSystemEnvironment
    @EnvironmentObject private var model: ShowcaseModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                controls
                tokenSwatches
                materialSwatches
                typographyScale
                crossReference
            }
            .padding(32)
        }
    }

    private var controls: some View {
        PanelSurface(environment: env, title: "Theme & tokens", subtitle: "Adjust global settings and inspect how semantic roles respond across the same product surfaces.") {
            VStack(alignment: .leading, spacing: 14) {
                SegmentedPicker(
                    environment: env,
                    options: ThemeMode.allCases.map { (label: $0.title, value: $0) },
                    selection: $model.themeMode
                )

                SegmentedPicker(
                    environment: env,
                    options: ThemeContrast.allCases.map { (label: $0.title, value: $0) },
                    selection: $model.themeContrast,
                    style: .neutral
                )

                Toggle("Reduced motion", isOn: $model.reduceMotion)
                Toggle("High contrast", isOn: $model.highContrast)
            }
        }
    }

    private var tokenSwatches: some View {
        PanelSurface(environment: env, title: "Color tokens", subtitle: "The same semantic roles power the catalog, showcase demos, and shell surfaces.") {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 170), spacing: 14)], spacing: 14) {
                ForEach(ColorToken.allCases) { token in
                    VStack(alignment: .leading, spacing: 10) {
                        RoundedRectangle(cornerRadius: env.theme.radius(.medium), style: .continuous)
                            .fill(env.theme.color(token))
                            .frame(height: 72)
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
    }

    private var typographyScale: some View {
        PanelSurface(environment: env, title: "Typography scale", subtitle: "A fuller semantic type hierarchy for display, title, body, label, utility, and monospaced data roles.") {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(TypographyToken.allCases) { token in
                    let spec = env.theme.typography(token)

                    VStack(alignment: .leading, spacing: 6) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(token.rawValue)
                                .frame(width: 150, alignment: .leading)
                                .font(env.theme.typography(.caption).font)
                                .foregroundStyle(env.theme.color(.textSecondary))

                            Text(sampleText(for: token))
                                .font(spec.font)
                                .foregroundStyle(env.theme.color(.textPrimary))

                            Spacer()

                            VStack(alignment: .trailing, spacing: 2) {
                                Text("\(Int(spec.size)) pt \(spec.weight.title)")
                                Text("LH \(Int(spec.lineHeight)) • TR \(String(format: "%.1f", spec.tracking))\(spec.isMonospaced ? " • mono" : "")")
                            }
                            .font(env.theme.typography(.caption).font)
                            .foregroundStyle(env.theme.color(.textMuted))
                        }

                        if token == .eyebrow || token == .mono || token == .numeric {
                            Rectangle()
                                .fill(env.theme.color(.subtleBorder))
                                .frame(height: 1)
                        }
                    }
                }
            }
        }
    }

    private var materialSwatches: some View {
        PanelSurface(environment: env, title: "Materials", subtitle: "Surface roles now carry fill, border, elevation, radius, opacity, translucency, and interactivity semantics.") {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 180), spacing: 14)], spacing: 14) {
                ForEach(MaterialToken.allCases) { token in
                    let spec = env.theme.material(token)
                    let shadow = env.theme.elevation(spec.elevation)

                    VStack(alignment: .leading, spacing: 10) {
                        RoundedRectangle(cornerRadius: env.theme.radius(spec.radius), style: .continuous)
                            .fill(spec.fill.opacity(spec.fillOpacity))
                            .frame(height: 72)
                            .overlay(
                                RoundedRectangle(cornerRadius: env.theme.radius(spec.radius), style: .continuous)
                                    .stroke(spec.border, lineWidth: spec.borderWidth)
                            )
                            .shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(token.rawValue)
                                .font(env.theme.typography(.captionStrong).font)
                                .foregroundStyle(env.theme.color(.textSecondary))
                            Text("\(spec.elevation.rawValue) • \(spec.radius.rawValue)\(spec.isTranslucent ? " • translucent" : "")\(spec.isInteractive ? " • interactive" : "")")
                                .font(env.theme.typography(.caption).font)
                                .foregroundStyle(env.theme.color(.textMuted))
                        }
                    }
                }
            }
        }
    }

    private var crossReference: some View {
        PanelSurface(environment: env, title: "Catalog cross-reference", subtitle: "Your public taxonomy stays intact while SwiftUI types remain idiomatic.") {
            VStack(spacing: 0) {
                ForEach(CatalogContent.componentCrossReference.prefix(18), id: \.catalog) { mapping in
                    HStack {
                        Text(mapping.catalog)
                        Spacer()
                        Text(mapping.swiftUI)
                            .foregroundStyle(env.theme.color(.textSecondary))
                            .font(.system(.body, design: .monospaced))
                    }
                    .font(env.theme.typography(.body).font)
                    .padding(.vertical, 10)

                    Divider()
                        .overlay(env.theme.color(.subtleBorder))
                }
            }
        }
    }

    private func sampleText(for token: TypographyToken) -> String {
        switch token {
        case .displayLarge, .display, .displaySmall, .hero:
            "Build polished desktop tools"
        case .pageTitle, .title, .titleCompact, .sectionTitle:
            "System heading"
        case .sectionSubtitle:
            "Secondary heading that supports the primary title."
        case .eyebrow:
            "SECTION LABEL"
        case .bodyLarge, .body, .bodyStrong, .bodySmall, .bodySmallStrong:
            "Type roles should scale from narrative body copy to denser operational details."
        case .label, .labelStrong:
            "Field label"
        case .caption, .captionStrong, .helper, .tableMeta:
            "Supporting metadata"
        case .buttonLarge, .button, .buttonSmall:
            "Primary action"
        case .mono, .monoSmall, .monoCaption:
            "theme.color(.accentPrimary)"
        case .numeric:
            "128.4 ms"
        }
    }
}
