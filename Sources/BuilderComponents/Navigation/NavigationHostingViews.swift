import AppKit
import SwiftUI

@MainActor
final class NavigationHostingCellView: NSTableCellView {
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("NavigationHostingCellView")

    private var hostingView: NSHostingView<AnyView>?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setRootView(_ rootView: AnyView) {
        if let hostingView {
            hostingView.rootView = rootView
            return
        }

        let hostingView = NSHostingView(rootView: rootView)
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        hostingView.wantsLayer = true
        hostingView.layer?.backgroundColor = NSColor.clear.cgColor
        addSubview(hostingView)

        NSLayoutConstraint.activate([
            hostingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostingView.topAnchor.constraint(equalTo: topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        self.hostingView = hostingView
    }
}

@MainActor
final class NavigationRowView: NSTableRowView {
    override var isEmphasized: Bool {
        get { true }
        set { }
    }

    override func drawSelection(in dirtyRect: NSRect) {
    }

    override func drawBackground(in dirtyRect: NSRect) {
    }
}

@MainActor
final class NavigationTableView: NSTableView {
    var activationHandler: (() -> Void)?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        focusRingType = .none
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var acceptsFirstResponder: Bool {
        true
    }

    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 36, 76:
            activationHandler?()
        default:
            super.keyDown(with: event)
        }
    }
}

@MainActor
final class NavigationOutlineView: NSOutlineView {
    var activationHandler: (() -> Void)?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        focusRingType = .none
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var acceptsFirstResponder: Bool {
        true
    }

    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 36, 76:
            activationHandler?()
        default:
            super.keyDown(with: event)
        }
    }
}
