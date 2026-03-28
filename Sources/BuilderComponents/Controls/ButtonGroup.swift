import SwiftUI
import BuilderFoundation

public struct ButtonGroup<Selection: Hashable>: View {
    public struct Option {
        public let label: String
        public let value: Selection

        public init(label: String, value: Selection) {
            self.label = label
            self.value = value
        }
    }

    public let environment: DesignSystemEnvironment
    public let options: [Option]
    @Binding public var selection: Selection

    public init(environment: DesignSystemEnvironment, options: [Option], selection: Binding<Selection>) {
        self.environment = environment
        self.options = options
        self._selection = selection
    }

    public var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(options.enumerated()), id: \.offset) { _, option in
                SystemButton(
                    environment: environment,
                    title: option.label,
                    tone: option.value == selection ? .primary : .secondary
                ) {
                    selection = option.value
                }
            }
        }
    }
}
