import SwiftUI

public struct MaterialSpec {
    public let token: MaterialToken
    public let fill: Color
    public let border: Color
    public let elevation: ElevationToken
    public let radius: RadiusToken
    public let borderWidth: CGFloat
    public let fillOpacity: Double
    public let isTranslucent: Bool
    public let isInteractive: Bool

    public init(
        token: MaterialToken,
        fill: Color,
        border: Color,
        elevation: ElevationToken,
        radius: RadiusToken,
        borderWidth: CGFloat = 1,
        fillOpacity: Double = 1,
        isTranslucent: Bool = false,
        isInteractive: Bool = false
    ) {
        self.token = token
        self.fill = fill
        self.border = border
        self.elevation = elevation
        self.radius = radius
        self.borderWidth = borderWidth
        self.fillOpacity = fillOpacity
        self.isTranslucent = isTranslucent
        self.isInteractive = isInteractive
    }
}
