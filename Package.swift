// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NVAlert",
    products: [
        .library(
            name: "NVAlert",
            targets: ["NVAlert"]),
    ],
    targets: [
        .target(
            name: "NVAlert"),
        .testTarget(
            name: "NVAlertTests",
            dependencies: ["NVAlert"]),
    ]
)
