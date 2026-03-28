import Foundation

enum SettingsSection: String, CaseIterable, Identifiable {
    case appearance
    case accessibility
    case themeTokens

    var id: String { rawValue }

    var title: String {
        switch self {
        case .appearance: "Appearance"
        case .accessibility: "Accessibility"
        case .themeTokens: "Theme & tokens"
        }
    }

    var symbol: String {
        switch self {
        case .appearance: "sun.max"
        case .accessibility: "figure.roll"
        case .themeTokens: "paintpalette"
        }
    }
}
