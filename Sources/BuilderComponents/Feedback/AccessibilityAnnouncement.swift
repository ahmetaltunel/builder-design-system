import AppKit
import SwiftUI

@MainActor
func postAccessibilityAnnouncement(_ message: String) {
    let userInfo: [NSAccessibility.NotificationUserInfoKey: Any] = [
        .announcement: message,
        .priority: NSAccessibilityPriorityLevel.medium.rawValue
    ]

    NSAccessibility.post(
        element: NSApp as Any,
        notification: .announcementRequested,
        userInfo: userInfo
    )
}

struct AccessibilityAnnouncementRegion: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.system(size: 1))
            .foregroundStyle(.clear)
            .frame(height: 1)
            .accessibilityLabel(message)
    }
}
