---
description: "Reference guide for IKnowBall iOS development standards, architecture, and best practices."
---

# IKnowBall Development Standards

This document serves as the **Single Source of Truth** for architectural decisions and rules in the IKnowBall project. All agents should consult this before generating code.

## 1. Modular Architecture (Strict)

The app is split into **10 Swift Package Manager targets**.

### Module Map
- **App Layer**: `IKnowBallApp`
- **Core Layer**: `IKnowBallCore` (Extensions), `IKnowBallDesignSystem` (UI)
- **Feature Layer**:
    - `FeatureHome`: Dashboard
    - `FeatureSettings`: User preferences
    - `FeatureBallKnowledge`: Game Implementation
    - `FeatureConnections`: Game Implementation
    - `FeatureOverUnder`: Game Implementation
- **Shared Game Layer**:
    - `FeatureGamesShared`: Models (`GameItem`) & Types shared by games
    - `FeatureScoreSummary`: Result screens used by games

### Rule: Imports
You must explicitly import dependencies.
```swift
import SwiftUI
import IKnowBallDesignSystem
import FeatureGamesShared
```

## 2. Access Control Rule

By default, Swift types are `internal`. Use `public` for anything cross-module.

**Requirement**:
If a View/ViewModel is moved to a Feature module, it usually needs to be `public` so `FeatureHome` can initialize it.

```swift
public struct MyView: View {
    public init() {} // REQUIRED
    ...
}
```

## 3. Design System Rule

**NEVER** use hardcoded values. Use `IKnowBallDesignSystem`.

- **Spacing**: `.padding(.md)` (not `.padding(16)`)
- **Colors**: `.foregroundStyle(.primary)` or custom tokens.
- **Components**: Use `PrimaryButton`, `GameTileView` etc.

## 4. Feature Isolation Rule

- **Do NOT** place files in `Sources/` root.
- **Do NOT** import `FeatureHome` into a Game module (circular dependency).
- **Navigation**: `Home` knows about `Games`, but `Games` do not know about `Home` (except via callbacks or coordinator pattern).

## 5. File Locations

- **New Features**: Create new folder `Sources/FeatureName`.
- **New Shared Logic**: Put in `Sources/IKnowBallCore` or `FeatureGamesShared`.
- **New UI Component**: Put in `Sources/IKnowBallDesignSystem`.
