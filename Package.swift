// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SimpleLoggerUI",
    platforms: [
        .iOS(.v17),
        .macCatalyst(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "SimpleLoggerUI", targets: ["SimpleLoggerUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/markbattistella/SimpleLogger", from: "25.12.0")
    ],
    targets: [
        .target(
            name: "SimpleLoggerUI",
            dependencies: ["SimpleLogger"],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        )
    ]
)
