import Combine
import Foundation

public enum PromptSubmitShortcutBehavior: Hashable, Sendable {
    case none
    case returnKey
    case commandReturn
}

@MainActor
public final class PromptComposerController: ObservableObject {
    @Published public private(set) var draft: String
    @Published public private(set) var isSubmitting: Bool
    @Published public private(set) var isEnabled: Bool
    @Published public private(set) var supportingText: String?

    public let submitShortcutBehavior: PromptSubmitShortcutBehavior

    private let draftStore: UserDefaultsValueStore<String>?

    public init(
        draft: String = "",
        isSubmitting: Bool = false,
        isEnabled: Bool = true,
        supportingText: String? = nil,
        submitShortcutBehavior: PromptSubmitShortcutBehavior = .commandReturn,
        draftStore: UserDefaultsValueStore<String>? = nil
    ) {
        self.draft = draftStore?.load() ?? draft
        self.isSubmitting = isSubmitting
        self.isEnabled = isEnabled
        self.supportingText = supportingText
        self.submitShortcutBehavior = submitShortcutBehavior
        self.draftStore = draftStore
    }

    public var canSubmit: Bool {
        isEnabled && !isSubmitting && !draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    public func updateDraft(_ draft: String) {
        self.draft = draft
        draftStore?.save(draft)
    }

    public func acceptSuggestion(_ suggestion: String) {
        updateDraft(suggestion)
    }

    public func clear() {
        updateDraft("")
    }

    public func setEnabled(_ value: Bool) {
        isEnabled = value
    }

    public func setSupportingText(_ text: String?) {
        supportingText = text
    }

    public func beginSubmitting() {
        isSubmitting = true
    }

    public func finishSubmitting(clearDraft: Bool = false) {
        isSubmitting = false
        if clearDraft {
            clear()
        }
    }

    public func submit(_ action: @escaping @MainActor (String) async -> Void) {
        guard canSubmit else { return }
        let currentDraft = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        beginSubmitting()

        Task { @MainActor in
            await action(currentDraft)
            finishSubmitting()
        }
    }
}

public struct ConversationMessage: Identifiable, Hashable, Sendable {
    public enum Role: Hashable, Sendable {
        case assistant
        case user
        case system
    }

    public enum State: Hashable, Sendable {
        case streaming
        case complete
        case error
    }

    public struct FooterMetadata: Identifiable, Hashable, Sendable {
        public let id: String
        public let label: String
        public let value: String

        public init(id: String? = nil, label: String, value: String) {
            self.id = id ?? label
            self.label = label
            self.value = value
        }
    }

    public let id: String
    public let role: Role
    public let author: String
    public let message: String
    public let detail: String?
    public let state: State
    public let footerMetadata: [FooterMetadata]

    public init(
        id: String? = nil,
        role: Role,
        author: String,
        message: String,
        detail: String? = nil,
        state: State = .complete,
        footerMetadata: [FooterMetadata] = []
    ) {
        self.id = id ?? UUID().uuidString
        self.role = role
        self.author = author
        self.message = message
        self.detail = detail
        self.state = state
        self.footerMetadata = footerMetadata
    }
}

public enum ConversationStreamEvent: Hashable, Sendable {
    case replaceMessage(String)
    case appendText(String)
    case setDetail(String?)
    case setFooterMetadata([ConversationMessage.FooterMetadata])
    case complete
}

public protocol ConversationDriver: Sendable {
    func streamReply(
        prompt: String,
        history: [ConversationMessage]
    ) -> AsyncThrowingStream<ConversationStreamEvent, Error>
}

@MainActor
public final class ConversationController: ObservableObject {
    @Published public private(set) var messages: [ConversationMessage]
    @Published public private(set) var isStreaming: Bool

    public let announcementCenter: AnnouncementCenter?

    private let driver: ConversationDriver
    private var currentTask: Task<Void, Never>?
    private var retryPromptsByMessageID: [String: String]

    public init(
        messages: [ConversationMessage] = [],
        driver: ConversationDriver,
        announcementCenter: AnnouncementCenter? = nil
    ) {
        self.messages = messages
        self.driver = driver
        self.announcementCenter = announcementCenter
        self.isStreaming = false
        self.retryPromptsByMessageID = [:]
    }

    public func send(prompt: String, author: String = "Builder") {
        let trimmedPrompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedPrompt.isEmpty else { return }

        currentTask?.cancel()

        let userMessage = ConversationMessage(role: .user, author: author, message: trimmedPrompt)
        var assistantMessage = ConversationMessage(
            role: .assistant,
            author: "Builder assistant",
            message: "",
            detail: "Streaming response.",
            state: .streaming
        )

        retryPromptsByMessageID[assistantMessage.id] = trimmedPrompt
        messages.append(userMessage)
        messages.append(assistantMessage)
        isStreaming = true
        announcementCenter?.announce("Response started.")

        currentTask = Task {
            do {
                for try await event in driver.streamReply(prompt: trimmedPrompt, history: messages) {
                    await MainActor.run {
                        guard let index = self.messages.firstIndex(where: { $0.id == assistantMessage.id }) else { return }
                        assistantMessage = self.updatedMessage(self.messages[index], with: event)
                        self.messages[index] = assistantMessage
                    }
                }

                await MainActor.run {
                    self.isStreaming = false
                    self.announcementCenter?.announce("Response complete.")
                }
            } catch {
                await MainActor.run {
                    guard let index = self.messages.firstIndex(where: { $0.id == assistantMessage.id }) else { return }
                    self.messages[index] = ConversationMessage(
                        id: assistantMessage.id,
                        role: assistantMessage.role,
                        author: assistantMessage.author,
                        message: assistantMessage.message,
                        detail: "Response failed. Retry the message.",
                        state: .error,
                        footerMetadata: assistantMessage.footerMetadata
                    )
                    self.isStreaming = false
                    self.announcementCenter?.announce("Response failed.")
                }
            }
        }
    }

    public func retry(messageID: String) {
        guard let prompt = retryPromptsByMessageID[messageID] else { return }
        send(prompt: prompt)
    }

    public func cancelStreaming() {
        currentTask?.cancel()
        currentTask = nil
        isStreaming = false
    }

    public func clear() {
        cancelStreaming()
        messages = []
        retryPromptsByMessageID = [:]
    }

    private func updatedMessage(
        _ message: ConversationMessage,
        with event: ConversationStreamEvent
    ) -> ConversationMessage {
        switch event {
        case .replaceMessage(let updatedMessage):
            return ConversationMessage(
                id: message.id,
                role: message.role,
                author: message.author,
                message: updatedMessage,
                detail: message.detail,
                state: .streaming,
                footerMetadata: message.footerMetadata
            )
        case .appendText(let suffix):
            return ConversationMessage(
                id: message.id,
                role: message.role,
                author: message.author,
                message: message.message + suffix,
                detail: message.detail,
                state: .streaming,
                footerMetadata: message.footerMetadata
            )
        case .setDetail(let detail):
            return ConversationMessage(
                id: message.id,
                role: message.role,
                author: message.author,
                message: message.message,
                detail: detail,
                state: message.state,
                footerMetadata: message.footerMetadata
            )
        case .setFooterMetadata(let metadata):
            return ConversationMessage(
                id: message.id,
                role: message.role,
                author: message.author,
                message: message.message,
                detail: message.detail,
                state: message.state,
                footerMetadata: metadata
            )
        case .complete:
            return ConversationMessage(
                id: message.id,
                role: message.role,
                author: message.author,
                message: message.message,
                detail: message.detail,
                state: .complete,
                footerMetadata: message.footerMetadata
            )
        }
    }
}

