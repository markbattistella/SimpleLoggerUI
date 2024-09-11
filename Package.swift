// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SimpleLoggerUI",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .macCatalyst(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SimpleLoggerUI",
            targets: ["SimpleLoggerUI"]
        )
    ],
    dependencies: [
        .package(path: "../SimpleLogger")
    ],
    targets: [
        .target(
            name: "SimpleLoggerUI",
            dependencies: ["SimpleLogger"],
            exclude: [],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        )
    ]
)
