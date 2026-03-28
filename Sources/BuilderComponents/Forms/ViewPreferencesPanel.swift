import SwiftUI
import BuilderFoundation
import BuilderBehaviors

public struct ViewPreferencesPanel: View {
    public let environment: DesignSystemEnvironment
    @Binding public var denseMode: Bool
    @Binding public var showsMetadata: Bool

    public init(environment: DesignSystemEnvironment, denseMode: Binding<Bool>, showsMetadata: Binding<Bool>) {
        self.environment = environment
        self._denseMode = denseMode
        self._showsMetadata = showsMetadata
    }

    public init<Item: Identifiable & Hashable>(
        environment: DesignSystemEnvironment,
        controller: CollectionController<Item>
    ) {
        self.environment = environment
        self._denseMode = Binding(
            get: { controller.denseMode },
            set: { controller.setDenseMode($0) }
        )
        self._showsMetadata = Binding(
            get: { controller.showsMetadata },
            set: { controller.setShowsMetadata($0) }
        )
    }

    public var body: some View {
        SettingsGroup(environment: environment) {
            ToggleSwitch(environment: environment, title: "Dense mode", isOn: $denseMode)
            ToggleSwitch(environment: environment, title: "Show metadata", isOn: $showsMetadata)
        }
    }
}
