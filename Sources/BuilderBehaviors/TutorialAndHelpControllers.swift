import Combine
import Foundation

public struct TutorialStep: Identifiable, Hashable, Codable, Sendable {
    public enum Status: String, Hashable, Codable, Sendable {
        case upcoming
        case current
        case complete
        case warning
    }

    public let id: String
    public let title: String
    public let detail: String?
    public let status: Status
    public let isOptional: Bool

    public init(
        id: String? = nil,
        title: String,
        detail: String? = nil,
        status: Status = .upcoming,
        isOptional: Bool = false
    ) {
        self.id = id ?? title
        self.title = title
        self.detail = detail
        self.status = status
        self.isOptional = isOptional
    }
}

public struct TutorialProgressState: Codable, Hashable, Sendable {
    let currentStepID: String
    let completedStepIDs: Set<String>
    let skippedStepIDs: Set<String>
}

@MainActor
public final class TutorialFlowController: ObservableObject {
    @Published public private(set) var steps: [TutorialStep]
    @Published public private(set) var currentStepID: String
    @Published public private(set) var completedStepIDs: Set<String>
    @Published public private(set) var skippedStepIDs: Set<String>

    public let announcementCenter: AnnouncementCenter?

    private let progressStore: UserDefaultsValueStore<TutorialProgressState>?

    public init(
        steps: [TutorialStep],
        currentStepID: String? = nil,
        completedStepIDs: Set<String> = [],
        skippedStepIDs: Set<String> = [],
        progressStore: UserDefaultsValueStore<TutorialProgressState>? = nil,
        announcementCenter: AnnouncementCenter? = nil
    ) {
        let restored = progressStore?.load()
        self.steps = steps
        self.currentStepID = restored?.currentStepID
            ?? currentStepID
            ?? steps.first?.id
            ?? ""
        self.completedStepIDs = restored?.completedStepIDs ?? completedStepIDs
        self.skippedStepIDs = restored?.skippedStepIDs ?? skippedStepIDs
        self.progressStore = progressStore
        self.announcementCenter = announcementCenter
    }

    public func selectStep(_ id: String) {
        currentStepID = id
        persist()
        announceCurrentStep()
    }

    public func advance() {
        guard let currentIndex = steps.firstIndex(where: { $0.id == currentStepID }) else { return }
        markComplete(currentStepID)

        let nextIndex = min(currentIndex + 1, steps.count - 1)
        currentStepID = steps[nextIndex].id
        persist()
        announceCurrentStep()
    }

    public func goBack() {
        guard let currentIndex = steps.firstIndex(where: { $0.id == currentStepID }), currentIndex > 0 else { return }
        currentStepID = steps[currentIndex - 1].id
        persist()
        announceCurrentStep()
    }

    public func markComplete(_ id: String? = nil) {
        completedStepIDs.insert(id ?? currentStepID)
        persist()
    }

    public func skipCurrentStep() {
        skippedStepIDs.insert(currentStepID)
        advance()
    }

    private func persist() {
        progressStore?.save(
            .init(
                currentStepID: currentStepID,
                completedStepIDs: completedStepIDs,
                skippedStepIDs: skippedStepIDs
            )
        )
    }

    private func announceCurrentStep() {
        guard
            let index = steps.firstIndex(where: { $0.id == currentStepID }),
            steps.indices.contains(index)
        else { return }

        announcementCenter?.announce("Step \(index + 1) of \(max(steps.count, 1)): \(steps[index].title).")
    }
}

@MainActor
public final class HelpNavigator: ObservableObject {
    @Published public private(set) var topics: [HelpTopic]
    @Published public private(set) var selectedTopicID: String?
    @Published public private(set) var currentTutorialStepID: String?

    public let announcementCenter: AnnouncementCenter?

    private let relatedTopicsByID: [String: [String]]
    private let tutorialTopicMap: [String: String]
    private let selectionStore: UserDefaultsValueStore<String>?

    public init(
        topics: [HelpTopic],
        selectedTopicID: String? = nil,
        relatedTopicsByID: [String: [String]] = [:],
        tutorialTopicMap: [String: String] = [:],
        selectionStore: UserDefaultsValueStore<String>? = nil,
        announcementCenter: AnnouncementCenter? = nil
    ) {
        self.topics = topics
        self.selectedTopicID = selectionStore?.load() ?? selectedTopicID ?? topics.first?.id
        self.relatedTopicsByID = relatedTopicsByID
        self.tutorialTopicMap = tutorialTopicMap
        self.selectionStore = selectionStore
        self.announcementCenter = announcementCenter
    }

    public func selectTopic(_ id: String?) {
        selectedTopicID = id
        selectionStore?.save(id)

        if let id, let topic = topics.first(where: { $0.id == id }) {
            announcementCenter?.announce("\(topic.title) opened.")
        }
    }

    public func relatedTopics() -> [HelpTopic] {
        guard
            let selectedTopicID,
            let ids = relatedTopicsByID[selectedTopicID]
        else { return [] }

        return topics.filter { ids.contains($0.id) }
    }

    public func sync(withTutorialStepID id: String?) {
        currentTutorialStepID = id
        guard let id, let topicID = tutorialTopicMap[id] else { return }
        selectTopic(topicID)
    }

    public func nextRelatedTopic() {
        let related = relatedTopics()
        guard
            !related.isEmpty,
            let currentID = selectedTopicID,
            let index = related.firstIndex(where: { $0.id == currentID }) ?? topics.firstIndex(where: { $0.id == currentID })
        else {
            selectTopic(related.first?.id)
            return
        }

        let nextIndex = min(index + 1, related.count - 1)
        selectTopic(related[nextIndex].id)
    }
}
