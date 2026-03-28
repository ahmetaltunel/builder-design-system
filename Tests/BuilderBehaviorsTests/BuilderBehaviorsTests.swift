import UniformTypeIdentifiers
import XCTest
@testable import BuilderBehaviors

@MainActor
final class BuilderBehaviorsTests: XCTestCase {
    private struct DemoItem: Identifiable, Hashable {
        let id: String
        let title: String
        let tags: [String]
    }

    private struct StubFileUploadDriver: FileUploadDriver {
        func upload(request: FileUploadRequest) -> AsyncThrowingStream<FileUploadEvent, Error> {
            AsyncThrowingStream { continuation in
                continuation.yield(
                    .init(
                        requestID: request.id,
                        status: .uploading,
                        progress: 0.5,
                        message: "Uploading"
                    )
                )
                continuation.yield(
                    .init(
                        requestID: request.id,
                        status: .success,
                        progress: 1,
                        message: "Uploaded"
                    )
                )
                continuation.finish()
            }
        }
    }

    private struct StubConversationDriver: ConversationDriver {
        func streamReply(
            prompt: String,
            history: [ConversationMessage]
        ) -> AsyncThrowingStream<ConversationStreamEvent, Error> {
            AsyncThrowingStream { continuation in
                continuation.yield(.appendText("Drafting "))
                continuation.yield(.appendText(prompt))
                continuation.yield(.complete)
                continuation.finish()
            }
        }
    }

    func testCollectionControllerFiltersSortsAndPages() {
        let controller = CollectionController<DemoItem>(
            items: [
                DemoItem(id: "a", title: "Alert", tags: ["feedback"]),
                DemoItem(id: "b", title: "Board", tags: ["content"]),
                DemoItem(id: "c", title: "Button", tags: ["selection"])
            ],
            pageSize: 1,
            sortOptions: [
                CollectionController<DemoItem>.SortOption(id: "title-desc", title: "Title descending") { lhs, rhs in
                    lhs.title > rhs.title
                }
            ],
            searchableText: { "\($0.title) \($0.tags.joined(separator: " "))" },
            filterMatcher: { item, tokens in
                tokens.allSatisfy { item.tags.contains($0) }
            }
        )

        controller.setSort(id: "title-desc")
        controller.updateQuery("b")
        controller.setFilterTokens(["selection"])

        XCTAssertEqual(controller.filteredItems.map(\.title), ["Button"])
        XCTAssertEqual(controller.visibleItems.map(\.title), ["Button"])
        XCTAssertEqual(controller.pageCount, 1)
    }

    func testMetricChartControllerTracksSelectionAndVisibility() {
        let controller = MetricChartController()
        controller.configure(
            availableSelections: [
                .init(kind: .point, seriesID: "coverage", seriesTitle: "Coverage", datumID: "tokens", label: "Tokens", value: 82, formattedValue: "82"),
                .init(kind: .point, seriesID: "coverage", seriesTitle: "Coverage", datumID: "components", label: "Components", value: 80, formattedValue: "80")
            ],
            defaultVisibleSeriesIDs: ["coverage"]
        )

        controller.moveSelectionForward()
        XCTAssertEqual(controller.pinnedSelection?.datumID, "tokens")

        controller.moveSelectionForward()
        XCTAssertEqual(controller.pinnedSelection?.datumID, "components")

        controller.toggleSeries(id: "coverage", label: "Coverage")
        XCTAssertTrue(controller.visibleSeriesIDs.isEmpty)
    }

    func testFileImportControllerFiltersAcceptedTypes() {
        let controller = FileImportController(acceptedContentTypes: [.plainText])
        let acceptedURL = URL(fileURLWithPath: "/tmp/release-notes.txt")
        let rejectedURL = URL(fileURLWithPath: "/tmp/archive.zip")

        let accepted = controller.handleDroppedURLs([acceptedURL, rejectedURL])

        XCTAssertEqual(accepted, [acceptedURL])
        XCTAssertEqual(controller.rejectedURLs, [rejectedURL])
        XCTAssertNotNil(controller.validationSummary)
    }

    func testFileUploadSessionControllerTransitionsUploads() async {
        let controller = FileUploadSessionController()
        let request = FileUploadRequest(url: URL(fileURLWithPath: "/tmp/release-notes.md"))
        controller.enqueue(requests: [request])
        controller.startUploads(using: StubFileUploadDriver())

        try? await Task.sleep(for: .milliseconds(50))

        XCTAssertEqual(controller.items.first?.status, .success)
        XCTAssertEqual(controller.items.first?.progress, 1)
    }

    func testConversationControllerStreamsAssistantMessage() async {
        let controller = ConversationController(driver: StubConversationDriver())
        controller.send(prompt: "Summarize the rollout")

        try? await Task.sleep(for: .milliseconds(50))

        XCTAssertEqual(controller.messages.count, 2)
        XCTAssertEqual(controller.messages.last?.state, .complete)
        XCTAssertEqual(controller.messages.last?.message, "Drafting Summarize the rollout")
    }

    func testTutorialAndHelpControllersAdvanceAndSync() {
        let tutorial = TutorialFlowController(
            steps: [
                .init(id: "audit", title: "Audit"),
                .init(id: "build", title: "Build"),
                .init(id: "verify", title: "Verify")
            ]
        )
        tutorial.advance()

        let help = HelpNavigator(
            topics: [
                .init(id: "context", title: "Context"),
                .init(id: "verify", title: "Verify help")
            ],
            tutorialTopicMap: ["build": "verify"]
        )
        help.sync(withTutorialStepID: tutorial.currentStepID)

        XCTAssertEqual(tutorial.currentStepID, "build")
        XCTAssertTrue(tutorial.completedStepIDs.contains("audit"))
        XCTAssertEqual(help.selectedTopicID, "verify")
    }

    func testCommandRegistryPerformsRegisteredCommand() {
        let registry = CommandRegistry()
        var didRun = false

        registry.register(.init(id: CommandRegistry.CommandID.submitPrompt, title: "Submit prompt")) {
            didRun = true
        }

        XCTAssertTrue(registry.perform(CommandRegistry.CommandID.submitPrompt))
        XCTAssertTrue(didRun)
    }
}
