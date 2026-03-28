import SwiftUI

public enum ThemeMode: String, CaseIterable, Identifiable, Sendable {
    case light
    case dark

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .light: "Light"
        case .dark: "Dark"
        }
    }
}
