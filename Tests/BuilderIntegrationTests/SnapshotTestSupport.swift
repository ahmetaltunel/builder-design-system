import AppKit
import SwiftUI
import XCTest

@MainActor
enum SnapshotTestSupport {
    static var isRecording: Bool {
        ProcessInfo.processInfo.environment["UPDATE_SNAPSHOTS"] == "1"
    }

    static func assertSnapshot<V: View>(
        matching view: V,
        named name: String,
        size: CGSize,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let renderer = ImageRenderer(content: view.frame(width: size.width, height: size.height))
        renderer.scale = 1
        renderer.proposedSize = .init(size)

        guard let image = renderer.nsImage,
              let data = pngData(for: image) else {
            XCTFail("Unable to render snapshot for \(name)", file: file, line: line)
            return
        }

        let baselineURL = snapshotsDirectory().appendingPathComponent("\(name).png")
        let failureURL = snapshotsDirectory().appendingPathComponent("\(name).failure.png")

        if isRecording {
            try? FileManager.default.createDirectory(at: snapshotsDirectory(), withIntermediateDirectories: true)
            do {
                try data.write(to: baselineURL)
            } catch {
                XCTFail("Failed to record snapshot \(name): \(error)", file: file, line: line)
            }
            return
        }

        guard FileManager.default.fileExists(atPath: baselineURL.path) else {
            XCTFail("Missing baseline snapshot: \(baselineURL.path). Run with UPDATE_SNAPSHOTS=1 to record it.", file: file, line: line)
            return
        }

        do {
            let expected = try Data(contentsOf: baselineURL)
            if expected != data {
                try? data.write(to: failureURL)
                XCTFail("Snapshot mismatch for \(name). Failure image written to \(failureURL.path)", file: file, line: line)
            } else if FileManager.default.fileExists(atPath: failureURL.path) {
                try? FileManager.default.removeItem(at: failureURL)
            }
        } catch {
            XCTFail("Failed to compare snapshot \(name): \(error)", file: file, line: line)
        }
    }

    static func snapshotsDirectory() -> URL {
        repositoryRoot().appendingPathComponent("Tests/BuilderIntegrationTests/__Snapshots__", isDirectory: true)
    }

    static func repositoryRoot() -> URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }

    private static func pngData(for image: NSImage) -> Data? {
        guard let tiff = image.tiffRepresentation,
              let rep = NSBitmapImageRep(data: tiff) else {
            return nil
        }
        return rep.representation(using: .png, properties: [:])
    }
}
