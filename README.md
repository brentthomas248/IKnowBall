# IKnowBall iOS Project

## 👋 Welcome & Context
**IKnowBall** is a production-grade iOS application built with **SwiftUI** and **MVVM**. This project strict adherence to the "Golden Path" architecture and Apple's Human Interface Guidelines (HIG).

This repository is designed to be **agent-friendly**. If you are an AI assistant joining this project, this guide is your primary source of truth.

---

## 🏗 Architecture

### Golden Path Structure
We follow a **Feature-First** directory structure. Do not place files in the root `Sources` directory unless they are app-wide configuration.

```
Sources/
├── App/                 # App Lifecycle & Entry Points
│   ├── IKnowBallApp.swift
│   └── ContentView.swift
├── Features/            # Self-contained feature modules
│   ├── Home/
│   │   ├── Views/       # SwiftUI Views
│   │   ├── ViewModels/  # @Observable classes
│   │   ├── Models/      # Feature-specific models
│   │   └── Services/    # Logic & Data fetching
│   └── Settings/
│       └── ...
└── Shared/              # Reusable components & Core extensions
    ├── DesignSystem/
    └── Models/
```

### Key Technologies
*   **UI Framework**: SwiftUI (iOS 17+)
*   **State Management**: MVVM with `@Observable` (Swift 5.9+)
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

---

## 📂 Feature Registry

| Feature | Status | Description |
| :--- | :--- | :--- |
| **Home** | 🟢 Beta | Dashboard with user stats and game list. |
| **Settings** | 🟢 V1 | User preferences (Sound, Haptics) and Profile/Help links. |
| **Game** | ⚪️ Planned | Core gameplay loop. |

---

*Verified by Senior Architect Agent on Dec 8, 2025.*
