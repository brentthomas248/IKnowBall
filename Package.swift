// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "IKnowBall",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .executable(name: "IKnowBall", targets: ["IKnowBall"])
    ],
    targets: [
        .target(
            name: "IKnowBall",
            path: "Sources"
        )
    ]
)
