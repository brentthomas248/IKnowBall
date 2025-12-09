# IKnowBall iOS Project Context

## Project Information
- **Name**: IKnowBall
- **Platform**: iOS
- **Framework**: SwiftUI
- **Architecture**: MVVM with Feature-First structure

## Connected Extensions

### iOS Master Architect Extension
You have access to the **iOS Master Architect** skill library located at:
`/Users/brentthomas1/Desktop/Brent/Projects/MasterSkillsRepo/ios-master-skills`

**IMPORTANT**: Before performing any iOS development task, you MUST read the routing table from:
`/Users/brentthomas1/Desktop/Brent/Projects/MasterSkillsRepo/ios-master-skills/GEMINI.md`

This extension provides three core skills:

1. **Scaffold New App** - Initialize projects with Golden Path structure
   - Trigger: "Start a new app", "Init project", "Create feature structure"
   - File: `ios-master-skills/skills/scaffold_new_app/SKILL.md`

2. **Design Screen** - Create HIG-compliant UI specifications
   - Trigger: "Design a screen", "Plan UI", "Wireframe"
   - File: `ios-master-skills/skills/design_screen/SKILL.md`

3. **Implement Component** - Generate production SwiftUI code
   - Trigger: "Build a button", "Implement view", "Create component"
   - File: `ios-master-skills/skills/implement_component/SKILL.md`

## Knowledge Base

The extension includes comprehensive Apple HIG knowledge:
- `ios-master-skills/knowledge/ios_hig/layout.md` - Touch targets, safe areas
- `ios-master-skills/knowledge/ios_hig/typography.md` - Dynamic Type, semantic styles
- `ios-master-skills/knowledge/ios_hig/colors.md` - Semantic color system
- `ios-master-skills/knowledge/swiftui/golden_path.md` - Project architecture

## Development Guidelines

When working on this project:
1. Always follow Apple Human Interface Guidelines (44pt touch targets, Dynamic Type, semantic colors)
2. Use the Feature-First folder structure defined in `golden_path.md`
3. Implement MVVM pattern with State enums in ViewModels
4. Use SwiftLint rules from `ios-master-skills/knowledge/swiftui/swiftlint_rules.yml`
5. Never use hardcoded sizes, colors, or fonts - always use semantic tokens

## First Steps

If this is a new project, start by asking me to:
1. "Initialize the iOS project structure with the Golden Path"
2. "What features should we build first?"
