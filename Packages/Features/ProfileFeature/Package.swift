// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ProfileFeature",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "ProfileFeature", targets: ["ProfileFeature"])
    ],
    dependencies: [
        .package(path: "../../FeatureInterfaces/ProfileFeatureInterface"),
        .package(path: "../../Core/AppCore"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../HomeFeature")
    ],
    targets: [
        .target(
            name: "ProfileFeature",
            dependencies: [
                "ProfileFeatureInterface",
                "AppCore",
                "DesignSystem",
                "HomeFeature"
            ],
            path: "Sources/ProfileFeature"
        ),
        .testTarget(
            name: "ProfileFeatureTests",
            dependencies: ["ProfileFeature"],
            path: "Tests/ProfileFeatureTests"
        )
    ]
)
