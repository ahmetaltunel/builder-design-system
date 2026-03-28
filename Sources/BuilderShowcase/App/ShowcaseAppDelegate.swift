import AppKit

final class ShowcaseAppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        let app = NSApplication.shared
        app.setActivationPolicy(.regular)
        app.applicationIconImage = ShowcaseAppIcon.makeIcon()

        DispatchQueue.main.async {
            NSRunningApplication.current.activate(options: [.activateAllWindows])
            app.windows.first?.makeKeyAndOrderFront(nil)
        }
    }
}

enum ShowcaseAppIcon {
    static func makeIcon(size: CGFloat = 512) -> NSImage {
        let image = NSImage(size: NSSize(width: size, height: size))
        image.lockFocus()

        let bounds = NSRect(x: 0, y: 0, width: size, height: size)
        let background = NSBezierPath(roundedRect: bounds, xRadius: size * 0.22, yRadius: size * 0.22)
        NSColor(calibratedRed: 0.12, green: 0.13, blue: 0.15, alpha: 1).setFill()
        background.fill()

        let accent = NSColor(calibratedRed: 0.22, green: 0.61, blue: 1.0, alpha: 1)
        let symbolRect = NSRect(
            x: size * 0.20,
            y: size * 0.20,
            width: size * 0.60,
            height: size * 0.60
        )

        if let symbol = NSImage(
            systemSymbolName: "square.stack.3d.up.fill",
            accessibilityDescription: "Builder Showcase"
        )?.withSymbolConfiguration(.init(pointSize: size * 0.42, weight: .bold)) {
            let tinted = symbol.copy() as? NSImage ?? symbol
            tinted.lockFocus()
            accent.set()
            NSRect(origin: .zero, size: tinted.size).fill(using: .sourceAtop)
            tinted.unlockFocus()
            tinted.draw(in: symbolRect)
        }

        image.unlockFocus()
        return image
    }
}
