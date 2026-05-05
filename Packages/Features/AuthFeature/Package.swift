// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AuthFeature",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "AuthFeature", targets: ["AuthFeature"])
    ],
    dependencies: [
        .package(path: "../../Core/AppCore"),
        .package(path: "../../Core/AppLogger"),
        .package(path: "../../Core/AppStorage"),
        .package(path: "../../Core/AppNetwork"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../FeatureInterfaces/AuthFeatureInterface"),
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "12.0.0"
        )
    ],
    targets: [
        .target(
            name: "AuthFeature",
            dependencies: [
                "AppCore",
                "AppLogger",
                "AppStorage",
                "AppNetwork",
                "DesignSystem",
                "AuthFeatureInterface",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
            ],
            path: "Sources/AuthFeature"
        ),
        .testTarget(
            name: "AuthFeatureTests",
            dependencies: [
                "AuthFeature",
                "AuthFeatureInterface",
                "AppCore"
            ],
            path: "Tests/AuthFeatureTests"
        )
    ]
)
