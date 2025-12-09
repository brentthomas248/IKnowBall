// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "IKnowBall",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "IKnowBallFeature", targets: ["IKnowBallFeature"])
    ],
    targets: [
        .target(
            name: "IKnowBallFeature",
            path: "Sources"
        )
    ]
)
