import SwiftUI

public enum ThemeContrast: String, CaseIterable, Identifiable, Sendable {
    case standard
    case increased

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .standard: "Standard"
        case .increased: "Increased"
        }
    }
}
