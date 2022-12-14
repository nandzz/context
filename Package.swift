// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Context",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Context",
            targets: ["Context"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Context",
            dependencies: []),
        .target(
            name: "Mocks",
            dependencies: [ "Context"],
            path: "./Tests/Mocks"
        ),
        .testTarget(
            name: "ContextTests",
            dependencies: ["Context", "Mocks"]),
    ]
)
