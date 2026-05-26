// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "SimpleLoggerUI",
  platforms: [
    .iOS(.v17),
    .macCatalyst(.v17),
    .macOS(.v14),
    .tvOS(.v17),
    .watchOS(.v10),
    .visionOS(.v1),
  ],
  products: [
    .library(name: "SimpleLoggerUI", targets: ["SimpleLoggerUI"])
  ],
  dependencies: [
    .package(url: "https://github.com/markbattistella/SimpleLogger", from: "26.0.0")
  ],
  targets: [
    .target(
      name: "SimpleLoggerUI",
      dependencies: ["SimpleLogger"],
      swiftSettings: [
        .swiftLanguageMode(.v6)
      ]
    ),
    .testTarget(
      name: "SimpleLoggerUITests",
      dependencies: ["SimpleLoggerUI"],
      swiftSettings: [
        .swiftLanguageMode(.v6)
      ]
    ),
  ],
  swiftLanguageModes: [.v6]
)
