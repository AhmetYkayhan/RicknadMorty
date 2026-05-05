// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AuthFeatureInterface",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "AuthFeatureInterface", targets: ["AuthFeatureInterface"])
    ],
    targets: [
        .target(
            name: "AuthFeatureInterface",
            path: "Sources/AuthFeatureInterface"
        ),
        .testTarget(
            name: "AuthFeatureInterfaceTests",
            dependencies: ["AuthFeatureInterface"],
            path: "Tests/AuthFeatureInterfaceTests"
        )
    ]
)
