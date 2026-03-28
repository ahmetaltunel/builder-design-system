import Foundation

public struct GridSpec: Identifiable, Sendable {
    public let token: GridToken
    public let columns: Int
    public let gutter: CGFloat
    public let margin: CGFloat
    public let maxWidth: CGFloat?
    public let description: String

    public var id: GridToken { token }

    public init(
        token: GridToken,
        columns: Int,
        gutter: CGFloat,
        margin: CGFloat,
        maxWidth: CGFloat?,
        description: String
    ) {
        self.token = token
        self.columns = columns
        self.gutter = gutter
        self.margin = margin
        self.maxWidth = maxWidth
        self.description = description
    }
}
