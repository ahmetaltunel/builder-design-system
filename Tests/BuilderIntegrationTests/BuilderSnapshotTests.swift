import SwiftUI
import XCTest
import BuilderFoundation
import BuilderComponents
@testable import BuilderShowcase

@MainActor
final class BuilderSnapshotTests: XCTestCase {
    func testShowcaseRouteSnapshots() {
        let dark = ShowcaseModel()
        dark.themeMode = .dark

        let light = ShowcaseModel()
        light.themeMode = .light

        SnapshotTestSupport.assertSnapshot(
            matching: HomeView(env: dark.environment).environmentObject(dark),
            named: "showcase-home-dark",
            size: CGSize(width: 1280, height: 900)
        )
        SnapshotTestSupport.assertSnapshot(
            matching: ComponentsCatalogView(env: dark.environment).environmentObject(dark),
            named: "showcase-components-dark",
            size: CGSize(width: 1400, height: 900)
        )
        SnapshotTestSupport.assertSnapshot(
            matching: FoundationsCatalogView(env: dark.environment).environmentObject(dark),
            named: "showcase-foundations-dark",
            size: CGSize(width: 1400, height: 900)
        )
        SnapshotTestSupport.assertSnapshot(
            matching: SettingsCatalogView(env: dark.environment).environmentObject(dark),
            named: "showcase-settings-dark",
            size: CGSize(width: 1400, height: 900)
        )

        SnapshotTestSupport.assertSnapshot(
            matching: HomeView(env: light.environment).environmentObject(light),
            named: "showcase-home-light",
            size: CGSize(width: 1280, height: 900)
        )
        SnapshotTestSupport.assertSnapshot(
            matching: ComponentsCatalogView(env: light.environment).environmentObject(light),
            named: "showcase-components-light",
            size: CGSize(width: 1400, height: 900)
        )
        SnapshotTestSupport.assertSnapshot(
            matching: FoundationsCatalogView(env: light.environment).environmentObject(light),
            named: "showcase-foundations-light",
            size: CGSize(width: 1400, height: 900)
        )
        light.selectedSettingsSection = .themeTokens
        SnapshotTestSupport.assertSnapshot(
            matching: SettingsCatalogView(env: light.environment).environmentObject(light),
            named: "showcase-settings-light",
            size: CGSize(width: 1400, height: 900)
        )
    }

    func testComponentStateGallerySnapshots() {
        let darkEnvironment = DesignSystemEnvironment(
            theme: AppTheme(mode: .dark, contrast: .standard),
            mode: .dark,
            contrast: .standard,
            density: .compact,
            visualContext: .editorComposer,
            reduceMotion: false,
            highContrast: false
        )
        let lightEnvironment = DesignSystemEnvironment(
            theme: AppTheme(mode: .light, contrast: .standard),
            mode: .light,
            contrast: .standard,
            density: .compact,
            visualContext: .editorComposer,
            reduceMotion: false,
            highContrast: false
        )

        SnapshotTestSupport.assertSnapshot(
            matching: ComponentStateGallery(environment: darkEnvironment),
            named: "component-state-gallery-dark",
            size: CGSize(width: 960, height: 420)
        )
        SnapshotTestSupport.assertSnapshot(
            matching: ComponentStateGallery(environment: lightEnvironment),
            named: "component-state-gallery-light",
            size: CGSize(width: 960, height: 420)
        )
    }
}

private struct ComponentStateGallery: View {
    let environment: DesignSystemEnvironment
    @State private var text = "Builder workspace"
    @State private var notes = "Read-only draft"
    @State private var choice = "automatic"

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 12) {
                SystemButton(environment: environment, title: "Primary", tone: .primary) {}
                SystemButton(environment: environment, title: "Loading", tone: .primary, isLoading: true) {}
                SystemButton(environment: environment, title: "Disabled", tone: .secondary, isEnabled: false) {}
            }

            TextInputField(
                environment: environment,
                placeholder: "Name",
                text: $text,
                status: .error,
                message: "Resolve the field before continuing."
            )

            TextAreaField(
                environment: environment,
                placeholder: "Notes",
                text: $notes,
                status: .warning,
                message: "This content is currently locked.",
                isReadOnly: true,
                isEnabled: false
            )

            HStack(spacing: 12) {
                ToggleSwitch(environment: environment, title: "Background sync", isOn: .constant(true), isLoading: true)
                Checkbox(environment: environment, title: "Apply to all", isOn: .constant(false), isMixed: true, isEnabled: false)
            }

            SelectMenu(
                environment: environment,
                options: [
                    .init(label: "Automatic", value: "automatic"),
                    .init(label: "Pinned", value: "pinned")
                ],
                selection: $choice,
                isEnabled: false
            )

            AlertBanner(
                environment: environment,
                title: "Needs review",
                message: "Dismiss and action affordances should coexist clearly.",
                tone: .warning,
                actionTitle: "Inspect",
                action: {},
                isDismissible: true,
                onDismiss: {}
            )
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(environment.theme.color(.workspaceBackground))
    }
}
