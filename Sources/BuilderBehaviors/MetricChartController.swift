import Combine
import Foundation

@MainActor
public final class MetricChartController: ObservableObject {
    @Published public var state: AsyncContentState
    @Published public private(set) var pinnedSelection: MetricSelection?
    @Published public private(set) var hoverSelection: MetricSelection?
    @Published public private(set) var visibleSeriesIDs: Set<String>
    @Published public private(set) var focusedDatumID: String?

    public let announcementCenter: AnnouncementCenter?

    private let visibleSeriesStore: UserDefaultsValueStore<Set<String>>?
    private var availableSelections: [MetricSelection]

    public init(
        state: AsyncContentState = .ready,
        visibleSeriesIDs: Set<String> = [],
        visibleSeriesStore: UserDefaultsValueStore<Set<String>>? = nil,
        announcementCenter: AnnouncementCenter? = nil
    ) {
        self.state = state
        self.visibleSeriesStore = visibleSeriesStore
        self.announcementCenter = announcementCenter
        self.availableSelections = []
        self.visibleSeriesIDs = visibleSeriesStore?.load() ?? visibleSeriesIDs
    }

    public var activeSelection: MetricSelection? {
        pinnedSelection ?? hoverSelection
    }

    public func configure(
        availableSelections: [MetricSelection],
        defaultVisibleSeriesIDs: Set<String> = []
    ) {
        self.availableSelections = availableSelections

        if visibleSeriesIDs.isEmpty {
            let fallback = defaultVisibleSeriesIDs.isEmpty
                ? Set(availableSelections.map(\.seriesID))
                : defaultVisibleSeriesIDs
            visibleSeriesIDs = fallback
            visibleSeriesStore?.save(fallback)
        }

        if let pinnedSelection, !visibleSeriesIDs.contains(pinnedSelection.seriesID) {
            self.pinnedSelection = nil
        }

        if let hoverSelection, !visibleSeriesIDs.contains(hoverSelection.seriesID) {
            self.hoverSelection = nil
        }

        focusedDatumID = activeSelection?.id
    }

    public func preview(_ selection: MetricSelection?) {
        hoverSelection = selection
        focusedDatumID = activeSelection?.id
    }

    public func pin(_ selection: MetricSelection?) {
        pinnedSelection = selection
        focusedDatumID = selection?.id

        if let selection {
            announcementCenter?.announce("\(selection.seriesTitle), \(selection.label), \(selection.formattedValue).")
        } else {
            announcementCenter?.announce("Metric selection cleared.")
        }
    }

    public func clearPinnedSelection() {
        pin(nil)
    }

    public func setVisibleSeriesIDs(_ ids: Set<String>) {
        visibleSeriesIDs = ids
        visibleSeriesStore?.save(ids)
    }

    public func toggleSeries(id: String, label: String) {
        if visibleSeriesIDs.contains(id) {
            visibleSeriesIDs.remove(id)
            announcementCenter?.announce("\(label) hidden.")
        } else {
            visibleSeriesIDs.insert(id)
            announcementCenter?.announce("\(label) shown.")
        }
        visibleSeriesStore?.save(visibleSeriesIDs)

        if let pinnedSelection, !visibleSeriesIDs.contains(pinnedSelection.seriesID) {
            self.pinnedSelection = nil
        }
        if let hoverSelection, !visibleSeriesIDs.contains(hoverSelection.seriesID) {
            self.hoverSelection = nil
        }
        focusedDatumID = activeSelection?.id
    }

    public func moveSelectionForward() {
        moveSelection(step: 1)
    }

    public func moveSelectionBackward() {
        moveSelection(step: -1)
    }

    private func moveSelection(step: Int) {
        let selections = availableSelections.filter { visibleSeriesIDs.contains($0.seriesID) }
        guard !selections.isEmpty else { return }

        let currentID = activeSelection?.id
        let currentIndex = selections.firstIndex { $0.id == currentID } ?? (step > 0 ? -1 : 0)
        let nextIndex = min(max(currentIndex + step, 0), selections.count - 1)
        pin(selections[nextIndex])
    }
}

