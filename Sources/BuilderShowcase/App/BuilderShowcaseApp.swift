import SwiftUI

@main
struct BuilderShowcaseApp: App {
    @NSApplicationDelegateAdaptor(ShowcaseAppDelegate.self) private var appDelegate
    @StateObject private var model = ShowcaseModel()

    var body: some Scene {
        WindowGroup("Builder Showcase") {
            ShowcaseRootView()
                .environmentObject(model)
                .preferredColorScheme(model.themeMode == .dark ? .dark : .light)
        }
        .defaultSize(width: 1560, height: 980)
        .windowStyle(.hiddenTitleBar)
    }
}
