import SwiftUI
import BuilderFoundation

public struct AttributeEditor: View {
    public struct Attribute: Identifiable, Hashable {
        public let id: String
        public var key: String
        public var value: String

        public init(id: String? = nil, key: String, value: String) {
            self.id = id ?? key
            self.key = key
            self.value = value
        }
    }

    public let environment: DesignSystemEnvironment
    @Binding public var attributes: [Attribute]

    public init(environment: DesignSystemEnvironment, attributes: Binding<[Attribute]>) {
        self.environment = environment
        self._attributes = attributes
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach($attributes) { $attribute in
                HStack(spacing: 10) {
                    TextInputField(environment: environment, placeholder: "Key", text: $attribute.key)
                    TextInputField(environment: environment, placeholder: "Value", text: $attribute.value)
                }
            }
        }
    }
}
