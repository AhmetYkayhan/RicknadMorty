// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AppLogger",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "AppLogger", targets: ["AppLogger"])
    ],
    targets: [
        .target(name: "AppLogger", path: "Sources/AppLogger"),
        .testTarget(
            name: "AppLoggerTests",
            dependencies: ["AppLogger"],
            path: "Tests/AppLoggerTests"
        )
    ]
)
