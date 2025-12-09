// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "IKnowBall",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "IKnowBallApp", targets: ["IKnowBallApp"]),
        .library(name: "IKnowBallFeature", targets: ["IKnowBallFeature"]), // Main Feature Module
    ],
    targets: [
        // MARK: - Core & Design
        .target(
            name: "IKnowBallCore",
            dependencies: []
        ),
        .target(
            name: "IKnowBallDesignSystem",
            dependencies: ["IKnowBallCore"]
        ),
        
        // MARK: - Shared Feature Code
        .target(
            name: "FeatureGamesShared",
            dependencies: ["IKnowBallDesignSystem"],
            resources: [.process("Resources")]
        ),
        
        // MARK: - Features
        .target(
            name: "FeatureBallKnowledge",
            dependencies: ["FeatureGamesShared", "IKnowBallDesignSystem", "FeatureScoreSummary", "IKnowBallCore"]
        ),
        .target(
            name: "FeatureConnections",
            dependencies: ["FeatureGamesShared", "IKnowBallDesignSystem", "FeatureScoreSummary", "IKnowBallCore"]
        ),
        .target(
            name: "FeatureOverUnder",
            dependencies: ["FeatureGamesShared", "IKnowBallDesignSystem", "FeatureScoreSummary", "IKnowBallCore"]

        ),
        .target(
            name: "FeatureScoreSummary",
            dependencies: ["FeatureGamesShared", "IKnowBallDesignSystem", "FeatureSettings"]

        ),
        .target(
            name: "FeatureSettings",
            dependencies: ["IKnowBallDesignSystem"]
        ),
        
        // MARK: - Main Feature (Composition)
        // MARK: - Main Feature (Composition)
        .target(
            name: "IKnowBallFeature",
            dependencies: [
                "FeatureBallKnowledge",
                "FeatureConnections",
                "FeatureOverUnder",
                "FeatureScoreSummary",
                "FeatureSettings",
                "IKnowBallDesignSystem"
            ],
            path: "Sources/FeatureHome"
        ),
        
        // MARK: - App Entry
        .target(
            name: "IKnowBallApp",
            dependencies: ["IKnowBallFeature"]
        ),
        
        // MARK: - Tests
        .testTarget(
            name: "FeatureBallKnowledgeTests",
            dependencies: ["FeatureBallKnowledge"]
        ),
        .testTarget(
            name: "FeatureConnectionsTests",
            dependencies: ["FeatureConnections"]
        ),
        .testTarget(
            name: "FeatureOverUnderTests",
            dependencies: ["FeatureOverUnder"]
        )
    ]
)
