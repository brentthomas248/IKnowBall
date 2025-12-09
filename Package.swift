// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "IKnowBall",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "IKnowBall", targets: ["IKnowBall"])
    ],
    targets: [
        .target(
            name: "IKnowBall",
            path: "Sources",
            resources: [
                .process("Shared/DesignSystem/Tokens") // Example of processing resources if needed, but auto-discovery works too
            ]
        )
    ]
)
