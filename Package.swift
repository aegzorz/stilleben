// swift-tools-version: 6.4

import PackageDescription

let package = Package(
  name: "Stilleben",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v26),
  ],
  products: [
    .library(
      name: "Stilleben",
      targets: ["Stilleben"],
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.5.0"),
  ],
  targets: [
    .target(
      name: "Stilleben",
      swiftSettings: [
        // Snapshots render UIKit views and windows, so the whole library runs on the main actor
        .defaultIsolation(MainActor.self),
        .treatAllWarnings(as: .error),
      ],
      linkerSettings: [
        // Stilleben reports failures through XCTest, so it must be linked with the test frameworks
        .linkedFramework("XCTest"),
      ],
    ),
    // Localized modules for the localization tests, set up like the feature modules of an app
    .target(
      name: "CatalogFixtures",
      path: "Tests/Fixtures/CatalogFixtures",
      resources: [
        .process("Localizable.xcstrings"),
      ],
    ),
    .target(
      name: "StringsFixtures",
      path: "Tests/Fixtures/StringsFixtures",
      resources: [
        .process("Resources"),
      ],
    ),
    .testTarget(
      name: "StillebenTests",
      dependencies: [
        "Stilleben",
        "CatalogFixtures",
        "StringsFixtures",
      ],
      exclude: [
        "Snapshots",
      ],
      resources: [
        .process("Resources"),
      ],
      swiftSettings: [
        .treatAllWarnings(as: .error),
      ],
    ),
  ],
  swiftLanguageModes: [.v6],
)
