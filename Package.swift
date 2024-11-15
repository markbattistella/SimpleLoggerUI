// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SimpleLoggerUI",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .macCatalyst(.v16),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "SimpleLoggerUI",
            targets: ["SimpleLoggerUI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/markbattistella/SimpleLogger", from: "1.0.0")
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
