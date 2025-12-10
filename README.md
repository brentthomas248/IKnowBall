# IKnowBall iOS Project

## 👋 Welcome & Context
**IKnowBall** is a production-grade iOS application built with **SwiftUI** and **MVVM**. This project strict adherence to the "Golden Path" architecture and Apple's Human Interface Guidelines (HIG).

This repository is designed to be **agent-friendly**. If you are an AI assistant joining this project, this guide is your primary source of truth.

---

## 🏗 Architecture

### Modular Architecture
We follow a strictly modularized architecture with 10 distinct SPM targets.

**Module Hierarchy:**
```
Sources/
├── IKnowBallApp/        # @main Entry Point
├── IKnowBallCore/       # Shared Utilities
├── IKnowBallDesignSystem/ # UI Tokens & Components (Public)
├── FeatureHome/         # Dashboard & Routing
├── FeatureSettings/     # Settings Feature
├── FeatureGamesShared/  # Shared Game Models (GameItem, GameTile)
├── FeatureBallKnowledge/# Specific Game Logic
├── FeatureConnections/  # Specific Game Logic
├── FeatureOverUnder/    # Specific Game Logic
└── FeatureScoreSummary/ # Shared Results Screen
```

### Dependency Graph
- **Features** (Home, Games, Settings) depend on **DesignSystem** and **Core**.
- **Home** depends on all Game Features.
- **Game Features** depend on **FeatureGamesShared** and **FeatureScoreSummary**.

### Key Technologies
*   **UI Framework**: SwiftUI (iOS 17+)
*   **State Management**: MVVM with `@Observable` (Swift 5.9+)
*   **Logging**: OSLog `Logger` for production-ready structured logging
*   **Navigation**: `NavigationStack` with programmatic paths where necessary.
*   **Package Management**: Swift Package Manager (Local `IKnowBallFeature` package).

---

## 🤖 AI Agent Protocol / "Skills"

This project is linked to the **iOS Master Skills** extension (`ios-master-skills copy`). You MUST check this extension for protocols before starting work.

| Task Category | Required Skill / Protocol |
| :--- | :--- |
| **New Features** | `design_screen` (Design interactions FIRST) |
| **Project Setup** | `scaffold_new_app` (Only for new repos) |
| **Coding** | `implement_component` (Strict HIG compliance) |

### Inviolable Rules
1.  **Design First**: Never write SwiftUI code without a confirmed design plan (JSON/Markdown).
2.  **No Magic Numbers**: Use semantic tokens (e.g., `.padding(.md)`) from the Design System.
3.  **Touch Targets**: Minimum **44x44pt** for ANY interactive element.
4.  **Accessibility**: All interactive elements must have labels.

---

## 🚀 Getting Started

### 1. Build & Run
The project is set up as a hybrid App + Swift Package structure.
*   **Open**: `IKnowBall.xcodeproj` or open the root folder in VS Code.
*   **Target**: Ensure `IKnowBall` (App) is the active scheme.
*   **Run**: `Cmd + R`

### 2. Common Troubleshooting
*   **"Missing Module"**: Ensure the `IKnowBallFeature` local package is linked in `Frameworks, Libraries, and Embedded Content`.
*   **"Preview Failed"**: Check `Package.swift` to ensure your new files are included in the target.

### 3. Running Tests
Tests are located in the `Tests/` directory and require Xcode to run:
```bash
# Open in Xcode
open IKnowBall.xcodeproj
# Run tests: Cmd + U
```

---

## 🎯 Code Quality

### Production-Ready Infrastructure
- **Logging**: All print statements replaced with OSLog `Logger` (17 instances fixed)
- **Design System**: Complete semantic token coverage - zero hardcoded values
- **Testing**: 10 test methods across 3 ViewModels (Ball Knowledge, Connections, Over/Under)
- **SwiftLint**: Zero violations - strict code quality enforcement

### Design System Tokens
- **Colors**: 18 semantic colors with light/dark mode support
- **Spacing**: T-shirt sizing (`.xxs` to `.xxl`)
- **Typography**: 16 Dynamic Type font styles
- **Sizes**: Component dimensions including touch targets (44×44pt minimum)

### Recent Improvements (Dec 9, 2025)
✅ Replaced all print statements with production Logger  
✅ Added missing size tokens (`.buttonHeightCompact`, `.gameButtonHeight`, `.spacerLarge`)  
✅ Fixed all hardcoded frame sizes in views  
✅ Restored and verified test suite

---

## 📂 Feature Registry

| Feature | Status | Description |
| :--- | :--- | :--- |
| **Home** | 🟢 Beta | Dashboard with user stats and game list. |
| **Settings** | 🟢 V1 | User preferences (Sound, Haptics) and Profile/Help links. |
| **Game** | 🟢 Beta | Core gameplay loop (Ball Knowledge, Connections, Over/Under). |

---

*Last verified: Dec 9, 2025 - Production-ready with professional code quality standards.*
