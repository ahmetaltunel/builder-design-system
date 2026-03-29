import SwiftUI
import BuilderFoundation

public struct SidebarBackdrop: View {
    public let environment: DesignSystemEnvironment

    public init(environment: DesignSystemEnvironment) {
        self.environment = environment
    }

    public var body: some View {
        let material = environment.theme.material(.sidebar)
        ZStack {
            if material.isTranslucent {
                SystemVisualEffectView(material: .sidebar, blendingMode: .behindWindow)
                    .ignoresSafeArea()
            }

            Rectangle()
                .fill(material.fill.opacity(material.fillOpacity))

            if environment.mode == .dark {
                Rectangle()
                    .fill(Color.white.opacity(0.018))
                    .mask(
                        LinearGradient(
                            colors: [.white, .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            } else {
                LinearGradient(
                    colors: [
                        material.fill.opacity(0.985),
                        material.fill.opacity(0.955)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }
}
