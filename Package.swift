// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Nodes",
    products: [
        .library(
            name: "NodesTemplates",
            targets: ["NodesTemplates"]),
        .library(
            name: "Nodes",
            targets: ["Nodes"]),
    ],
    targets: [
        .target(
            name: "NodesTemplates",
            dependencies: [],
            resources: [
                .copy("Resources/Icons"),
                .copy("Resources/Templates"),
            ]),
        .target(
            name: "Nodes",
            dependencies: []),
        .testTarget(
            name: "NodesTests",
            dependencies: ["Nodes"]),
    ]
)
