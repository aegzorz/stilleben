// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Stilleben",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Stilleben",
            targets: ["Stilleben"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Stilleben",
            dependencies: []
        ),
        .testTarget(
            name: "StillebenTests",
            dependencies: [
                "Stilleben"
            ],
            exclude: [
                "Snapshots"
            ],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
