import SwiftUI

public enum DensityMode: String, CaseIterable, Identifiable, Sendable {
    case compact
    case `default`
    case comfortable

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .compact: "Compact"
        case .default: "Default"
        case .comfortable: "Comfortable"
        }
    }

    public var spacingMultiplier: CGFloat {
        switch self {
        case .compact: 0.86
        case .default: 1.0
        case .comfortable: 1.15
        }
    }

    public var controlHeightOffset: CGFloat {
        switch self {
        case .compact: -4
        case .default: 0
        case .comfortable: 4
        }
    }
}
