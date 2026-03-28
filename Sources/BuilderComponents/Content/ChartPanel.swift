import Charts
import SwiftUI
import BuilderFoundation

public struct ChartPanel: View {
    public struct Point: Identifiable, Hashable {
        public let id: String
        public let label: String
        public let value: Double
        public let color: Color

        public init(id: String? = nil, label: String, value: Double, color: Color) {
            self.id = id ?? label
            self.label = label
            self.value = value
            self.color = color
        }
    }

    public let environment: DesignSystemEnvironment
    public let title: String
    public let points: [Point]

    public init(environment: DesignSystemEnvironment, title: String, points: [Point]) {
        self.environment = environment
        self.title = title
        self.points = points
    }

    public var body: some View {
        PanelSurface(environment: environment, title: title) {
            Chart(points) { point in
                BarMark(x: .value("Label", point.label), y: .value("Value", point.value))
                    .foregroundStyle(point.color)
                    .cornerRadius(4)
            }
            .frame(height: 180)
        }
    }
}
