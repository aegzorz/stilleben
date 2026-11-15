import ProjectDescription

// Stilleben renders snapshots in a window, which needs a window scene, so its tests run hosted in this app.

let swiftSettings: SettingsDictionary = [
  "SWIFT_VERSION": "6",
  "SWIFT_STRICT_CONCURRENCY": "complete",
  "SWIFT_TREAT_WARNINGS_AS_ERRORS": "YES",
  "GCC_TREAT_WARNINGS_AS_ERRORS": "YES",
]

let project = Project(
  name: "StillebenTestHost",
  options: .options(automaticSchemesOptions: .disabled),
  packages: [
    .local(path: ".."),
  ],
  settings: .settings(base: swiftSettings),
  targets: [
    .target(
      name: "StillebenTestHost",
      destinations: .iOS,
      product: .app,
      bundleId: "dev.aegzorz.StillebenTestHost",
      deploymentTargets: .iOS("26.0"),
      infoPlist: .extendingDefault(with: ["UILaunchScreen": [:]]),
      sources: ["Sources/**"],
    ),
    .target(
      name: "StillebenTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: "dev.aegzorz.StillebenTests",
      deploymentTargets: .iOS("26.0"),
      sources: ["../Tests/StillebenTests/**/*.swift"],
      resources: ["../Tests/StillebenTests/Resources/**"],
      dependencies: [
        .target(name: "StillebenTestHost"),
        .package(product: "Stilleben"),
      ],
    ),
  ],
  schemes: [
    .scheme(
      name: "StillebenTests",
      buildAction: .buildAction(targets: ["StillebenTestHost", "StillebenTests"]),
      testAction: .targets(["StillebenTests"]),
    ),
  ],
)
