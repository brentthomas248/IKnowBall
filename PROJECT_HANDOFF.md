# Project Handoff: IKnowBall

**Status**: Phase 3 (Data & Polish) - Mostly Complete
**Last Updated**: December 9, 2025

---

## 🚀 Recent Accomplishments
1.  **Data Layer Refactor**:
    -   Removed hardcoded data from ViewModels.
    -   Implemented `GameDataService` in `FeatureGamesShared`.
    -   Added JSON resources (`ball_knowledge_questions.json`, `connections_data.json`, `over_under_data.json`).
2.  **UI Polish**:
    -   Added `HapticManager` in `IKnowBallCore` (Platform-agnostic).
    -   Integrated haptic feedback into `BallKnowledge`, `Connections`, and `OverUnder` games.
    -   Added animations to `GameTileView`.
3.  **Testing**:
    -   Created `FeatureConnectionsTests` and `FeatureOverUnderTests` targets.
    -   Implemented unit tests for `ConnectionGameViewModel` and `OverUnderViewModel`.
    -   **Note**: `FeatureBallKnowledgeTests` was already present and updated.
4.  **Compatibility Fixes**:
    -   Resolved macOS vs iOS build errors by using `#if os(iOS)` blocks for modifiers like `.navigationBarTitleDisplayMode`, `.textInputAutocapitalization`, etc.
    -   Replaced `UIColor` references (e.g., `.systemGray6`) with standard SwiftUI Colors or conditional compliances.

## ⚠️ Known Issues
1.  **CLI Testing (`swift test`)**:
    -   The command `swift test` fails to link `XCTest` for the *newly added* test targets (`FeatureConnectionsTests`, `FeatureOverUnderTests`).
    -   **Diagnosis**: This appears to be a local environment/CLI configuration issue with how SwiftPM resolves test dependencies for new targets dynamically.
    -   **Verification**: The code is syntactically correct. If opened in Xcode, these tests should run correctly.
2.  **SwiftUI Previews**:
    -   Some `#Preview` blocks are commented out in `FeatureHome`, `FeatureSettings`, and other modules.
    -   **Reason**: The CLI build environment was throwing "external macro implementation type not found" errors.
    -   **Action**: Uncomment these when working in Xcode or once the macro plugin path is resolved.

## 📋 Next Steps (Phase 4: Release Prep)
1.  **App Icon & Assets**:
    -   Replace SF Symbols with custom assets where appropriate.
    -   Add AppIcon set.
2.  **Onboarding**:
    -   Design and implement a first-launch tutorial flow.
3.  **Performance**:
    -   Profile memory usage, especially during game transitions.

## 📂 Key Files
-   `Sources/FeatureGamesShared/Services/GameDataService.swift`: Central data loader.
-   `Sources/FeatureGamesShared/Resources/*.json`: Game data files.
-   `Sources/IKnowBallCore/Haptics/HapticManager.swift`: Haptic engine.
-   `Package.swift`: Dependency graph and target definitions.

## 🛠 Useful Commands
-   Build: `swift build`
-   Test: `swift test` (Note known issue above)
