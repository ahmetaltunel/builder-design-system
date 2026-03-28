import SwiftUI

public extension View {
    func extendsIntoTitlebar() -> some View {
        modifier(TitlebarExtensionModifier())
    }
}

private struct TitlebarExtensionModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .ignoresSafeArea(.container, edges: .top)
    }
}
