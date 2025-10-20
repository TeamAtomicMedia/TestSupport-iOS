// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

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
        .package(url: "https://github.com/TeamAtomicMedia/NetMock-iOS.git", from: "3.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TestSupport",
            dependencies: [.product(name: "NetMock", package: "netmock-ios")]
        ),
        .target(
            name: "XCTestSupport",
            dependencies: [.product(name: "NetMock", package: "netmock-ios"), "TestSupport"]
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
