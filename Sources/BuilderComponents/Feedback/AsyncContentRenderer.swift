import SwiftUI
import BuilderFoundation

struct AsyncContentRenderer<Content: View>: View {
    let environment: DesignSystemEnvironment
    let state: AsyncContentState
    let emptyActionTitle: String?
    let onEmptyAction: (() -> Void)?
    let errorActionTitle: String?
    let onErrorAction: (() -> Void)?
    let content: Content

    init(
        environment: DesignSystemEnvironment,
        state: AsyncContentState,
        emptyActionTitle: String? = nil,
        onEmptyAction: (() -> Void)? = nil,
        errorActionTitle: String? = nil,
        onErrorAction: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.environment = environment
        self.state = state
        self.emptyActionTitle = emptyActionTitle
        self.onEmptyAction = onEmptyAction
        self.errorActionTitle = errorActionTitle
        self.onErrorAction = onErrorAction
        self.content = content()
    }

    var body: some View {
        switch state {
        case .ready:
            content
        case .loading(let presentation):
            LoadingBar(
                environment: environment,
                label: presentation.label,
                detail: presentation.detail
            )
        case .empty(let presentation):
            EmptyStateView(
                environment: environment,
                title: presentation.title,
                message: presentation.message,
                symbol: presentation.symbol,
                actionTitle: emptyActionTitle,
                action: onEmptyAction
            )
        case .error(let presentation):
            ErrorStateView(
                environment: environment,
                title: presentation.title,
                message: presentation.message,
                actionTitle: errorActionTitle,
                action: onErrorAction
            )
        }
    }
}
