// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HomeFeatureInterface",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "HomeFeatureInterface", targets: ["HomeFeatureInterface"])
    ],
    targets: [
        .target(
            name: "HomeFeatureInterface",
            path: "Sources/HomeFeatureInterface"
        ),
        .testTarget(
            name: "HomeFeatureInterfaceTests",
            dependencies: ["HomeFeatureInterface"],
            path: "Tests/HomeFeatureInterfaceTests"
        )
    ]
)
