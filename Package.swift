// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-loader",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Loader",
            targets: ["Loader"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-string.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-ownership.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-ascii.git",
            branch: "main"
        ),

    ],
    targets: [
        .target(
            name: "Loader",
            dependencies: [
                .product(name: "String", package: "swift-string"),
                .product(name: "Ownership", package: "swift-ownership"),
                .product(name: "ASCII", package: "swift-ascii"),

            ],
            path: "Sources/Loader"
        ),
        .testTarget(
            name: "Loader Tests",
            dependencies: [
                "Loader"
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
