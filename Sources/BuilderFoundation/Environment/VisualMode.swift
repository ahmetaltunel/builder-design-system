import SwiftUI

public enum VisualMode: String, CaseIterable, Identifiable, Sendable {
    case normal
    case selected
    case focused
    case disabled
    case readOnly
    case loading
    case error
    case success
    case warning
    case betaPreview

    public var id: String { rawValue }
}
