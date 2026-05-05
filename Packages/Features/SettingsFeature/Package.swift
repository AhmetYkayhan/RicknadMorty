// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SettingsFeature",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "SettingsFeature", targets: ["SettingsFeature"])
    ],
    dependencies: [
        .package(path: "../../FeatureInterfaces/SettingsFeatureInterface"),
        .package(path: "../../Core/AppCore"),
        .package(path: "../../Core/AppLogger"),
        .package(path: "../../Core/AppNetwork"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../HomeFeature")
    ],
    targets: [
        .target(
            name: "SettingsFeature",
            dependencies: [
                "SettingsFeatureInterface",
                "AppCore",
                "AppLogger",
                "AppNetwork",
                "DesignSystem",
                "HomeFeature"
            ],
            path: "Sources/SettingsFeature"
        ),
        .testTarget(
            name: "SettingsFeatureTests",
            dependencies: [
                "SettingsFeature",
                "SettingsFeatureInterface",
                "AppCore",
                "HomeFeature"
            ],
            path: "Tests/SettingsFeatureTests"
        )
    ]
)
