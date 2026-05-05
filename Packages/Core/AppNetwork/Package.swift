// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AppNetwork",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "AppNetwork", targets: ["AppNetwork"])
    ],
    dependencies: [
        .package(path: "../AppCore"),
        .package(path: "../AppLogger")
    ],
    targets: [
        .target(
            name: "AppNetwork",
            dependencies: ["AppCore", "AppLogger"],
            path: "Sources/AppNetwork"
        ),
        .testTarget(
            name: "AppNetworkTests",
            dependencies: ["AppNetwork"],
            path: "Tests/AppNetworkTests"
        )
    ]
)
