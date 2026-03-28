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
    public let state: AsyncContentState
    public let points: [Point]
    public let selection: Binding<MetricSelection?>?
    public let valueFormatter: (Double) -> String

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        state: AsyncContentState = .ready,
        points: [Point],
        selection: Binding<MetricSelection?>? = nil,
        valueFormatter: @escaping (Double) -> String = defaultMetricValueFormatter
    ) {
        self.environment = environment
        self.title = title
        self.state = state
        self.points = points
        self.selection = selection
        self.valueFormatter = valueFormatter
    }

    public init(environment: DesignSystemEnvironment, title: String, points: [Point]) {
        self.init(
            environment: environment,
            title: title,
            state: .ready,
            points: points,
            selection: nil,
            valueFormatter: defaultMetricValueFormatter
        )
    }

    public var body: some View {
        BarChartPanel(
            environment: environment,
            title: title,
            state: state,
            series: points.map { point in
                MetricSeries(
                    id: point.id,
                    title: point.label,
                    color: point.color,
                    points: [.init(id: point.id, label: point.label, value: point.value)]
                )
            },
            showsLegend: false,
            selection: selection,
            valueFormatter: valueFormatter,
            height: 180
        )
    }
}
