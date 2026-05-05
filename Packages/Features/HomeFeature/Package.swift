// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HomeFeature",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "HomeFeature", targets: ["HomeFeature"])
    ],
    dependencies: [
        .package(path: "../../FeatureInterfaces/HomeFeatureInterface"),
        .package(path: "../../Core/AppCore"),
        .package(path: "../../Core/AppLogger"),
        .package(path: "../../Core/AppNetwork"),
        .package(path: "../../Core/DesignSystem")
    ],
    targets: [
        .target(
            name: "HomeFeature",
            dependencies: [
                "HomeFeatureInterface",
                "AppCore",
                "AppLogger",
                "AppNetwork",
                "DesignSystem"
            ],
            path: "Sources/HomeFeature"
        ),
        .testTarget(
            name: "HomeFeatureTests",
            dependencies: ["HomeFeature"],
            path: "Tests/HomeFeatureTests"
        )
    ]
)
