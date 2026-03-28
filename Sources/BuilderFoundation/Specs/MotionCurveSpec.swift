import Foundation

public struct MotionCurveSpec: Identifiable, Sendable {
    public let token: MotionCurveToken
    public let name: String
    public let x1: Double
    public let y1: Double
    public let x2: Double
    public let y2: Double
    public let notes: String

    public var id: MotionCurveToken { token }

    public init(
        token: MotionCurveToken,
        name: String,
        x1: Double,
        y1: Double,
        x2: Double,
        y2: Double,
        notes: String
    ) {
        self.token = token
        self.name = name
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
        self.notes = notes
    }
}
