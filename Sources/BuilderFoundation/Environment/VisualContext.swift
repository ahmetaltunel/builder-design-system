import SwiftUI

public enum VisualContext: String, CaseIterable, Identifiable, Sendable {
    case shell
    case settings
    case editorComposer
    case dashboard
    case dataTable
    case onboarding
    case aiGeneratedOutput

    public var id: String { rawValue }
}
