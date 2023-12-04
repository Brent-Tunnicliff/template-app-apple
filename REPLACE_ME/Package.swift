// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
// Copyright © 2023 Brent Tunnicliff <btunnicliff.dev@gmail.com>

import PackageDescription

let package = Package(
    name: "REPLACE_ME",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "REPLACE_ME",
            targets: ["REPLACE_ME"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Brent-Tunnicliff/swift-format-plugin", .upToNextMajor(from: "1.0.0")),
        .package(path: "../rename_template"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "REPLACE_ME",
            plugins: [
                .plugin(name: "lint", package: "swift-format-plugin"),
            ]
        ),
        .testTarget(
            name: "REPLACE_METests",
            dependencies: ["REPLACE_ME"],
            plugins: [
                .plugin(name: "lint", package: "swift-format-plugin"),
            ]
        ),
    ]
)
