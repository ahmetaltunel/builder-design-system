import SwiftUI

public struct TypographySpec: Identifiable {
    public let token: TypographyToken
    public let font: Font
    public let size: CGFloat
    public let weight: Font.Weight
    public let tracking: CGFloat
    public let lineHeight: CGFloat
    public let lineSpacing: CGFloat
    public let isMonospaced: Bool

    public var id: TypographyToken { token }

    public init(
        token: TypographyToken,
        font: Font,
        size: CGFloat,
        weight: Font.Weight,
        tracking: CGFloat,
        lineHeight: CGFloat,
        lineSpacing: CGFloat? = nil,
        isMonospaced: Bool = false
    ) {
        self.token = token
        self.font = font
        self.size = size
        self.weight = weight
        self.tracking = tracking
        self.lineHeight = lineHeight
        self.lineSpacing = lineSpacing ?? max(lineHeight - size, 0)
        self.isMonospaced = isMonospaced
    }
}
