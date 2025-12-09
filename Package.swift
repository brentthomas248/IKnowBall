// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "IKnowBall",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .executable(name: "IKnowBall", targets: ["IKnowBall"])
    ],
    targets: [
        .executableTarget(
            name: "IKnowBall",
            path: "Sources"
        )
    ]
)
