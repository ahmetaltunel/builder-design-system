import Foundation

public struct ShadowTokenSpec: Identifiable, @unchecked Sendable {
    public let token: ShadowToken
    public let light: ShadowSpec
    public let dark: ShadowSpec
    public let description: String

    public var id: ShadowToken { token }

    public init(token: ShadowToken, light: ShadowSpec, dark: ShadowSpec, description: String) {
        self.token = token
        self.light = light
        self.dark = dark
        self.description = description
    }
}
