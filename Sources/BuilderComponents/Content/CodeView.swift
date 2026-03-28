import SwiftUI
import BuilderFoundation

public struct CodeView: View {
    public let environment: DesignSystemEnvironment
    public let code: String

    public init(environment: DesignSystemEnvironment, code: String) {
        self.environment = environment
        self.code = code
    }

    public var body: some View {
        let material = environment.theme.material(.code)
        ScrollView(.horizontal, showsIndicators: false) {
            Text(code)
                .font(environment.theme.typography(.mono).font)
                .foregroundStyle(environment.theme.color(.textPrimary))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14)
        }
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
