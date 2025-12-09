# Implementatino Roadmap

**Objective**: Scale **IKnowBall** into a fully-featured interactive iOS application.

This document tracks high-level milestones. Agents should update this file after completing significant feature blocks.

---

## 🟢 Phase 1: Foundation (Current Status: COMPLETE)
*Goal: Establish core architecture, navigation, and basic feature shells.*

- [x] **Project Scaffolding**: Golden Path directory structure (`Sources/Features/`).
- [x] **Navigation Architecture**: `NavigationStack` based routing (Home -> Settings).
- [x] **Home Feature**: Basic dashboard with mock data and scrollable layout.
- [x] **Settings Feature**: Preferences management and placeholder profile sections.
- [x] **Design System**: Basic token implementation (Spacing, Colors).

---

## 🟢 Phase 2: Core Gameplay Loop (Current Status: COMPLETE)
*Goal: Implement the primary user interactive experience (The "Game").*

- [x] **Game Data Models**: Defined `GameTileModel` and ViewModels for all games.
- [x] **GameCoordinator**: Managed via `ScoreSummaryView` and ViewModels.
- [x] **GameView**: 
    - [x] Design the primary gameplay screen (Timer, Score, Interactions).
    - [x] Implement interactive components (Cards, Buttons).
    - [x] **Feature: Ball Knowledge**: Implemented Grid-based guessing game using MVVM.
    - [x] **Feature: Connections**: Implemented Group-based logic game.
    - [x] **Feature: Over/Under**: Implemented Stat-based guessing game.
- [x] **Results Screen**: Shared `FeatureScoreSummary` module with "Play Again" and "Home" flows.

---

## 🟡 Phase 3: Data & Polish (In Progress)
*Goal: Move from mock data to real persistence and high-fidelity UI.*

- [/] **User Progression**:
    - [x] **Persistence**: Implemented `UserProfileService` (UserDefaults) for Level/XP.
    - [x] **Gamification**: Home Dashboard updates with real stats.
- [x] **Data Persistence**: 
    - [x] Create `GameDataService` (JSON) to replace hardcoded game content.
- [x] **UI Polish**:
    - [x] Add transition animations between states.
    - [x] Implement Dark Mode specific tweaks.
    - [x] Add Haptic Feedback engine.
- [ ] **Unit Testing**: 
    - [x] **Infrastructure**: Added Test Target for FeatureBallKnowledge.
    - [x] **Ball Knowledge**: Implemented tests for ViewModel logic.
    - [ ] Add tests for other features (Connections, Over/Under).

---

*Last Updated: Dec 9, 2025*
