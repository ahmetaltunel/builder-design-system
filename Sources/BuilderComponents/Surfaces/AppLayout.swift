import SwiftUI
import BuilderFoundation

public struct AppLayout<Sidebar: View, Content: View>: View {
    public let environment: DesignSystemEnvironment
    public let sidebarWidth: CGFloat
    public let sidebar: Sidebar
    public let content: Content

    public init(
        environment: DesignSystemEnvironment,
        sidebarWidth: CGFloat = 280,
        @ViewBuilder sidebar: () -> Sidebar,
        @ViewBuilder content: () -> Content
    ) {
        self.environment = environment
        self.sidebarWidth = sidebarWidth
        self.sidebar = sidebar()
        self.content = content()
    }

    public var body: some View {
        HStack(spacing: 0) {
            sidebar
                .frame(width: sidebarWidth, alignment: .topLeading)
                .background(
                    SidebarBackdrop(environment: environment)
                        .extendsIntoTitlebar()
                )

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .background(environment.theme.color(.workspaceBackground))
        }
        .background(environment.theme.color(.appBackground))
    }
}
