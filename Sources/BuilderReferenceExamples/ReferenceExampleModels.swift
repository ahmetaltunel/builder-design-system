import SwiftUI
import BuilderDesignSystem

package struct ComponentPreviewOptions: Sendable {
    package let showDisabledState: Bool
    package let showLoadingState: Bool
    package let showReadOnlyState: Bool

    package init(
        showDisabledState: Bool = false,
        showLoadingState: Bool = false,
        showReadOnlyState: Bool = false
    ) {
        self.showDisabledState = showDisabledState
        self.showLoadingState = showLoadingState
        self.showReadOnlyState = showReadOnlyState
    }

    package static let live = ComponentPreviewOptions()
}

package enum ComponentExampleFamily: String, Sendable {
    case shell
    case toolbar
    case navigation
    case form
    case selection
    case feedback
    case overlay
    case content
    case data
    case ai
    case tutorial
    case utility
    case specialized
}

package enum PatternExampleFamily: String, Sendable {
    case actionFlow
    case announcement
    case unsavedChanges
    case dataVisualization
    case density
    case stateHandling
    case dragAndDrop
    case filtering
    case hero
    case support
    case loading
    case onboarding
    case navigation
    case dashboard
    case timeAndFeedback
}

package struct ComponentExampleID: RawRepresentable, Hashable, Sendable, ExpressibleByStringLiteral, CustomStringConvertible {
    package let rawValue: String

    package init(rawValue: String) {
        self.rawValue = rawValue
    }

    package init(stringLiteral value: StringLiteralType) {
        self.rawValue = value
    }

    package var description: String { rawValue }
}

package struct PatternExampleID: RawRepresentable, Hashable, Sendable, ExpressibleByStringLiteral, CustomStringConvertible {
    package let rawValue: String

    package init(rawValue: String) {
        self.rawValue = rawValue
    }

    package init(stringLiteral value: StringLiteralType) {
        self.rawValue = value
    }

    package var description: String { rawValue }
}

package struct ComponentReferenceExample {
    package let id: ComponentExampleID
    package let title: String
    package let summary: String
    package let supportedStates: [String]
    package let accessibilityNotes: [String]
    package let code: String
    package let makePreview: @MainActor (DesignSystemEnvironment, ComponentPreviewOptions) -> AnyView
}

package struct PatternReferenceExample {
    package let id: PatternExampleID
    package let title: String
    package let summary: String
    package let contentGuidance: [String]
    package let accessibilityNotes: [String]
    package let code: String
    package let makePreview: @MainActor (DesignSystemEnvironment) -> AnyView
}
