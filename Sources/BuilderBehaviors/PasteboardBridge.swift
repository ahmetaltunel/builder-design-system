import AppKit
import Foundation

public enum PasteboardBridge {
    public static func copy(_ string: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(string, forType: .string)
    }

    public static func fileURLs() -> [URL] {
        let pasteboard = NSPasteboard.general
        return pasteboard.readObjects(forClasses: [NSURL.self])?.compactMap { $0 as? URL } ?? []
    }
}

