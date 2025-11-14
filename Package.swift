// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "TestSupport",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v15),
        .visionOS(.v1)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TestSupport",
            targets: ["TestSupport"]),
        .library(
            name: "XCTestSupport",
            targets: ["XCTestSupport"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "602.0.0-latest"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TestSupport",
            dependencies: []
        ),
        .target(
            name: "XCTestSupport",
            dependencies: ["TestSupport"]
        ),
        .testTarget(
            name: "TestSupportTests",
            dependencies: ["TestSupport"]
        ),
        .testTarget(
            name: "XCTestSupportTests",
            dependencies: ["XCTestSupport"]
        ),
    ]
)
