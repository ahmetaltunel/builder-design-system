import Foundation
import BuilderReferenceExamples

package enum CatalogContent {}

package enum FoundationTopic: String, CaseIterable, Identifiable {
    case visualFoundation = "Visual foundation"
    case colors = "Colors"
    case contentDensity = "Content density"
    case dataVisualizationColors = "Data visualization colors"
    case designTokens = "Design tokens"
    case iconography = "Iconography"
    case layout = "Layout"
    case materials = "Materials"
    case motion = "Motion"
    case spacing = "Spacing"
    case theming = "Theming"
    case typography = "Typography"
    case visualContext = "Visual context"
    case visualModes = "Visual modes"
    case visualStyle = "Visual style"

    package var id: String { rawValue }
}

package enum ComponentCategory: String, CaseIterable, Identifiable {
    case shellNavigation = "Shell & Navigation"
    case inputSelection = "Input & Selection"
    case feedbackOverlay = "Feedback & Overlay"
    case collectionContent = "Collection & Content"
    case specialized = "Specialized Flows"

    package var id: String { rawValue }
}

package enum PatternCategory: String, CaseIterable, Identifiable {
    case general = "General"
    case messaging = "Messaging"
    case data = "Data & Density"
    case workflow = "Workflow"
    case navigation = "Navigation & Support"

    package var id: String { rawValue }
}

package struct UsageGuideline: Identifiable {
    package let title: String
    package let body: String

    package var id: String { title }
}

package struct AccessibilityAcceptance {
    package let semantics: Bool
    package let keyboard: Bool
    package let contrast: Bool
    package let motion: Bool
    package let messaging: Bool

    package init(
        semantics: Bool,
        keyboard: Bool,
        contrast: Bool,
        motion: Bool,
        messaging: Bool
    ) {
        self.semantics = semantics
        self.keyboard = keyboard
        self.contrast = contrast
        self.motion = motion
        self.messaging = messaging
    }

    package var isComplete: Bool {
        semantics && keyboard && contrast && motion && messaging
    }
}

package struct StructuredContentGuidance {
    package let actionLabels: [String]
    package let helperText: [String]
    package let validationCopy: [String]
    package let errorCopy: [String]
    package let confirmations: [String]
    package let destructiveActions: [String]
    package let emptyStates: [String]
    package let announcements: [String]
    package let localization: [String]
    package let terminology: [String]
    package let aiGeneratedContent: [String]

    package init(
        actionLabels: [String],
        helperText: [String],
        validationCopy: [String],
        errorCopy: [String],
        confirmations: [String],
        destructiveActions: [String],
        emptyStates: [String],
        announcements: [String],
        localization: [String],
        terminology: [String],
        aiGeneratedContent: [String]
    ) {
        self.actionLabels = actionLabels
        self.helperText = helperText
        self.validationCopy = validationCopy
        self.errorCopy = errorCopy
        self.confirmations = confirmations
        self.destructiveActions = destructiveActions
        self.emptyStates = emptyStates
        self.announcements = announcements
        self.localization = localization
        self.terminology = terminology
        self.aiGeneratedContent = aiGeneratedContent
    }
}

package enum ComponentPreviewGroup {
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

package enum PatternPreviewGroup {
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

package struct FoundationDetail {
    package let topic: FoundationTopic
    package let summary: String
    package let calibrationNotes: [String]
    package let implementationGuidelines: [String]
    package let tokenReferences: [String]
}

package struct ComponentCatalogEntry: Identifiable {
    package let id: String
    package let name: String
    package let category: ComponentCategory
    package let swiftUIType: String
    package let summary: String
    package let anatomy: [String]
    package let variants: [String]
    package let states: [String]
    package let densityBehavior: String
    package let accessibility: [String]
    package let themingHooks: [String]
    package let designTokens: [String]
    package let dos: [String]
    package let donts: [String]
    package let relatedPatterns: [String]
    package let writingGuidelines: [String]
    package let structuredContent: StructuredContentGuidance
    package let engineeringNotes: [String]
    package let usage: [UsageGuideline]
    package let antiPatterns: [String]
    package let macOSNotes: [String]
    package let previewGroup: ComponentPreviewGroup
    package let canonicalExampleID: ComponentExampleID
    package let accessibilityAcceptance: AccessibilityAcceptance
}

package struct PatternCatalogEntry: Identifiable {
    package let id: String
    package let name: String
    package let category: PatternCategory
    package let whenToUse: String
    package let requiredComponents: [String]
    package let layoutRecipe: [String]
    package let copyTone: String
    package let criteria: [String]
    package let configurations: [String]
    package let generalGuidelines: [String]
    package let accessibilityAndMotion: [String]
    package let darkLightConsiderations: [String]
    package let relatedPatterns: [String]
    package let screenshotLanguage: [String]
    package let previewGroup: PatternPreviewGroup
    package let contentGuidance: [String]
    package let structuredContent: StructuredContentGuidance
    package let canonicalExampleID: PatternExampleID
    package let accessibilityAcceptance: AccessibilityAcceptance
}
