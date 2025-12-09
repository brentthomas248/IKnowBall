# Implementation Roadmap

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

## 🟡 Phase 2: Core Gameplay Loop (Next Up)
*Goal: Implement the primary user interactive experience (The "Game").*

- [/] **Game Data Models**: Defined `GameTileModel` and ViewModels for Ball Knowledge.
- [ ] **GameCoordinator**: Create a service to manage game state (Active, Paused, Finished).
- [/] **GameView**: 
    - [x] Design the primary gameplay screen (Timer, Score, Interactions).
    - [x] Implement interactive components (Cards, Buttons).
    - [x] **Feature: Ball Knowledge**: Implemented Grid-based guessing game using MVVM.
- [ ] **Results Screen**: Summary view with "Play Again" flows.

---

## ⚪️ Phase 3: Data & Polish
*Goal: Move from mock data to real persistence and high-fidelity UI.*

- [ ] **Data Persistence**: 
    - [ ] Implement `SwiftData` or `UserDefaults` for user stats and settings.
    - [ ] Create `DataService` layer.
- [ ] **UI Polish**:
    - [ ] Add transition animations between states.
    - [ ] Implement Dark Mode specific tweaks.
    - [ ] Add Haptic Feedback engine.
- [ ] **Unit Testing**: 
    - [ ] Test `SettingsViewModel` logic.
    - [ ] Test `GameCoordinator` state machine.

---

## 🔴 Phase 4: Release Prep
*Goal: Production readiness.*

- [ ] **App Icon & Assets**: Replace system images with custom assets.
- [ ] **Onboarding Flow**: First-launch tutorial.
- [ ] **Performance Profiling**: Analyze memory usage in Instruments.

---

*Last Updated: Dec 8, 2025*
