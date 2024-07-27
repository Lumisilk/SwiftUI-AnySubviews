// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AnySubviews",
    platforms: [.iOS(.v13), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v6), .visionOS(.v1)],
    products: [
        .library(
            name: "AnySubviews",
            targets: ["AnySubviews"]
        ),
    ],
    targets: [
        .target(
            name: "AnySubviews",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .executableTarget(
            name: "Example",
            dependencies: ["AnySubviews"],
            path: "Example"
        )
    ]
)
