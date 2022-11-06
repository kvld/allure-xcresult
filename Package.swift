// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "allure-xcresult",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "AllureXCResultLib", targets: ["AllureXCResultLib"])
    ],
    dependencies: [
        .package(url: "https://github.com/kvld/XCResultKit.git", .revisionItem("97d1d4b")),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.2"),
    ],
    targets: [
        .target(
            name: "AllureXCResultLib",
            dependencies: [
                .product(name: "XCResultKit", package: "XCResultKit")
            ]
        ),
        .executableTarget(
            name: "AllureXCResult",
            dependencies: [
                "AllureXCResultLib",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        )
    ]
)
