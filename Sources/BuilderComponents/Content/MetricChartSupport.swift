import Charts
import Foundation
import SwiftUI
import BuilderFoundation

enum CartesianMetricChartStyle {
    case bar
    case line
    case area
    case mixed
}

private enum MetricDatumStyle {
    case bar
    case line
    case area
    case slice
}

private struct MetricChartDatum: Identifiable {
    let id: String
    let seriesID: String
    let seriesTitle: String
    let datumID: String
    let label: String
    let value: Double
    let color: Color
    let style: MetricDatumStyle

    init(
        seriesID: String,
        seriesTitle: String,
        datumID: String,
        label: String,
        value: Double,
        color: Color,
        style: MetricDatumStyle
    ) {
        self.id = "\(seriesID)::\(datumID)"
        self.seriesID = seriesID
        self.seriesTitle = seriesTitle
        self.datumID = datumID
        self.label = label
        self.value = value
        self.color = color
        self.style = style
    }

    func selection(valueFormatter: (Double) -> String) -> MetricSelection {
        MetricSelection(
            kind: style == .slice ? .slice : .point,
            seriesID: seriesID,
            seriesTitle: seriesTitle,
            datumID: datumID,
            label: label,
            value: value,
            formattedValue: valueFormatter(value)
        )
    }
}

struct MetricLegendEntry: Identifiable {
    let id: String
    let label: String
    let color: Color
    let isVisible: Bool
    let action: (() -> Void)?

    init(
        id: String,
        label: String,
        color: Color,
        isVisible: Bool = true,
        action: (() -> Void)? = nil
    ) {
        self.id = id
        self.label = label
        self.color = color
        self.isVisible = isVisible
        self.action = action
    }
}

struct MetricChartContainer<Content: View>: View {
    let environment: DesignSystemEnvironment
    let title: String
    let subtitle: String?
    let state: AsyncContentState
    let legendItems: [MetricLegendEntry]
    let selection: MetricSelection?
    let selectionColor: Color?
    let liveAnnouncement: String?
    let emptyActionTitle: String?
    let onEmptyAction: (() -> Void)?
    let errorActionTitle: String?
    let onErrorAction: (() -> Void)?
    let content: Content

    init(
        environment: DesignSystemEnvironment,
        title: String,
        subtitle: String? = nil,
        state: AsyncContentState = .ready,
        legendItems: [MetricLegendEntry] = [],
        selection: MetricSelection? = nil,
        selectionColor: Color? = nil,
        liveAnnouncement: String? = nil,
        emptyActionTitle: String? = nil,
        onEmptyAction: (() -> Void)? = nil,
        errorActionTitle: String? = nil,
        onErrorAction: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.environment = environment
        self.title = title
        self.subtitle = subtitle
        self.state = state
        self.legendItems = legendItems
        self.selection = selection
        self.selectionColor = selectionColor
        self.liveAnnouncement = liveAnnouncement
        self.emptyActionTitle = emptyActionTitle
        self.onEmptyAction = onEmptyAction
        self.errorActionTitle = errorActionTitle
        self.onErrorAction = onErrorAction
        self.content = content()
    }

    var body: some View {
        PanelSurface(environment: environment, title: title, subtitle: subtitle) {
            AsyncContentRenderer(
                environment: environment,
                state: state,
                emptyActionTitle: emptyActionTitle,
                onEmptyAction: onEmptyAction,
                errorActionTitle: errorActionTitle,
                onErrorAction: onErrorAction
            ) {
                content

                if let selection {
                    MetricSelectionSummary(
                        environment: environment,
                        selection: selection,
                        color: selectionColor ?? environment.theme.color(.accentPrimary)
                    )
                }

                if !legendItems.isEmpty {
                    MetricLegendView(environment: environment, entries: legendItems)
                }

                if let liveAnnouncement, !liveAnnouncement.isEmpty {
                    AccessibilityAnnouncementRegion(message: liveAnnouncement)
                }
            }
        }
    }
}

