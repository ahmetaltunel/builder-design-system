import SwiftUI

public extension Font.Weight {
    var title: String {
        switch self {
        case .black: "Black"
        case .bold: "Bold"
        case .heavy: "Heavy"
        case .light: "Light"
        case .medium: "Medium"
        case .regular: "Regular"
        case .semibold: "Semibold"
        case .thin: "Thin"
        case .ultraLight: "Ultra Light"
        default: "Regular"
        }
    }
}
