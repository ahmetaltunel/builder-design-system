import Foundation

enum ShowcaseRoute: String, CaseIterable, Identifiable {
    case home
    case components
    case recipes
    case foundations
    case lab
    case settings

    static var primaryRoutes: [ShowcaseRoute] {
        [.home, .components, .recipes, .foundations, .lab]
    }

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: "Home"
        case .components: "Components"
        case .recipes: "Recipes"
        case .foundations: "Foundations"
        case .lab: "Lab"
        case .settings: "Settings"
        }
    }

    var symbol: String {
        switch self {
        case .home: "house"
        case .components: "square.grid.3x3"
        case .recipes: "square.on.square.squareshape.controlhandles"
        case .foundations: "square.stack.3d.up"
        case .lab: "flask"
        case .settings: "gearshape"
        }
    }
}
