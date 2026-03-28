import SwiftUI
import BuilderFoundation
import BuilderBehaviors

public struct MixedChartPanel: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let subtitle: String?
    public let state: AsyncContentState
    public let barSeries: [MetricSeries]
    public let lineSeries: [MetricSeries]
    public let showsLegend: Bool
    public let chartController: MetricChartController?
    public let selection: Binding<MetricSelection?>?
    public let visibleSeriesIDs: Binding<Set<String>>?
    public let valueFormatter: (Double) -> String
    public let height: CGFloat

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        state: AsyncContentState = .ready,
        barSeries: [MetricSeries],
        lineSeries: [MetricSeries],
        showsLegend: Bool = true,
        chartController: MetricChartController? = nil,
        selection: Binding<MetricSelection?>? = nil,
        visibleSeriesIDs: Binding<Set<String>>? = nil,
        valueFormatter: @escaping (Double) -> String = defaultMetricValueFormatter,
        height: CGFloat = 220
    ) {
        self.environment = environment
        self.title = title
        self.subtitle = subtitle
        self.state = state
        self.barSeries = barSeries
        self.lineSeries = lineSeries
        self.showsLegend = showsLegend
        self.chartController = chartController
        self.selection = selection
        self.visibleSeriesIDs = visibleSeriesIDs
        self.valueFormatter = valueFormatter
        self.height = height
    }

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        state: AsyncContentState = .ready,
        barSeries: [MetricSeries],
        lineSeries: [MetricSeries],
        controller: MetricChartController,
        showsLegend: Bool = true,
        valueFormatter: @escaping (Double) -> String = defaultMetricValueFormatter,
        height: CGFloat = 220
    ) {
        self.init(
            environment: environment,
            title: title,
            subtitle: subtitle,
            state: state,
            barSeries: barSeries,
            lineSeries: lineSeries,
            showsLegend: showsLegend,
            chartController: controller,
            selection: Binding(
                get: { controller.pinnedSelection },
                set: { controller.pin($0) }
            ),
            visibleSeriesIDs: Binding(
                get: { controller.visibleSeriesIDs },
                set: { controller.setVisibleSeriesIDs($0) }
            ),
            valueFormatter: valueFormatter,
            height: height
        )
    }

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        barSeries: [MetricSeries],
        lineSeries: [MetricSeries],
        showsLegend: Bool = true,
        height: CGFloat = 220
    ) {
        self.init(
            environment: environment,
            title: title,
            subtitle: subtitle,
            state: .ready,
            barSeries: barSeries,
            lineSeries: lineSeries,
            showsLegend: showsLegend,
            selection: nil,
            visibleSeriesIDs: nil,
            valueFormatter: defaultMetricValueFormatter,
            height: height
        )
    }

    public var body: some View {
        CartesianMetricChartPanel(
            environment: environment,
            title: title,
            subtitle: subtitle,
            state: state,
            barSeries: barSeries,
            lineSeries: lineSeries,
            style: .mixed,
            showsLegend: showsLegend,
            chartController: chartController,
            externalSelection: selection,
            externalVisibleSeriesIDs: visibleSeriesIDs,
            valueFormatter: valueFormatter,
            height: height
        )
    }
}
