import Foundation
import SwiftUI

public struct IconSpec: Identifiable, Sendable {
    public let token: IconToken
    public let symbol: String
    public let pointSize: CGFloat
    public let weight: Font.Weight
    public let semanticRole: String

    public var id: IconToken { token }

    public init(
        token: IconToken,
        symbol: String,
        pointSize: CGFloat,
        weight: Font.Weight,
        semanticRole: String
    ) {
        self.token = token
        self.symbol = symbol
        self.pointSize = pointSize
        self.weight = weight
        self.semanticRole = semanticRole
    }
}
