import SwiftUI
import BuilderBehaviors

public struct MetricPoint: Identifiable {
    public let id: String
    public let label: String
    public let value: Double

    public init(id: String? = nil, label: String, value: Double) {
        self.id = id ?? label
        self.label = label
        self.value = value
    }
}

public struct MetricSeries: Identifiable {
    public let id: String
    public let title: String
    public let color: Color
    public let points: [MetricPoint]

    public init(id: String? = nil, title: String, color: Color, points: [MetricPoint]) {
        self.id = id ?? title
        self.title = title
        self.color = color
        self.points = points
    }
}

public struct MetricSlice: Identifiable {
    public let id: String
    public let title: String
    public let value: Double
    public let color: Color

    public init(id: String? = nil, title: String, value: Double, color: Color) {
        self.id = id ?? title
        self.title = title
        self.value = value
        self.color = color
    }
}

public typealias MetricSelection = BuilderBehaviors.MetricSelection
