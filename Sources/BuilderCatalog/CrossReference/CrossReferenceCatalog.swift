extension CatalogContent {
    package static var componentCrossReference: [(catalog: String, swiftUI: String)] {
        components.map { ($0.name, $0.swiftUIType) }
    }
}
