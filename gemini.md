# IKnowBall iOS Project Context

## Project Information
- **Name**: IKnowBall
- **Platform**: iOS
- **Framework**: SwiftUI
- **Architecture**: Modular 10-Target SPM Structure (MVVM)

## 🏗 Modular Architecture (New!)

We have refactored the app into **10 strict Swift Package Manager targets**. All agents MUST respect these boundaries to prevent build errors and circular dependencies.

### Module Hierarchy
```
Sources/
├── IKnowBallApp/        # @main Entry Point, Dependency Assembly
├── IKnowBallCore/       # Shared Utilities (Extensions, Constants)
├── IKnowBallDesignSystem/ # UI Tokens (Colors, Typography) & Components
├── FeatureHome/         # Dashboard & Navigation Routing
├── FeatureSettings/     # Settings Feature
├── FeatureGamesShared/  # Shared Game Models (GameItem, GameTile) & Types
├── FeatureBallKnowledge/# Specific Game Logic & Views
├── FeatureConnections/  # Specific Game Logic & Views
├── FeatureOverUnder/    # Specific Game Logic & Views
└── FeatureScoreSummary/ # Shared Results/Summary Screen
```

### 🚨 Critical Development Rules for Agents

#### 1. File Placement Compliance
- **Never** create files in root `Sources/`. Always place them in the correct Feature or Core module.
- **New Features**: Create a new module in `Package.swift` and a corresponding folder in `Sources/`.
- **UI Components**: Reusable UI elements MUST go in `IKnowBallDesignSystem`.

#### 2. Access Control
- **Default is Internal**: Swift defaults to internal visibility.
- **Cross-Module Rules**: If a View or Model needs to be seen by another module (e.g., Home needs to see a GameView), you **MUST** mark it `public` and add a `public init`.
- **Example**:
    ```swift
    public struct MyGameView: View {
        public init() {} // Required for external instantiation
        public var body: some View { ... }
    }
    ```

#### 3. Import Management
- You must explicitly `import` the modules you need.
- **Common Imports**:
    ```swift
    import SwiftUI
    import IKnowBallDesignSystem // For buttons, tokens
    import FeatureGamesShared   // For GameItem, GameTile
    ```

#### 4. The "Golden Path" Standards (from Master Skills)
- **MVVM**: Separation of concerns is mandatory. logic in `ViewModel`, UI in `View`.
- **Semantic Tokens**: Use `.padding(.md)` instead of `16`. Use `.font(.body)`.
- **Touch Targets**: Minimum 44x44pt.

#### 5. Feature Isolation & Anti-Patterns
- **Do NOT** place files in `Sources/` root. Always use the correct module.
- **Do NOT** import `FeatureHome` into a Game module (creates circular dependency).
- **Navigation Flow**: `Home` knows about `Games`, but `Games` do not know about `Home` (use callbacks or coordinator pattern).

#### 6. File Placement Guidelines
- **New Features**: Create new folder `Sources/FeatureName` and add target to `Package.swift`.
- **New Shared Logic**: Put in `Sources/IKnowBallCore` or `FeatureGamesShared`.
- **New UI Component**: Put in `Sources/IKnowBallDesignSystem`.

## Connected Extensions

### iOS Master Architect Extension
You have access to the **iOS Master Architect** skill library located at:
`/Users/brentthomas1/Desktop/Brent/Projects/MasterSkillsRepo/ios-master-skills`

**Skill Routing Protocol:**
You MUST read the routing table at `/Users/brentthomas1/Desktop/Brent/Projects/MasterSkillsRepo/ios-master-skills/GEMINI.md` to determine which skill file to load for any iOS development task. Do not rely on hardcoded triggers in this file—the extension's GEMINI.md is the authoritative source.

## Knowledge Base

The extension includes comprehensive Apple HIG knowledge:
- `ios-master-skills/knowledge/ios_hig/layout.md` - Touch targets, safe areas
- `ios-master-skills/knowledge/ios_hig/typography.md` - Dynamic Type, semantic styles
- `ios-master-skills/knowledge/ios_hig/colors.md` - Semantic color system
- `ios-master-skills/knowledge/swiftui/golden_path.md` - Project architecture

## First Steps for New Agents

1. **Read this file** to understand the Module Map.
2. **Check `Package.swift`** to see the latest dependency graph.
3. **Run `swift build`** to ensure the environment is healthy before making changes.
