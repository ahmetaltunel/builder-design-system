import SwiftUI
import BuilderFoundation

public struct CodeEditorSurface: View {
    public let environment: DesignSystemEnvironment
    @Binding public var code: String
    public let minHeight: CGFloat

    public init(environment: DesignSystemEnvironment, code: Binding<String>, minHeight: CGFloat = 180) {
        self.environment = environment
        self._code = code
        self.minHeight = minHeight
    }

    public var body: some View {
        let material = environment.theme.material(.code)
        TextEditor(text: $code)
            .font(environment.theme.typography(.mono).font)
            .foregroundStyle(environment.theme.color(.textPrimary))
            .scrollContentBackground(.hidden)
            .padding(10)
            .frame(minHeight: minHeight)
            .background(
                RoundedRectangle(cornerRadius: environment.theme.radius(material.radius), style: .continuous)
                    .fill(material.fill.opacity(material.fillOpacity))
            )
            .overlay(
                RoundedRectangle(cornerRadius: environment.theme.radius(material.radius), style: .continuous)
                    .stroke(material.border, lineWidth: material.borderWidth)
            )
    }
}
