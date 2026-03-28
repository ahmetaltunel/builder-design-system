import SwiftUI
import BuilderFoundation
import BuilderBehaviors

public struct CopyToClipboardButton: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let value: String

    public init(environment: DesignSystemEnvironment, title: String = "Copy", value: String) {
        self.environment = environment
        self.title = title
        self.value = value
    }

    public var body: some View {
        SystemButton(environment: environment, title: title, tone: .secondary) {
            PasteboardBridge.copy(value)
        }
    }
}
