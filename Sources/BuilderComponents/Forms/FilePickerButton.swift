import SwiftUI
import BuilderFoundation

public struct FilePickerButton: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let isEnabled: Bool
    public let action: () -> Void

    public init(
        environment: DesignSystemEnvironment,
        title: String = "Browse files",
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.environment = environment
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }

    public var body: some View {
        SystemButton(
            environment: environment,
            title: title,
            tone: .secondary,
            size: .small,
            leadingSymbol: "paperclip",
            isEnabled: isEnabled,
            action: action
        )
    }
}
