// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "BuilderDesignSystem",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "BuilderDesignSystem",
            targets: ["BuilderDesignSystem"]
        ),
        .executable(
            name: "BuilderShowcase",
            targets: ["BuilderShowcase"]
        )
    ],
    targets: [
        .target(
            name: "BuilderFoundation",
            path: "Sources/BuilderFoundation"
        ),
        .target(
            name: "BuilderComponents",
            dependencies: ["BuilderFoundation"],
            path: "Sources/BuilderComponents"
        ),
        .target(
            name: "BuilderDesignSystem",
            dependencies: ["BuilderFoundation", "BuilderComponents"],
            path: "Sources/BuilderDesignSystem"
        ),
        .target(
            name: "BuilderReferenceExamples",
            dependencies: ["BuilderDesignSystem"],
            path: "Sources/BuilderReferenceExamples"
        ),
        .target(
            name: "BuilderCatalog",
            dependencies: ["BuilderFoundation", "BuilderDesignSystem", "BuilderReferenceExamples"],
            path: "Sources/BuilderCatalog"
        ),
        .executableTarget(
            name: "BuilderShowcase",
            dependencies: ["BuilderDesignSystem", "BuilderCatalog", "BuilderReferenceExamples"],
            path: "Sources/BuilderShowcase"
        ),
        .executableTarget(
            name: "BuilderArtifactGenerator",
            dependencies: ["BuilderCatalog"],
            path: "Sources/BuilderArtifactGenerator"
        ),
        .testTarget(
            name: "BuilderFoundationTests",
            dependencies: ["BuilderFoundation"],
            path: "Tests/BuilderFoundationTests"
        ),
        .testTarget(
            name: "BuilderComponentsTests",
            dependencies: ["BuilderFoundation", "BuilderComponents"],
            path: "Tests/BuilderComponentsTests"
        ),
        .testTarget(
            name: "BuilderCatalogTests",
            dependencies: ["BuilderFoundation", "BuilderCatalog"],
            path: "Tests/BuilderCatalogTests"
        ),
        .testTarget(
            name: "BuilderIntegrationTests",
            dependencies: ["BuilderFoundation", "BuilderComponents", "BuilderDesignSystem", "BuilderCatalog", "BuilderShowcase"],
            path: "Tests/BuilderIntegrationTests",
            resources: [
                .process("__Snapshots__")
            ]
        )
    ]
)
