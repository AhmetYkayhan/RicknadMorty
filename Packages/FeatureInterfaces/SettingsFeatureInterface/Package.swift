// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SettingsFeatureInterface",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "SettingsFeatureInterface", targets: ["SettingsFeatureInterface"])
    ],
    targets: [
        .target(
            name: "SettingsFeatureInterface",
            path: "Sources/SettingsFeatureInterface"
        ),
        .testTarget(
            name: "SettingsFeatureInterfaceTests",
            dependencies: ["SettingsFeatureInterface"],
            path: "Tests/SettingsFeatureInterfaceTests"
        )
    ]
)
