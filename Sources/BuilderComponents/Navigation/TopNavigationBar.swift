import SwiftUI
import BuilderFoundation

public struct TopNavigationBar<Leading: View, Trailing: View>: View {
    public let environment: DesignSystemEnvironment
    public let leading: Leading
    public let trailing: Trailing

    public init(
        environment: DesignSystemEnvironment,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.environment = environment
        self.leading = leading()
        self.trailing = trailing()
    }

    public var body: some View {
        let material = environment.theme.material(.toolbar)
        HStack(spacing: 12) {
            leading
            Spacer(minLength: 12)
            trailing
        }
        .padding(.horizontal, environment.theme.spacing(.panelPadding, density: environment.density))
        .frame(height: environment.theme.spacing(.toolbarHeight, density: environment.density))
        .background(material.fill.opacity(material.fillOpacity))
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(material.border)
                .frame(height: material.borderWidth)
        }
    }
}
