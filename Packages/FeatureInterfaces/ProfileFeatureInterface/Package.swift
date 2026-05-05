// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ProfileFeatureInterface",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "ProfileFeatureInterface", targets: ["ProfileFeatureInterface"])
    ],
    targets: [
        .target(
            name: "ProfileFeatureInterface",
            path: "Sources/ProfileFeatureInterface"
        ),
        .testTarget(
            name: "ProfileFeatureInterfaceTests",
            dependencies: ["ProfileFeatureInterface"],
            path: "Tests/ProfileFeatureInterfaceTests"
        )
    ]
)