private struct MetricLegendView: View {
    let environment: DesignSystemEnvironment
    let entries: [MetricLegendEntry]

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 10)], spacing: 10) {
            ForEach(entries) { entry in
                Group {
                    if let action = entry.action {
                        Button(action: action) {
                            legendCard(for: entry)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(entry.label)
                        .accessibilityValue(entry.isVisible ? "Visible" : "Hidden")
                        .accessibilityHint("Toggle metric visibility")
                    } else {
                        legendCard(for: entry)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func legendCard(for entry: MetricLegendEntry) -> some View {
        HStack(spacing: 8) {
            Circle()
                .fill(entry.color)
                .frame(width: 10, height: 10)

            Text(entry.label)
                .font(environment.theme.typography(.caption).font)
                .foregroundStyle(environment.theme.color(.textSecondary))
                .lineLimit(1)

            Spacer(minLength: 0)

            if entry.action != nil {
                Image(systemName: entry.isVisible ? "eye" : "eye.slash")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(environment.theme.color(.textMuted))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                .fill(environment.theme.color(.inputSurface))
        )
        .overlay(
            RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
        )
        .opacity(entry.isVisible ? 1 : 0.52)
    }
}

private struct MetricSelectionSummary: View {
    let environment: DesignSystemEnvironment
    let selection: MetricSelection
    let color: Color

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)

            VStack(alignment: .leading, spacing: 3) {
                Text(selection.seriesTitle)
                    .font(environment.theme.typography(.captionStrong).font)
                    .foregroundStyle(environment.theme.color(.textSecondary))

                Text(selection.label)
                    .font(environment.theme.typography(.bodyStrong).font)
                    .foregroundStyle(environment.theme.color(.textPrimary))
            }

            Spacer(minLength: 0)

            Text(selection.formattedValue)
                .font(environment.theme.typography(.bodyStrong).font)
                .foregroundStyle(environment.theme.color(.textPrimary))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                .fill(environment.theme.color(.inputSurface))
        )
        .overlay(
            RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(selection.seriesTitle), \(selection.label), \(selection.formattedValue)")
    }
}

private struct MetricAnnotationLabel: View {
    let environment: DesignSystemEnvironment
    let selection: MetricSelection
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(selection.formattedValue)
                .font(environment.theme.typography(.captionStrong).font)
                .foregroundStyle(environment.theme.color(.textPrimary))

            Text("\(selection.seriesTitle) · \(selection.label)")
                .font(environment.theme.typography(.caption).font)
                .foregroundStyle(environment.theme.color(.textSecondary))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                .fill(environment.theme.color(.groupedSurface))
        )
        .overlay(
            RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                .stroke(color.opacity(environment.mode == .dark ? 0.7 : 0.55), lineWidth: 1)
        )
    }
}

private enum MetricChartValueFormatting {
    static func format(_ value: Double) -> String {
        if value.rounded() == value {
            return "\(Int(value))"
        }
        return String(format: "%.1f", value)
    }
}

struct CartesianMetricChartPanel: View {
    let environment: DesignSystemEnvironment
    let title: String
    let subtitle: String?
    let state: AsyncContentState
    let barSeries: [MetricSeries]
    let lineSeries: [MetricSeries]
    let style: CartesianMetricChartStyle
    let showsLegend: Bool
    let externalSelection: Binding<MetricSelection?>?
    let externalVisibleSeriesIDs: Binding<Set<String>>?
    let valueFormatter: (Double) -> String
    let height: CGFloat

    @State private var localPinnedSelection: MetricSelection?
    @State private var localVisibleSeriesIDs: Set<String> = []
    @State private var hasInitializedLocalVisibleSeriesIDs = false
    @State private var hoveredSelection: MetricSelection?
    @State private var liveAnnouncement: String?

    var body: some View {
        MetricChartContainer(
            environment: environment,
            title: title,
            subtitle: subtitle,
            state: state,
            legendItems: showsLegend ? legendItems : [],
            selection: activeSelection,
            selectionColor: activeSelectionColor,
            liveAnnouncement: liveAnnouncement
        ) {
            if resolvedVisibleSeriesIDs.isEmpty && !availableSeriesIDs.isEmpty {
                EmptyStateView(
                    environment: environment,
                    title: "No visible series",
                    message: "Select at least one legend item to restore the chart.",
                    symbol: "line.3.horizontal.decrease.circle",
                    actionTitle: "Show all",
                    action: restoreAllSeries
                )
            } else {
                decoratedChart
            }
        }
        .onAppear {
            if externalVisibleSeriesIDs == nil && !hasInitializedLocalVisibleSeriesIDs {
                localVisibleSeriesIDs = availableSeriesIDs
                hasInitializedLocalVisibleSeriesIDs = true
            }
        }
        .onChange(of: resolvedVisibleSeriesIDs) { _, newValue in
            sanitizeSelection(for: newValue)
        }
        .onChange(of: state) { _, newValue in
            if !newValue.isReady {
                hoveredSelection = nil
            }
        }
        .onExitCommand {
            guard pinnedSelection != nil else { return }
            hoveredSelection = nil
            setPinnedSelection(nil)
            updateAnnouncement("Chart selection cleared.")
        }
    }

    private var decoratedChart: some View {
        Chart {
            switch style {
            case .bar:
                barMarks(for: visibleBarSeries, grouped: true, opacity: 1)
            case .line:
                lineMarks(for: visibleLineSeries, includesArea: false)
            case .area:
                lineMarks(for: visibleLineSeries, includesArea: true)
            case .mixed:
                barMarks(for: visibleBarSeries, grouped: true, opacity: environment.mode == .dark ? 0.74 : 0.84)
                lineMarks(for: visibleLineSeries, includesArea: false)
            }
        }
        .chartLegend(.hidden)
        .chartXAxis {
            AxisMarks(values: .automatic) { _ in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                    .foregroundStyle(environment.theme.color(.subtleBorder))
                AxisValueLabel()
                    .foregroundStyle(environment.theme.color(.textSecondary))
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { _ in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                    .foregroundStyle(environment.theme.color(.subtleBorder))
                AxisValueLabel()
                    .foregroundStyle(environment.theme.color(.textMuted))
            }
        }
        .chartOverlay { proxy in
            GeometryReader { geometry in
                if let plotFrame = proxy.plotFrame {
                    let frame = geometry[plotFrame]
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .onContinuousHover { phase in
                            handleHoverPhase(phase, frame: frame)
                        }
                        .gesture(
                            SpatialTapGesture()
                                .onEnded { value in
                                    handleTap(at: value.location, frame: frame)
                                }
                        )
                }
            }
        }
        .frame(height: height)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(title)
        .accessibilityHint("Hover to preview a metric. Click to pin the current metric. Press Escape to clear the pinned selection.")
    }

    @ChartContentBuilder
    private func barMarks(
        for seriesCollection: [MetricSeries],
        grouped: Bool,
        opacity: Double
    ) -> some ChartContent {
        ForEach(seriesCollection) { series in
            ForEach(series.points) { point in
                let datum = datumForPoint(point, in: series, style: .bar)
                let isSelected = isActiveSelection(datum)

                BarMark(
                    x: .value("Label", point.label),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(series.color.opacity(opacity))
                .position(by: grouped ? .value("Series", series.title) : .value("Series", ""))
                .cornerRadius(5)
                .annotation(position: .top, alignment: .center) {
                    if isSelected, let selection = activeSelection {
                        MetricAnnotationLabel(environment: environment, selection: selection, color: series.color)
                    }
                }
            }
        }
    }

    @ChartContentBuilder
    private func lineMarks(
        for seriesCollection: [MetricSeries],
        includesArea: Bool
    ) -> some ChartContent {
        ForEach(seriesCollection) { series in
            ForEach(series.points) { point in
                let datum = datumForPoint(point, in: series, style: includesArea ? .area : .line)
                let isSelected = isActiveSelection(datum)

                if includesArea {
                    AreaMark(
                        x: .value("Label", point.label),
                        y: .value("Value", point.value)
                    )
                    .foregroundStyle(series.color.opacity(environment.mode == .dark ? 0.24 : 0.18))
                    .interpolationMethod(.catmullRom)
                }

                LineMark(
                    x: .value("Label", point.label),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(series.color)
                .interpolationMethod(.catmullRom)
                .lineStyle(StrokeStyle(lineWidth: includesArea ? 2 : 2.5))

                PointMark(
                    x: .value("Label", point.label),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(series.color)
                .symbolSize(isSelected ? 90 : 40)
                .annotation(position: .top, alignment: .center) {
                    if isSelected, let selection = activeSelection {
                        MetricAnnotationLabel(environment: environment, selection: selection, color: series.color)
                    }
                }
            }
        }
    }

    private var availableSeriesIDs: Set<String> {
        Set((barSeries + lineSeries).map(\.id))
    }

    private var resolvedVisibleSeriesIDs: Set<String> {
        if let externalVisibleSeriesIDs {
            return externalVisibleSeriesIDs.wrappedValue.intersection(availableSeriesIDs)
        }

        guard hasInitializedLocalVisibleSeriesIDs else {
            return availableSeriesIDs
        }

        return localVisibleSeriesIDs.intersection(availableSeriesIDs)
    }

    private var visibleBarSeries: [MetricSeries] {
        barSeries.filter { resolvedVisibleSeriesIDs.contains($0.id) }
    }

    private var visibleLineSeries: [MetricSeries] {
        lineSeries.filter { resolvedVisibleSeriesIDs.contains($0.id) }
    }

    private var visibleData: [MetricChartDatum] {
        visibleBarSeries.flatMap { series in
            series.points.map { datumForPoint($0, in: series, style: .bar) }
        } + visibleLineSeries.flatMap { series in
            series.points.map { datumForPoint($0, in: series, style: style == .area ? .area : .line) }
        }
    }

    private var legendItems: [MetricLegendEntry] {
        (barSeries + lineSeries).map { series in
            MetricLegendEntry(
                id: series.id,
                label: series.title,
                color: series.color,
                isVisible: resolvedVisibleSeriesIDs.contains(series.id)
            ) {
                toggleSeriesVisibility(for: series.id, label: series.title)
            }
        }
    }

    private var pinnedSelection: MetricSelection? {
        externalSelection?.wrappedValue ?? localPinnedSelection
    }

    private var activeSelection: MetricSelection? {
        pinnedSelection ?? hoveredSelection
    }

    private var activeSelectionColor: Color? {
        guard let activeSelection else { return nil }
        return color(for: activeSelection)
    }

    private func datumForPoint(
        _ point: MetricPoint,
        in series: MetricSeries,
        style: MetricDatumStyle
    ) -> MetricChartDatum {
        MetricChartDatum(
            seriesID: series.id,
            seriesTitle: series.title,
            datumID: point.id,
            label: point.label,
            value: point.value,
            color: series.color,
            style: style
        )
    }

    private func setPinnedSelection(_ selection: MetricSelection?) {
        if let externalSelection {
            externalSelection.wrappedValue = selection
        } else {
            localPinnedSelection = selection
        }
    }

    private func updateVisibleSeriesIDs(_ seriesIDs: Set<String>) {
        let resolved = seriesIDs.intersection(availableSeriesIDs)
        if let externalVisibleSeriesIDs {
            externalVisibleSeriesIDs.wrappedValue = resolved
        } else {
            localVisibleSeriesIDs = resolved
            hasInitializedLocalVisibleSeriesIDs = true
        }
    }

    private func restoreAllSeries() {
        updateVisibleSeriesIDs(availableSeriesIDs)
        updateAnnouncement("All series shown in \(title).")
    }

    private func sanitizeSelection(for visibleSeriesIDs: Set<String>) {
        if let pinnedSelection, !visibleSeriesIDs.contains(pinnedSelection.seriesID) {
            setPinnedSelection(nil)
            updateAnnouncement("Chart selection cleared.")
        }

        if let hoveredSelection, !visibleSeriesIDs.contains(hoveredSelection.seriesID) {
            self.hoveredSelection = nil
        }
    }

    private func toggleSeriesVisibility(for seriesID: String, label: String) {
        var next = resolvedVisibleSeriesIDs
        if next.contains(seriesID) {
            next.remove(seriesID)
            updateAnnouncement("\(label) hidden in \(title).")
        } else {
            next.insert(seriesID)
            updateAnnouncement("\(label) shown in \(title).")
        }
        updateVisibleSeriesIDs(next)
    }

    private func color(for selection: MetricSelection) -> Color? {
        visibleData.first(where: { $0.id == selection.id })?.color
    }

    private func isActiveSelection(_ datum: MetricChartDatum) -> Bool {
        activeSelection?.id == datum.id
    }

    private func handleHoverPhase(
        _ phase: HoverPhase,
        frame: CGRect
    ) {
        guard state.isReady else {
            hoveredSelection = nil
            return
        }

        switch phase {
        case .active(let location):
            hoveredSelection = selectionForCartesianLocation(location, frame: frame)
        case .ended:
            hoveredSelection = nil
        }
    }

    private func handleTap(
        at location: CGPoint,
        frame: CGRect
    ) {
        guard state.isReady else { return }

        if let nextSelection = selectionForCartesianLocation(location, frame: frame) {
            hoveredSelection = nextSelection
            setPinnedSelection(nextSelection)
            updateAnnouncement("\(nextSelection.seriesTitle), \(nextSelection.label), \(nextSelection.formattedValue) selected.")
        } else if frame.contains(location) {
            hoveredSelection = nil
            setPinnedSelection(nil)
            updateAnnouncement("Chart selection cleared.")
        }
    }

    private func updateAnnouncement(_ message: String) {
        liveAnnouncement = message
        postAccessibilityAnnouncement(message)
    }

    private func selectionForCartesianLocation(
        _ location: CGPoint,
        frame: CGRect
    ) -> MetricSelection? {
        guard frame.contains(location) else { return nil }

        let localPoint = CGPoint(x: location.x - frame.minX, y: location.y - frame.minY)
        let data = visibleData
        let labels = orderedLabels(from: data)

        guard !data.isEmpty, !labels.isEmpty else { return nil }

        let label = nearestLabel(to: localPoint.x, within: frame.size, labels: labels)
        let candidates = data.filter { $0.label == label }
        let ceiling = max(data.map(\.value).max() ?? 1, 1)

        guard let closest = candidates.min(by: {
            abs(projectedY(for: $0.value, maxValue: ceiling, height: frame.height) - localPoint.y)
            < abs(projectedY(for: $1.value, maxValue: ceiling, height: frame.height) - localPoint.y)
        }) else {
            return nil
        }

        return closest.selection(valueFormatter: valueFormatter)
    }

    private func orderedLabels(from data: [MetricChartDatum]) -> [String] {
        var labels: [String] = []
        var seen: Set<String> = []

        for datum in data where !seen.contains(datum.label) {
            labels.append(datum.label)
            seen.insert(datum.label)
        }

        return labels
    }

    private func nearestLabel(
        to x: CGFloat,
        within size: CGSize,
        labels: [String]
    ) -> String {
        guard labels.count > 1 else {
            return labels.first ?? ""
        }

        let bandWidth = size.width / CGFloat(labels.count)
        let clampedX = min(max(x, 0), size.width)
        let index = min(max(Int((clampedX / max(bandWidth, 1)).rounded(.down)), 0), labels.count - 1)
        return labels[index]
    }

    private func projectedY(
        for value: Double,
        maxValue: Double,
        height: CGFloat
    ) -> CGFloat {
        let ratio = max(0, min(value / max(maxValue, 1), 1))
        return height * CGFloat(1 - ratio)
    }
}

struct DonutMetricChartPanel: View {
    let environment: DesignSystemEnvironment
    let title: String
    let subtitle: String?
    let state: AsyncContentState
    let slices: [MetricSlice]
    let showsLegend: Bool
    let externalSelection: Binding<MetricSelection?>?
    let externalVisibleSeriesIDs: Binding<Set<String>>?
    let valueFormatter: (Double) -> String
    let height: CGFloat

    @State private var localPinnedSelection: MetricSelection?
    @State private var localVisibleSeriesIDs: Set<String> = []
    @State private var hasInitializedLocalVisibleSeriesIDs = false
    @State private var hoveredSelection: MetricSelection?
    @State private var liveAnnouncement: String?

    var body: some View {
        MetricChartContainer(
            environment: environment,
            title: title,
            subtitle: subtitle,
            state: state,
            legendItems: showsLegend ? legendItems : [],
            selection: activeSelection,
            selectionColor: activeSelectionColor,
            liveAnnouncement: liveAnnouncement
        ) {
            if resolvedVisibleSeriesIDs.isEmpty && !availableSliceIDs.isEmpty {
                EmptyStateView(
                    environment: environment,
                    title: "No visible segments",
                    message: "Select at least one legend item to restore the chart.",
                    symbol: "chart.pie",
                    actionTitle: "Show all",
                    action: restoreAllSlices
                )
            } else {
                decoratedChart
            }
        }
        .onAppear {
            if externalVisibleSeriesIDs == nil && !hasInitializedLocalVisibleSeriesIDs {
                localVisibleSeriesIDs = availableSliceIDs
                hasInitializedLocalVisibleSeriesIDs = true
            }
        }
        .onChange(of: resolvedVisibleSeriesIDs) { _, newValue in
            sanitizeSelection(for: newValue)
        }
        .onChange(of: state) { _, newValue in
            if !newValue.isReady {
                hoveredSelection = nil
            }
        }
        .onExitCommand {
            guard pinnedSelection != nil else { return }
            hoveredSelection = nil
            setPinnedSelection(nil)
            updateAnnouncement("Chart selection cleared.")
        }
    }

    private var decoratedChart: some View {
        Chart(visibleSlices) { slice in
            let selection = selectionForSlice(slice)
            let isSelected = activeSelection?.id == selection.id

            SectorMark(
                angle: .value("Value", slice.value),
                innerRadius: .ratio(0.58),
                outerRadius: .ratio(isSelected ? 1.0 : 0.96),
                angularInset: 2
            )
            .foregroundStyle(slice.color.opacity(isSelected ? 1 : (environment.mode == .dark ? 0.9 : 0.84)))
        }
        .chartLegend(.hidden)
        .chartBackground { proxy in
            GeometryReader { geometry in
                if let plotFrame = proxy.plotFrame {
                    let frame = geometry[plotFrame]
                    VStack(spacing: 3) {
                        Text(centerTitle)
                            .font(environment.theme.typography(.titleCompact).font)
                            .foregroundStyle(environment.theme.color(.textPrimary))
                        Text(centerSubtitle)
                            .font(environment.theme.typography(.caption).font)
                            .foregroundStyle(environment.theme.color(.textSecondary))
                    }
                    .frame(width: frame.width, height: frame.height)
                }
            }
        }
        .chartOverlay { proxy in
            GeometryReader { geometry in
                if let plotFrame = proxy.plotFrame {
                    let frame = geometry[plotFrame]
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .onContinuousHover { phase in
                            handleHoverPhase(phase, frame: frame)
                        }
                        .gesture(
                            SpatialTapGesture()
                                .onEnded { value in
                                    handleTap(at: value.location, frame: frame)
                                }
                        )
                }
            }
        }
        .frame(height: height)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(title)
        .accessibilityHint("Hover to preview a segment. Click to pin the current segment. Press Escape to clear the pinned selection.")
    }

    private var availableSliceIDs: Set<String> {
        Set(slices.map(\.id))
    }

    private var resolvedVisibleSeriesIDs: Set<String> {
        if let externalVisibleSeriesIDs {
            return externalVisibleSeriesIDs.wrappedValue.intersection(availableSliceIDs)
        }

        guard hasInitializedLocalVisibleSeriesIDs else {
            return availableSliceIDs
        }

        return localVisibleSeriesIDs.intersection(availableSliceIDs)
    }

    private var visibleSlices: [MetricSlice] {
        slices.filter { resolvedVisibleSeriesIDs.contains($0.id) }
    }

    private var legendItems: [MetricLegendEntry] {
        slices.map { slice in
            MetricLegendEntry(
                id: slice.id,
                label: slice.title,
                color: slice.color,
                isVisible: resolvedVisibleSeriesIDs.contains(slice.id)
            ) {
                toggleSliceVisibility(for: slice.id, label: slice.title)
            }
        }
    }

    private var pinnedSelection: MetricSelection? {
        externalSelection?.wrappedValue ?? localPinnedSelection
    }

    private var activeSelection: MetricSelection? {
        pinnedSelection ?? hoveredSelection
    }

    private var activeSelectionColor: Color? {
        guard let activeSelection else { return nil }
        return visibleSlices.first(where: { $0.id == activeSelection.seriesID })?.color
    }

    private var centerTitle: String {
        activeSelection?.formattedValue ?? valueFormatter(totalValue)
    }

    private var centerSubtitle: String {
        activeSelection?.label ?? "total"
    }

    private var totalValue: Double {
        visibleSlices.reduce(0) { $0 + $1.value }
    }

    private func setPinnedSelection(_ selection: MetricSelection?) {
        if let externalSelection {
            externalSelection.wrappedValue = selection
        } else {
            localPinnedSelection = selection
        }
    }

    private func updateVisibleSeriesIDs(_ seriesIDs: Set<String>) {
        let resolved = seriesIDs.intersection(availableSliceIDs)
        if let externalVisibleSeriesIDs {
            externalVisibleSeriesIDs.wrappedValue = resolved
        } else {
            localVisibleSeriesIDs = resolved
            hasInitializedLocalVisibleSeriesIDs = true
        }
    }

    private func restoreAllSlices() {
        updateVisibleSeriesIDs(availableSliceIDs)
        updateAnnouncement("All segments shown in \(title).")
    }

    private func sanitizeSelection(for visibleSeriesIDs: Set<String>) {
        if let pinnedSelection, !visibleSeriesIDs.contains(pinnedSelection.seriesID) {
            setPinnedSelection(nil)
            updateAnnouncement("Chart selection cleared.")
        }

        if let hoveredSelection, !visibleSeriesIDs.contains(hoveredSelection.seriesID) {
            self.hoveredSelection = nil
        }
    }

    private func selectionForSlice(_ slice: MetricSlice) -> MetricSelection {
        MetricSelection(
            kind: .slice,
            seriesID: slice.id,
            seriesTitle: slice.title,
            datumID: slice.id,
            label: slice.title,
            value: slice.value,
            formattedValue: valueFormatter(slice.value)
        )
    }

    private func toggleSliceVisibility(for sliceID: String, label: String) {
        var next = resolvedVisibleSeriesIDs
        if next.contains(sliceID) {
            next.remove(sliceID)
            updateAnnouncement("\(label) hidden in \(title).")
        } else {
            next.insert(sliceID)
            updateAnnouncement("\(label) shown in \(title).")
        }
        updateVisibleSeriesIDs(next)
    }

    private func handleHoverPhase(
        _ phase: HoverPhase,
        frame: CGRect
    ) {
        guard state.isReady else {
            hoveredSelection = nil
            return
        }

        switch phase {
        case .active(let location):
            hoveredSelection = selectionForDonutLocation(location, frame: frame)
        case .ended:
            hoveredSelection = nil
        }
    }

    private func handleTap(
        at location: CGPoint,
        frame: CGRect
    ) {
        guard state.isReady else { return }

        if let nextSelection = selectionForDonutLocation(location, frame: frame) {
            hoveredSelection = nextSelection
            setPinnedSelection(nextSelection)
            updateAnnouncement("\(nextSelection.label), \(nextSelection.formattedValue) selected.")
        } else if frame.contains(location) {
            hoveredSelection = nil
            setPinnedSelection(nil)
            updateAnnouncement("Chart selection cleared.")
        }
    }

    private func updateAnnouncement(_ message: String) {
        liveAnnouncement = message
        postAccessibilityAnnouncement(message)
    }

    private func selectionForDonutLocation(
        _ location: CGPoint,
        frame: CGRect
    ) -> MetricSelection? {
        guard frame.contains(location), !visibleSlices.isEmpty else { return nil }

        let center = CGPoint(x: frame.midX, y: frame.midY)
        let vectorX = location.x - center.x
        let vectorY = center.y - location.y
        let distance = sqrt((vectorX * vectorX) + (vectorY * vectorY))
        let outerRadius = min(frame.width, frame.height) * 0.5
        let innerRadius = outerRadius * 0.58

        guard distance >= innerRadius, distance <= outerRadius else { return nil }

        let rawAngle = atan2(vectorX, vectorY)
        let angle = rawAngle < 0 ? rawAngle + (CGFloat.pi * 2) : rawAngle
        let total = max(totalValue, 0.0001)
        var start: CGFloat = 0

        for slice in visibleSlices {
            let span = CGFloat(slice.value / total) * CGFloat.pi * 2
            let end = start + span
            if angle >= start && angle < end {
                return selectionForSlice(slice)
            }
            start = end
        }

        return selectionForSlice(visibleSlices[visibleSlices.count - 1])
    }
}

public func defaultMetricValueFormatter(_ value: Double) -> String {
    MetricChartValueFormatting.format(value)
}
